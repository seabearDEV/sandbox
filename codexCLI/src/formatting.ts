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
  console.log(`  ${chalk.yellow('codexcli')} ${chalk.green('<command>')} ${chalk.cyan('[parameters]')}\n`);
  
  // Commands section
  console.log(chalk.bold.magenta('COMMANDS:'));
  
  // Command table with colored elements
  const commands = [
    { cmd: 'add', params: '<key> <value>', desc: 'Add or update an entry' },
    { cmd: 'get', params: '<key>', desc: 'Retrieve an entry' },
    { cmd: 'list', params: '[path]', desc: 'List all entries or entries under specified path' },
    { cmd: 'find', params: '<term>', desc: 'Find entries by key or value' },
    { cmd: 'remove', params: '<key>', desc: 'Remove an entry' },
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
  
  // Data file location section - use the utility
  const DATA_FILE = getDataFilePath();
  const envLabel = isDev() ? chalk.yellow('[DEV] ') : '';
  
  console.log(chalk.bold.magenta('DATA STORAGE:'));
  console.log(`  ${envLabel}${chalk.white('All entries are stored in:')} ${chalk.cyan(DATA_FILE)}\n`);
}