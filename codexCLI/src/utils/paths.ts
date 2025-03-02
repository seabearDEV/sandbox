/**
 * Path utilities for CodexCLI
 * 
 * This module handles path resolution and directory management for application data.
 * It automatically determines the appropriate storage locations based on the execution
 * environment (development vs. production) and ensures the necessary directories exist.
 */
import path from 'path';
import os from 'os';
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
 * Get the directory where data files should be stored
 */
export function getDataDirectory(): string {
  // For development, use the local data directory
  if (process.env.NODE_ENV === 'development') {
    return path.join(process.cwd(), 'data');
  }
  
  // For production, use ~/.codexcli
  return path.join(os.homedir(), '.codexcli');
}

/**
 * Gets the appropriate directory for storing application data
 * 
 * Uses different locations based on the execution environment:
 * - Development: Uses the project root directory
 * - Production: Uses ~/.codexcli directory in the user's home folder
 * 
 * Automatically ensures the target directory exists before returning.
 * 
 * @returns {string} Absolute path to the data directory
 */
export function getDataDir(): string {
  if (isDev()) {
    // In development mode, use the project root directory
    const projectDir = path.resolve(__dirname, '..', '..');
    return projectDir;
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
 * Returns the path to the data file
 * 
 * @returns {string} Path to the data.json file
 */
export function getDataFilePath(): string {
  if (isDev()) {
    // In development mode, use data/data.json in the project root
    const projectDir = path.resolve(__dirname, '..', '..');
    return path.join(projectDir, 'data', 'data.json');
  } else {
    // In production mode, use data.json in the dist/data directory
    const distDir = path.resolve(__dirname, '..', '..');
    return path.join(distDir, 'dist', 'data', 'data.json');
  }
}

/**
 * Get the path to the aliases file
 */
export function getAliasFilePath(): string {
  return path.join(getDataDirectory(), 'aliases.json');
}

/**
 * Ensures data.json exists in the appropriate location
 * Copies the sample file to user directory in production if needed
 */
export function ensureDataFileExists(): void {
  const dataFilePath = getDataFilePath();
  
  if (!fs.existsSync(dataFilePath)) {
    if (isDev()) {
      // In development, create an empty data file
      fs.writeFileSync(dataFilePath, JSON.stringify({}, null, 2), 'utf8');
    } else {
      // In production, copy the sample data.json from the package
      let samplePath;
      
      // Try multiple possible locations for the sample data file
      const possiblePaths = [
        // Path for when running from dist directory
        path.join(__dirname, '../../data.json'),
        // Path relative to the current file
        path.join(__dirname, '../data.json'),
        // Path using require to find package root
        path.join(path.dirname(require.resolve('@your-package-name/package.json', { paths: [process.cwd()] })), 'data.json')
      ];
      
      // Find the first valid path
      for (const possiblePath of possiblePaths) {
        if (fs.existsSync(possiblePath)) {
          samplePath = possiblePath;
          break;
        }
      }
      
      if (samplePath && fs.existsSync(samplePath)) {
        fs.copyFileSync(samplePath, dataFilePath);
      } else {
        // Fallback if sample file not found
        fs.writeFileSync(dataFilePath, JSON.stringify({
          "snippets": {
            "welcome": {
              "content": "Welcome to CodexCLI! This is a sample snippet to get you started.",
              "tags": ["sample", "welcome"],
              "created": new Date().toISOString()
            },
            "example": {
              "content": "This is an example showing how to structure your snippets.",
              "tags": ["sample", "example"],
              "created": new Date().toISOString()
            }
          }
        }, null, 2), 'utf8');
      }
    }
  }
}

/**
 * Gets the full path to the configuration file
 * 
 * @returns {string} Absolute path to the JSON config file
 */
export function getConfigFilePath(): string {
  return path.join(getDataDir(), 'config.json');
}