#!/usr/bin/env node

/**
 * Merge immutable and mutable OpenClaw config layers.
 *
 * This script owns the runtime config lifecycle:
 * 1. Ensure a writable runtime config exists (seed/dereference as needed).
 * 2. Merge immutable base config with allowlisted mutable paths from runtime.
 * 3. Write the merged output atomically with mode 0600.
 */

import fs from "node:fs/promises";
import path from "node:path";

function usage() {
  const text =
    "usage: reconcile-config.mjs --base <path> --runtime <path> --backup <path> [--mutable-path <dot.path>]... [--seed-from-backup]";
  throw new Error(text);
}

function parseArgs(argv) {
  const parsed = {
    base: "",
    runtime: "",
    backup: "",
    mutablePaths: [],
    seedFromBackup: false,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--seed-from-backup") {
      parsed.seedFromBackup = true;
      continue;
    }

    if (arg === "--base" || arg === "--runtime" || arg === "--backup" || arg === "--mutable-path") {
      const value = argv[index + 1];
      if (!value) {
        usage();
      }
      index += 1;
      if (arg === "--base") {
        parsed.base = value;
      } else if (arg === "--runtime") {
        parsed.runtime = value;
      } else if (arg === "--backup") {
        parsed.backup = value;
      } else {
        parsed.mutablePaths.push(value);
      }
      continue;
    }

    usage();
  }

  if (!parsed.base || !parsed.runtime || !parsed.backup) {
    usage();
  }

  return parsed;
}

async function pathExists(filePath) {
  try {
    await fs.lstat(filePath);
    return true;
  } catch {
    return false;
  }
}

async function readJson(filePath) {
  const raw = await fs.readFile(filePath, "utf8");
  return JSON.parse(raw);
}

async function writeJsonAtomic(filePath, value, mode = 0o600) {
  const parentDir = path.dirname(filePath);
  await fs.mkdir(parentDir, { recursive: true });

  const tempPath = path.join(
    parentDir,
    `.openclaw-json-${process.pid}-${Date.now()}-${Math.random().toString(16).slice(2)}`,
  );

  const json = `${JSON.stringify(value, null, 2)}\n`;
  try {
    await fs.writeFile(tempPath, json, { encoding: "utf8", mode });
    await fs.chmod(tempPath, mode);
    await fs.rename(tempPath, filePath);
    await fs.chmod(filePath, mode);
  } finally {
    if (await pathExists(tempPath)) {
      await fs.unlink(tempPath);
    }
  }
}

async function ensureRegularRuntimeFile(runtimePath) {
  let stats;
  try {
    stats = await fs.lstat(runtimePath);
  } catch {
    return;
  }
  if (!stats.isSymbolicLink()) {
    return;
  }
  const data = await fs.readFile(runtimePath, "utf8");
  await writeJsonAtomic(runtimePath, JSON.parse(data));
}

async function seedRuntimeFile(runtimePath, backupPath, basePath, seedFromBackup) {
  if (await pathExists(runtimePath)) {
    return;
  }

  await fs.mkdir(path.dirname(runtimePath), { recursive: true });
  if (seedFromBackup && (await pathExists(backupPath))) {
    await fs.copyFile(backupPath, runtimePath);
    await fs.chmod(runtimePath, 0o600);
    return;
  }

  await fs.copyFile(basePath, runtimePath);
  await fs.chmod(runtimePath, 0o600);
}

function parsePath(rawPath) {
  return rawPath
    .split(".")
    .map((segment) => segment.trim())
    .filter(Boolean);
}

function listKeys(value) {
  if (Array.isArray(value)) {
    return value.map((_, index) => index);
  }
  if (value !== null && typeof value === "object") {
    return Object.keys(value);
  }
  return [];
}

function getChild(value, key) {
  if (Array.isArray(value)) {
    if (typeof key === "number" && key >= 0 && key < value.length) {
      return [true, value[key]];
    }
    return [false, null];
  }
  if (value !== null && typeof value === "object") {
    if (Object.hasOwn(value, key)) {
      return [true, value[key]];
    }
    return [false, null];
  }
  return [false, null];
}

function deepClone(value) {
  return globalThis.structuredClone(value);
}

function setPathValue(target, pathTokens, value) {
  if (pathTokens.length === 0) {
    return deepClone(value);
  }

  const first = pathTokens[0];
  if (typeof first === "number") {
    if (!Array.isArray(target)) {
      target = [];
    }
  } else if (target === null || typeof target !== "object" || Array.isArray(target)) {
    target = {};
  }

  let cursor = target;
  for (let index = 0; index < pathTokens.length; index += 1) {
    const token = pathTokens[index];
    const isLast = index === pathTokens.length - 1;
    if (typeof token === "number") {
      if (!Array.isArray(cursor)) {
        cursor = [];
      }
      while (cursor.length <= token) {
        cursor.push(null);
      }
      if (isLast) {
        cursor[token] = deepClone(value);
        break;
      }

      const nextToken = pathTokens[index + 1];
      const child = cursor[token];
      if (child === null || typeof child !== "object") {
        cursor[token] = typeof nextToken === "number" ? [] : {};
      }
      cursor = cursor[token];
      continue;
    }

    if (cursor === null || typeof cursor !== "object" || Array.isArray(cursor)) {
      cursor = {};
    }
    if (isLast) {
      cursor[token] = deepClone(value);
      break;
    }

    const nextToken = pathTokens[index + 1];
    const existing = cursor[token];
    if (existing === null || typeof existing !== "object") {
      cursor[token] = typeof nextToken === "number" ? [] : {};
    }
    cursor = cursor[token];
  }

  return target;
}

function expandRuntimeMatches(runtime, pathTokens) {
  const walk = (node, remaining, concrete) => {
    if (remaining.length === 0) {
      return [concrete];
    }

    const [head, ...tail] = remaining;
    if (head === "*") {
      const matches = [];
      for (const key of listKeys(node)) {
        const [found, child] = getChild(node, key);
        if (!found) {
          continue;
        }
        matches.push(...walk(child, tail, [...concrete, key]));
      }
      return matches;
    }

    let key = head;
    if (Array.isArray(node)) {
      const maybeNumber = Number.parseInt(head, 10);
      if (!Number.isFinite(maybeNumber)) {
        return [];
      }
      key = maybeNumber;
    }

    const [found, child] = getChild(node, key);
    if (!found) {
      return [];
    }
    return walk(child, tail, [...concrete, key]);
  };

  return walk(runtime, pathTokens, []);
}

function resolveRuntimeValue(runtime, concretePath) {
  let cursor = runtime;
  for (const token of concretePath) {
    const [found, child] = getChild(cursor, token);
    if (!found) {
      return [false, null];
    }
    cursor = child;
  }
  return [true, cursor];
}

function mergeMutablePaths(base, runtime, mutablePaths) {
  let merged = deepClone(base);
  for (const rawPath of mutablePaths) {
    const tokens = parsePath(rawPath);
    if (tokens.length === 0) {
      continue;
    }

    const concretePaths = expandRuntimeMatches(runtime, tokens);
    for (const concretePath of concretePaths) {
      const [found, runtimeValue] = resolveRuntimeValue(runtime, concretePath);
      if (!found) {
        continue;
      }
      merged = setPathValue(merged, concretePath, runtimeValue);
    }
  }
  return merged;
}

async function verifyFileMode(filePath, expectedMode = 0o600) {
  const stats = await fs.stat(filePath);
  const currentMode = stats.mode & 0o777;
  if (currentMode !== expectedMode) {
    await fs.chmod(filePath, expectedMode);
  }
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const basePath = path.resolve(args.base);
  const runtimePath = path.resolve(args.runtime);
  const backupPath = path.resolve(args.backup);

  const base = await readJson(basePath);
  await ensureRegularRuntimeFile(runtimePath);
  await seedRuntimeFile(runtimePath, backupPath, basePath, args.seedFromBackup);
  const runtime = await readJson(runtimePath);

  const merged = mergeMutablePaths(base, runtime, args.mutablePaths);
  await writeJsonAtomic(runtimePath, merged, 0o600);
  await verifyFileMode(runtimePath, 0o600);
}

await main();
