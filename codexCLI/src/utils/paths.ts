/**
 * Path utilities for CodexCLI
 * 
 * This module handles path resolution and directory management for application data.
 * It automatically determines the appropriate storage locations based on the execution
 * environment (development vs. production) and ensures the necessary directories exist.
 */
import * as path from 'path';
import * as os from 'os';
import * as fs from 'fs';

/**
 * Determines if the application is running in development mode
 * 
 * Checks multiple indicators to reliably detect development environments:
 * 1. NODE_ENV environment variable set to 'development'
 * 2. Running via ts-node (TypeScript development)
 * 3. Running through an npm development script
 * 
 * @returns {boolean} True if running in development mode, false otherwise
 */
export function isDev(): boolean {
  // If NODE_ENV is explicitly set to development
  const isEnvDev = process.env.NODE_ENV === 'development';

  // Check if we're running via ts-node
  const isTsNode = Boolean(process.argv[1] && process.argv[1].includes('ts-node'));

  // Check if we're running with npm run dev
  const isNpmDev = Boolean(process.env.npm_lifecycle_script &&
    process.env.npm_lifecycle_script.includes('ts-node'));

  return isEnvDev || isTsNode || isNpmDev;
}

/**
 * Gets the appropriate directory for storing application data
 * 
 * Uses different locations based on the execution environment:
 * - Development: Creates a .dev-data directory in the project root
 * - Production: Uses ~/.codexcli directory in the user's home folder
 * 
 * Automatically ensures the target directory exists before returning.
 * 
 * @returns {string} Absolute path to the data directory
 */
export function getDataDir(): string {
  if (isDev()) {
    // In development mode, use a directory in the project
    const projectDir = path.resolve(__dirname, '..', '..');
    const devDataDir = path.join(projectDir, '.dev-data');

    // Ensure directory exists
    if (!fs.existsSync(devDataDir)) {
      fs.mkdirSync(devDataDir, { recursive: true });
    }

    return devDataDir;
  } else {
    // In production mode, use the user's home directory
    const prodDataDir = path.join(os.homedir(), '.codexcli');

    // Ensure directory exists
    if (!fs.existsSync(prodDataDir)) {
      fs.mkdirSync(prodDataDir, { recursive: true });
    }

    return prodDataDir;
  }
}

/**
 * Gets the full path to the data storage file
 * 
 * @returns {string} Absolute path to the JSON data file
 */
export function getDataFilePath(): string {
  return path.join(getDataDir(), 'data.json');
}

/**
 * Gets the full path to the configuration file
 * 
 * @returns {string} Absolute path to the JSON config file
 */
export function getConfigFilePath(): string {
  return path.join(getDataDir(), 'config.json');
}