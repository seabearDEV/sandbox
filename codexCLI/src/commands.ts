/**
 * Implementation of core CodexCLI commands
 * 
 * This module contains the business logic for all CLI commands,
 * handling data operations and user feedback. Each command function 
 * corresponds to a CLI command defined in index.ts.
 */
import { loadData, saveData, handleError } from './storage';
import { setNestedValue, getNestedValue, removeNestedValue, flattenObject } from './utils';
import { formatKeyValue, displayTree } from './formatting';
import { getAliasesForPath } from './alias';
import chalk from 'chalk';


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
  
  // Raw output for scripting
  if (options.raw) {
    if (typeof value === 'object' && value !== null) {
      console.log(JSON.stringify(value));
    } else {
      console.log(value);
    }
    return;
  }
  
  // Tree display for objects when tree option is set
  if (options.tree && typeof value === 'object' && value !== null) {
    displayTree({ [key]: value });
    return;
  }
  
  // Existing formatted output
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
 * Applies different colors to each level of a path
 * @param {string} path - The dot-separated path to colorize
 * @returns {string} - The colorized path
 */
function colorizePathByLevels(path: string): string {
  const colors = [chalk.cyan, chalk.yellow, chalk.green, chalk.magenta, chalk.blue];
  const parts = path.split('.');
  
  // Apply a different color to each path segment
  return parts.map((part, index) => {
    const colorFn = colors[index % colors.length];
    return colorFn(part);
  }).join('.');
}

/**
 * Lists all entries in storage with optional path filtering
 * Displays entries in a formatted, hierarchical view
 * 
 * @param {string} [path] - Optional path prefix to filter displayed entries
 * @param {Object} [options] - Display options (e.g., {tree: true} for tree view)
 */
export function listEntries(path?: string, options: any = {}): void {
  try {
    const data = loadData();
    
    // Debug log to verify options
    if (process.env.DEBUG === 'true') {
      console.log('Options received:', options);
    }
    
    if (Object.keys(data).length === 0) {
      console.log('No entries found.');
      return;
    }
    
    // Handle tree display if option is set
    if (options.tree === true) {
      if (process.env.DEBUG === 'true') {
        console.log('Tree display enabled');
      }
      
      if (path) {
        // For a specific path, create a sub-object with just that branch
        const pathParts = path.split('.');
        let current: any = data;
        
        // Navigate to the requested path
        for (let i = 0; i < pathParts.length; i++) {
          const part = pathParts[i];
          if (current[part] === undefined) {
            console.log(`Path '${path}' not found.`);
            return;
          }
          current = current[part];
        }
        
        // Display just this subtree
        displayTree({ [path]: current });
      } else {
        // Display the complete tree
        displayTree(data);
      }
      return;
    }
    
    // Normal flat display (existing code)
    const flattenedData = flattenObject(data);
    
    if (path) {
      // Filter by path prefix
      const filteredEntries: Record<string, string> = {};
      const prefix = path + '.';
      
      // Include exact match
      if (flattenedData[path] !== undefined) {
        filteredEntries[path] = flattenedData[path];
      }
      
      // Include all children
      Object.entries(flattenedData).forEach(([key, value]) => {
        if (key.startsWith(prefix)) {
          filteredEntries[key] = value;
        }
      });
      
      if (Object.keys(filteredEntries).length === 0) {
        console.log(`No entries found under '${path}'.`);
        return;
      }
    }

    // Format and display entries, now with aliases
    Object.entries(flattenedData).forEach(([key, value]) => {
      // Get the full path for this entry
      const fullPath = path ? `${path}.${key}` : key;
      
      // Find aliases that point to this path
      const aliases = getAliasesForPath(fullPath);
      
      // Format the value as needed
      const displayValue = typeof value === 'object' 
        ? chalk.gray('[Object]') 
        : value.toString();
      
      // Apply different colors to each level of the path
      const colorizedPath = colorizePathByLevels(fullPath);
      
      // Display with the format: path (alias) content
      if (aliases.length > 0) {
        console.log(`${colorizedPath} ${chalk.blue('(' + aliases[0] + ')')} ${displayValue}`);
      } else {
        console.log(`${colorizedPath} ${displayValue}`);
      }
    });
  } catch (error) {
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
 * @param {Object} options - Display options (e.g., {tree: true} for tree view)
 */
export function searchEntries(searchTerm: string, options: any = {}): void {
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
  
  // Use tree display if requested
  if (options?.tree) {
    // Create an object with just the matching entries
    const matchesObj = {};
    Object.keys(matches).forEach(key => {
      setNestedValue(matchesObj, key, matches[key]);
    });
    displayTree(matchesObj);
    return;
  }
  
  // Default display with color-coded keys
  Object.entries(matches).forEach(([key, value]) => {
    formatKeyValue(key, value);
  });
}