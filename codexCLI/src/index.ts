/**
 * Main entry point for CodexCLI application
 * 
 * This file sets up the command-line interface using Commander.js,
 * defines all available commands and their behaviors, and handles execution flow.
 */
import { Command } from 'commander';  // Command line arguments parser
import chalk from 'chalk';            // Terminal text styling
import { showHelp } from './formatting';
import { addEntry, getEntry, listEntries, removeEntry, searchEntries } from './commands';
import { loadConfig, saveConfig, UserConfig } from './config';

// Initialize the main command object
const codexCLI = new Command();

/**
 * Basic CLI configuration
 * Sets version and description shown in help output
 */
codexCLI
  .version('1.0.0')
  .description('Command Line Information Storage and Retrieval');

/**
 * Global CLI options
 * --debug: Enables verbose logging for troubleshooting
 */
codexCLI
  .option('--debug', 'Enable debug output')
  .hook('preAction', (thisCommand) => {
    if (thisCommand.opts().debug) {
      process.env.DEBUG = 'true';
    }
  });

/**
 * Command: add
 * Stores a new entry or updates an existing one in the database
 * @param {string} key - Unique identifier for the entry
 * @param {string[]} value - Array of strings that will be joined into a single value
 */
codexCLI
  .command('add <key> <value...>')
  .description('Add or update an entry')
  .action((key, valueArray) => {
    const value = valueArray.join(' ');
    addEntry(key, value);
  });

/**
 * Command: get
 * Retrieves and displays a stored entry by its key
 * @param {string} key - The identifier to look up
 * @param {object} options - Command options (--raw for unformatted output)
 */
codexCLI
  .command('get <key>')
  .description('Retrieve an entry')
  .option('--raw', 'Output raw value without formatting')
  .action((key, options) => {
    console.log(`Executing get with options:`, options);
    getEntry(key, options);
  });

/**
 * Command: list
 * Displays all stored entries, optionally filtered by path
 * @param {string} [path] - Optional path to filter entries
 */
codexCLI
  .command('list [path]')
  .description('List all entries or entries under specified path')
  .action((path) => {
    listEntries(path);
  });

/**
 * Command: find
 * Searches entries by key or value containing the search term
 * @param {string} term - Search term to look for in keys and values
 */
codexCLI
  .command('find <term>')
  .description('Find entries by key or value')
  .action((term) => {
    searchEntries(term);
  });

/**
 * Command: remove
 * Deletes an entry from storage
 * @param {string} key - The identifier of the entry to remove
 */
codexCLI
  .command('remove <key>')
  .description('Remove an entry')
  .action((key) => {
    removeEntry(key);
  });

/**
 * Command: config
 * Gets or sets application configuration values
 * @param {string} key - Configuration property name
 * @param {string} [value] - Optional value to set; if omitted, displays current value
 */
codexCLI
  .command('config <key> [value]')
  .description('Get or set configuration options')
  .action((key, value) => {
    const config = loadConfig();

    if (value === undefined) {
      console.log(`${key}: ${config[key as keyof UserConfig]}`);
    } else {
      (config as any)[key] = value;
      saveConfig(config);
      console.log(`Config ${key} set to ${value}`);
    }
  });

/**
 * Command: help
 * Displays custom formatted help information
 */
codexCLI
  .command('help')
  .description('Display help information')
  .action(() => {
    showHelp();
  });

/**
 * Error handler for invalid commands
 * Displays error message, shows help, and exits with error code
 */
codexCLI.on('command:*', () => {
  console.error('Invalid command: %s\n', codexCLI.args.join(' '));
  showHelp();
  process.exit(1);
});

/**
 * Default behavior: show help when no command is provided
 */
if (process.argv.length <= 2) {
  showHelp();
} else {
  codexCLI.parse(process.argv);
}

/**
 * Utility function for conditional debug logging
 * Only outputs when --debug flag is provided
 * 
 * @param {string} message - Debug message to display
 * @param {any} [data] - Optional data to serialize and display
 */
function debug(message: string, data?: any): void {
  if (process.env.DEBUG === 'true') {
    console.log(chalk.gray(`[DEBUG] ${message}`));
    if (data) console.log(chalk.gray(JSON.stringify(data, null, 2)));
  }
}
