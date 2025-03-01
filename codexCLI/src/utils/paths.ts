import * as path from 'path';
import * as os from 'os';
import * as fs from 'fs';

// Determine if we're running in development mode
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

// Get the appropriate directory for storing data
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

// Get the full path to the data file
export function getDataFilePath(): string {
  return path.join(getDataDir(), 'data.json');
}

// Get the full path to the config file
export function getConfigFilePath(): string {
  return path.join(getDataDir(), 'config.json');
}