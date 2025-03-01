import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';
import { CodexData } from './types';
import chalk from 'chalk';

// Define data storage location
const DATA_DIR = path.join(os.homedir(), '.codexcli');
const DATA_FILE = path.join(DATA_DIR, 'data.json');

/**
 * Ensure data directory exists
 */
function ensureDataDir(): void {
  if (!fs.existsSync(DATA_DIR)) {
    fs.mkdirSync(DATA_DIR, { recursive: true });
  }
}

/**
 * Load data from storage
 */
export function loadData(): CodexData {
  ensureDataDir();
  
  // Initialize with empty object if file doesn't exist
  if (!fs.existsSync(DATA_FILE)) {
    saveData({}); // Create the file with empty object
    return {};
  }
  
  try {
    const fileContent = fs.readFileSync(DATA_FILE, 'utf8');
    
    // Handle empty file case
    if (!fileContent || fileContent.trim() === '') {
      saveData({}); // Rewrite with valid empty JSON object
      return {};
    }
    
    // Parse and return the data
    return JSON.parse(fileContent);
  } catch (error) {
    console.error('Error reading data file. Creating a new one.');
    
    // If there's a JSON parsing error, create a new valid file
    saveData({});
    return {};
  }
}

/**
 * Save data to storage
 */
export function saveData(data: CodexData): void {
  ensureDataDir();
  try {
    fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2), 'utf8');
  } catch (error) {
    handleError('Error writing data file:', error);
  }
}

/**
 * Standardized error handling
 */
// Enhanced error handling with colorized errors
export function handleError(message: string, error?: unknown): void {
  console.error(chalk.red('ERROR: ') + message);
  if (error) {
    if (error instanceof Error) {
      console.error(chalk.red('Details: ') + error.message);
    } else {
      console.error(chalk.red('Details: '), error);
    }
  }
  process.exit(1);
}