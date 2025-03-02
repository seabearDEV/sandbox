/**
 * Data storage management module for CodexCLI
 * 
 * This module handles all data persistence operations, including reading from
 * and writing to the JSON storage file. It provides error handling and ensures
 * that the storage directory exists before attempting file operations.
 */
import * as fs from 'fs';
import { getDataFilePath, getDataDir } from './utils/paths';
import { CodexData } from './types';
import chalk from 'chalk';

/**
 * Path to the JSON data file
 * Retrieved from utility function to ensure consistent location across the application
 */
const DATA_FILE = getDataFilePath();

/**
 * Ensure data directory exists
 * 
 * This function is kept for documentation purposes but actual directory creation
 * is now handled by the paths.ts utility through getDataDir()
 */
function ensureDataDir(): void {
  // This is now handled in the paths.ts utility
  // getDataDir() ensures the directory exists
}

/**
 * Load data from storage
 * 
 * Reads and parses the JSON data file. Creates a new empty data file
 * if it doesn't exist or contains invalid JSON.
 * 
 * @returns {CodexData} The loaded data object, or an empty object if no data exists
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
 * 
 * Serializes the data object to JSON and writes it to the data file.
 * Uses pretty formatting with 2-space indentation for human readability.
 * 
 * @param {CodexData} data - The data object to save
 * @throws Will call handleError if file writing fails
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
 * 
 * Provides consistent error formatting with red highlighting for visibility.
 * Includes detailed error information when available and terminates the process.
 * 
 * @param {string} message - The main error message to display
 * @param {unknown} [error] - Optional error object with additional details
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