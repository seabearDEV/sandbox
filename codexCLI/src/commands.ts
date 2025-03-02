/**
 * Implementation of core CodexCLI commands
 * 
 * This module contains the business logic for all CLI commands,
 * handling data operations and user feedback. Each command function 
 * corresponds to a CLI command defined in index.ts.
 */
import { loadData, saveData, handleError } from './storage';
import { setNestedValue, getNestedValue, removeNestedValue, flattenObject } from './utils';
import { formatKeyValue } from './formatting';
import chalk from 'chalk';  // Terminal text styling
import ora from 'ora';      // Terminal spinner for async operations

/**
 * Prints a success message with a green checkmark
 * @param {string} message - The success message to display
 */
function printSuccess(message: string): void {
  console.log(chalk.green('✓ ') + message);
}

/**
 * Prints a warning message with a yellow warning symbol
 * @param {string} message - The warning message to display
 */
function printWarning(message: string): void {
  console.log(chalk.yellow('⚠ ') + message);
}

/**
 * Adds or updates a data entry in storage
 * Supports nested properties via dot notation (e.g., 'user.name')
 * 
 * @param {string} key - The key for the entry
 * @param {string} value - The value to store
 */
export function addEntry(key: string, value: string): void {
  try {
    const data = loadData();
    
    // Handle nested paths with dot notation
    if (key.includes('.')) {
      setNestedValue(data, key, value);
    } else {
      data[key] = value;
    }
    
    saveData(data);
    console.log(`Entry '${key}' added successfully.`);
  } catch (error) {
    handleError('Failed to add entry:', error);
  }
}

/**
 * Retrieves and displays a data entry by its key
 * Supports nested access via dot notation and different output formats
 * 
 * @param {string} key - The key to look up
 * @param {Object} options - Display options (e.g., {raw: true} for unformatted output)
 */
export function getEntry(key: string, options: any = {}): void {
  const data = loadData();
  
  // Handle nested paths
  let value;
  if (key.includes('.')) {
    value = getNestedValue(data, key);
  } else {
    value = data[key];
  }
  
  if (value === undefined) {
    console.error(`Entry '${key}' not found`);
    return;
  }
  
  // Get string representation of the value
  let stringValue: string;
  if (typeof value === 'object' && value !== null) {
    stringValue = JSON.stringify(value);
  } else {
    stringValue = String(value);
  }
  
  // Raw output for scripting
  if (options.raw) {
    console.log(stringValue);
    return;
  }
  
  // Regular formatted output
  if (typeof value === 'object' && value !== null) {
    const flatObj = flattenObject({ [key]: value }, '');
    Object.entries(flatObj).forEach(([k, v]) => {
      formatKeyValue(k, v);
    });
  } else {
    console.log(value);
  }
}

/**
 * Lists all entries in storage with optional path filtering
 * Displays entries in a formatted, hierarchical view
 * 
 * @param {string} [path] - Optional path prefix to filter displayed entries
 */
export function listEntries(path?: string): void {
  const spinner = ora('Loading data...').start();
  
  try {
    const data = loadData();
    spinner.succeed('Data loaded');
    
    if (Object.keys(data).length === 0) {
      console.log('No entries found.');
      return;
    }
    
    // Flatten nested objects for display
    const flattenedData = flattenObject(data);
    
    // If path is provided, filter entries to show only those under that path
    if (path) {
      const filteredEntries: Record<string, string> = {};
      const prefix = path + '.';
      
      // Include exact match
      if (flattenedData[path] !== undefined) {
        filteredEntries[path] = flattenedData[path];
      }
      
      // Include all children (entries starting with path + '.')
      Object.entries(flattenedData).forEach(([key, value]) => {
        if (key.startsWith(prefix)) {
          filteredEntries[key] = value;
        }
      });
      
      if (Object.keys(filteredEntries).length === 0) {
        console.log(`No entries found under '${path}'.`);
        return;
      }
      
      // Display filtered data with color-coded keys
      Object.entries(filteredEntries).forEach(([key, value]) => {
        formatKeyValue(key, value);
      });
    } else {
      // Display all entries with color-coded keys
      Object.entries(flattenedData).forEach(([key, value]) => {
        formatKeyValue(key, value);
      });
    }
  } catch (error) {
    spinner.fail('Failed to load data');
    handleError('Error listing entries:', error);
  }
}

/**
 * Removes an entry from storage by its key
 * Supports nested properties via dot notation
 * 
 * @param {string} key - The key of the entry to remove
 */
export function removeEntry(key: string): void {
  const data = loadData();
  let removed = false;
  
  // Handle nested paths
  if (key.includes('.')) {
    removed = removeNestedValue(data, key);
  } else {
    if (data[key] !== undefined) {
      delete data[key];
      removed = true;
    }
  }
  
  if (!removed) {
    printWarning(`Entry '${key}' not found.`);
    return;
  }
  
  try {
    saveData(data);
    printSuccess(`Entry '${key}' removed successfully.`);
  } catch (error) {
    handleError('Failed to remove entry:', error);
  }
}

/**
 * Searches for entries by key or value
 * Performs a case-insensitive search across all entries
 * 
 * @param {string} searchTerm - The term to search for in keys and values
 */
export function searchEntries(searchTerm: string): void {
  const data = loadData();
  
  if (Object.keys(data).length === 0) {
    console.log('No entries to search in.');
    return;
  }
  
  // Flatten nested objects for searching
  const flattenedData = flattenObject(data);
  const matches: Record<string, string> = {};
  const lcSearchTerm = searchTerm.toLowerCase();
  
  // Search in both keys and values
  Object.entries(flattenedData).forEach(([key, value]) => {
    if (
      key.toLowerCase().includes(lcSearchTerm) || 
      value.toLowerCase().includes(lcSearchTerm)
    ) {
      matches[key] = value;
    }
  });
  
  if (Object.keys(matches).length === 0) {
    console.log(`No matches found for '${searchTerm}'.`);
    return;
  }
  
  console.log(`Found ${Object.keys(matches).length} matches for '${searchTerm}':`);
  
  // Display matches with color-coded keys
  Object.entries(matches).forEach(([key, value]) => {
    formatKeyValue(key, value);
  });
}