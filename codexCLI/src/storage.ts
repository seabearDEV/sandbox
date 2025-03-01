import * as fs from 'fs';
import { getDataFilePath, getDataDir } from './utils/paths';
import { CodexData } from './types';
import chalk from 'chalk';

// Get the data file path from the utility
const DATA_FILE = getDataFilePath();

/**
 * Ensure data directory exists
 */
function ensureDataDir(): void {
  // This is now handled in the paths.ts utility
  // getDataDir() ensures the directory exists
}

/**
 * Load data from storage
 */
export function loadData(): CodexData {
  try {
    if (!fs.existsSync(DATA_FILE)) {
      saveData({});
      return {};
    }
    
    const fileContent = fs.readFileSync(DATA_FILE, 'utf8');
    
    // Handle empty file case
    if (!fileContent || fileContent.trim() === '') {
      saveData({}); 
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
  try {
    fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2), 'utf8');
  } catch (error) {
    handleError('Error writing data file:', error);
  }
}

/**
 * Standardized error handling
 */
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