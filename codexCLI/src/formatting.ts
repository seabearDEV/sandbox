/**
 * Formatting utilities for CodexCLI
 * 
 * This module provides functions for styling console output with colors,
 * formatting data in consistent ways, and generating help text.
 * It uses the chalk library for terminal styling.
 */
import chalk from 'chalk';
import { getDataFilePath, isDev } from './utils/paths';

/**
 * Format and output data with colors based on nesting level
 * 
 * Takes any data object and formats it as JSON with indentation
 * 
 * @param {any} data - The data object to format and display
 */
export function formatOutput(data: any): void {
  console.log(JSON.stringify(data, null, 2));
}

/**
 * Display key-value pairs with colored keys based on nesting level
 * 
 * Uses different colors for each level of a nested key (separated by dots)
 * to improve readability in hierarchical data
 * 
 * @param {string} key - The key to format (may contain dots for nesting)
 * @param {string} value - The value to display
 */
export function formatKeyValue(key: string, value: string): void {
  // Split the key by dots to get levels
  const parts = key.split('.');
  
  // Color palette for different levels
  const colors = [
    chalk.cyan,     // Level 0 (base keys)
    chalk.green,    // Level 1
    chalk.yellow,   // Level 2
    chalk.magenta,  // Level 3
    chalk.blue,     // Level 4
    chalk.red       // Level 5 and beyond
  ];
  
  // Start building the colored string
  let coloredKey = '';
  
  // Apply color to each part based on its level
  parts.forEach((part, index) => {
    // Choose color based on level (use last color for deeper levels)
    const colorFn = colors[Math.min(index, colors.length - 1)];
    
    // Add the part with appropriate color
    coloredKey += colorFn(part);
    
    // Add dot separator if not the last part
    if (index < parts.length - 1) {
      coloredKey += chalk.white('.');
    }
  });
  
  // Display the full colored key with its value
  console.log(`${coloredKey}: ${value}`);
}

/**
 * Display a colorful help message
 * 
 * Generates and prints a formatted help screen with command usage,
 * available commands, examples, and data storage location.
 * Uses color coding to improve readability and visual appeal.
 */
export function showHelp(): void {
  // Title and header with box styling
  console.log(chalk.bold.blue('\n┌───────────────────────────────────────────┐'));
  console.log(chalk.bold.blue('│') + chalk.bold.cyan(' CodexCLI - Command Line Information Store ') + chalk.bold.blue('│'));
  console.log(chalk.bold.blue('└───────────────────────────────────────────┘\n'));
  
  // Usage section
  console.log(chalk.bold.magenta('USAGE:'));
  console.log(`  ${chalk.yellow('ccli')} ${chalk.green('<command>')} ${chalk.cyan('[parameters]')}\n`);
  
  // Commands section
  console.log(chalk.bold.magenta('COMMANDS:'));
  
  // Command table with colored elements
  const commands = [
    { cmd: 'add', params: '<key> <value>', desc: 'Add or update an entry' },
    { cmd: 'get', params: '<key>', desc: 'Retrieve an entry' },
    { cmd: 'list', params: '[path]', desc: 'List all entries or entries under specified path' },
    { cmd: 'find', params: '<term>', desc: 'Find entries by key or value' },
    { cmd: 'remove', params: '<key>', desc: 'Remove an entry' },
    { cmd: 'alias', params: '<action> [name] [path]', desc: 'Manage aliases for paths' },
    { cmd: 'help', params: '', desc: 'Show this help message' }
  ];
  
  // Display each command with appropriate coloring
  commands.forEach(({ cmd, params, desc }) => {
    const commandCol = chalk.yellow(cmd.padEnd(8));
    const paramsCol = chalk.green(params.padEnd(15));
    console.log(`  ${commandCol} ${paramsCol} ${chalk.white(desc)}`);
  });
  
  // Examples section
  console.log('\n' + chalk.bold.magenta('EXAMPLES:'));
  console.log(`  ${chalk.yellow('codexcli')} ${chalk.green('add')} ${chalk.cyan('server.ip')} 192.168.1.100`);
  console.log(`  ${chalk.yellow('codexcli')} ${chalk.green('get')} ${chalk.cyan('server.ip')}`);
  console.log(`  ${chalk.yellow('codexcli')} ${chalk.green('list')} ${chalk.cyan('server')}`);
  console.log(`  ${chalk.yellow('codexcli')} ${chalk.green('find')} 192.168.1.100\n`);
  
  // Add alias example
  console.log(`  ${chalk.yellow('codexcli')} ${chalk.green('alias')} ${chalk.cyan('set myalias server.production.ip')}`);
  console.log(`  ${chalk.yellow('codexcli')} ${chalk.green('get')} ${chalk.cyan('myalias')}\n`);
  
  // Add these examples to the showHelp function
  console.log(`  ${chalk.yellow('codexcli')} ${chalk.green('alias')} ${chalk.cyan('list')}`);
  console.log(`  ${chalk.yellow('codexcli')} ${chalk.green('alias')} ${chalk.cyan('remove myalias')}\n`);
  
  // Data file location section - use the utility
  const DATA_FILE = getDataFilePath();
  const envLabel = isDev() ? chalk.yellow('[DEV] ') : '';
  
  console.log(chalk.bold.magenta('DATA STORAGE:'));
  console.log(`  ${envLabel}${chalk.white('All entries are stored in:')} ${chalk.cyan(DATA_FILE)}\n`);
}

/**
 * Displays an object in a tree-like structure
 * Similar to the 'tree' command in terminals
 * 
 * @param {any} obj - The object to display as a tree
 */
export function displayTree(obj: any): void {
  console.log(); // Add some space before tree
  
  // Get the root keys
  const rootKeys = Object.keys(obj);
  
  // Display each root key as a top-level item
  rootKeys.forEach((key, index) => {
    // Use the key as the header
    console.log(chalk.bold(key));
    
    // Process the value
    const value = obj[key];
    
    // If it's an object, recursively display its contents
    if (typeof value === 'object' && value !== null) {
      const entries = Object.entries(value);
      entries.forEach(([childKey, childValue], childIndex) => {
        const isLastChild = childIndex === entries.length - 1;
        displaySubTree(childKey, childValue, '', isLastChild, 1);
      });
    } else {
      // Direct value
      console.log(`└── ${value}`);
    }
    
    // Add spacing between root items
    if (index < rootKeys.length - 1) {
      console.log('');
    }
  });
  
  console.log(); // Add some space after tree
}

/**
 * Helper function to display subtrees in the hierarchy
 * 
 * @param {string} key - The key for this node
 * @param {any} value - The value for this node
 * @param {string} prefix - Prefix for the current line
 * @param {boolean} isLast - Whether this is the last item at this level
 * @param {number} level - Current nesting level
 */
function displaySubTree(key: string, value: any, prefix = '', isLast = true, level = 1): void {
  // Choose color based on level
  const keyColor = getColorForLevel(level - 1);
  
  // Use different characters based on whether this is the last item
  const connector = isLast ? '└── ' : '├── ';
  
  // If it's a direct value
  if (typeof value !== 'object' || value === null) {
    console.log(`${prefix}${chalk.gray(connector)}${keyColor(key)}: ${value}`);
    return;
  }
  
  // It's an object - print the key
  console.log(`${prefix}${chalk.gray(connector)}${keyColor(key)}`);
  
  // Calculate prefix for children
  const childPrefix = prefix + (isLast ? '    ' : '│   ');
  
  // Recursively display child values
  const entries = Object.entries(value);
  entries.forEach(([childKey, childValue], index) => {
    const isLastChild = index === entries.length - 1;
    displaySubTree(childKey, childValue, childPrefix, isLastChild, level + 1);
  });
}

/**
 * Get a color function based on nesting level
 * 
 * @param {number} level - The nesting level
 * @returns {Function} A chalk color function
 */
function getColorForLevel(level: number): (text: string) => string {
  const colors = [
    chalk.cyan,     // Level 0
    chalk.green,    // Level 1
    chalk.yellow,   // Level 2
    chalk.magenta,  // Level 3
    chalk.blue,     // Level 4
    chalk.red       // Level 5+
  ];
  
  return colors[Math.min(level, colors.length - 1)];
}