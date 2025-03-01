import { loadData, saveData, handleError } from './storage';
import { setNestedValue, getNestedValue, removeNestedValue, flattenObject } from './utils';
import { formatKeyValue } from './formatting';
import chalk from 'chalk'; 
import ora from 'ora';

function printSuccess(message: string): void {
  console.log(chalk.green('✓ ') + message);
}

function printWarning(message: string): void {
  console.log(chalk.yellow('⚠ ') + message);
}

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
 * Search for entries by key or value
 * @param searchTerm The term to search for
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