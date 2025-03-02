#!/usr/bin/env node

/**
 * Main entry point for CodexCLI application
 * 
 * This file sets up the command-line interface using Commander.js,
 * defines all available commands and their behaviors, and handles execution flow.
 */
import { Command } from 'commander';  // Command line arguments parser
import { showHelp } from './formatting';
import { addEntry, getEntry, listEntries, removeEntry, searchEntries } from './commands';
import { loadConfig, saveConfig, UserConfig } from './config';
import { setAlias, removeAlias, resolveKey, loadAliases } from './alias';
import chalk from 'chalk';

// Initialize the main command object
const codexCLI = new Command();

/**
 * Basic CLI configuration
 * Sets version and description shown in help output
 */
codexCLI
  .version('1.0.0')
  .description('CodexCLI - Command Line Information Store');

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
    const resolvedKey = resolveKey(key);
    const value = valueArray.join(' ');
    addEntry(resolvedKey, value);
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
  .option('--tree', 'Display hierarchical data in a tree structure')
  .action((key, options) => {
    const resolvedKey = resolveKey(key);
    getEntry(resolvedKey, options);
  });

/**
 * Command: list
 * Displays all stored entries, optionally filtered by path
 * @param {string} [path] - Optional path to filter entries
 */
codexCLI
  .command('list [path]')
  .description('List all entries or entries under specified path')
  .option('--tree', 'Display hierarchical data in a tree structure')
  .action((path, options) => {
    // Debug log to verify option parsing
    if (process.env.DEBUG === 'true') {
      console.log('Command options:', options);
    }
    listEntries(path, options);
  });

/**
 * Command: find
 * Searches entries by key or value containing the search term
 * @param {string} term - Search term to look for in keys and values
 */
codexCLI
  .command('find <term>')
  .description('Find entries by key or value')
  .option('--tree', 'Display hierarchical data in a tree structure')
  .action((term, options) => {
    searchEntries(term, options);
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
    const resolvedKey = resolveKey(key);
    removeEntry(resolvedKey);
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
 * Command: alias
 * Manages aliases for paths
 * @param {string} action - Action to perform: set, get, list, remove
 * @param {string} [alias] - Alias name
 * @param {string} [path] - Path for the alias (required for set action)
 */
codexCLI
  .command('alias')
  .description('Manage aliases for paths')
  .argument('<action>', 'Action to perform: set, get, list, remove')
  .argument('[alias]', 'Alias name')
  .argument('[path]', 'Path for the alias (required for set action)')
  .action((action, alias, path) => {
    switch (action) {
      case 'set':
        if (!alias || !path) {
          console.error('Both alias and path are required for set action');
          return;
        }
        setAlias(alias, path);
        console.log(`Alias '${chalk.green(alias)}' now points to '${chalk.cyan(path)}'`);
        break;
        
      case 'get':
        if (!alias) {
          console.error('Alias name is required');
          return;
        }
        const aliases = loadAliases();
        if (aliases[alias]) {
          console.log(`Alias '${chalk.green(alias)}' points to '${chalk.cyan(aliases[alias])}'`);
        } else {
          console.log(`Alias '${chalk.yellow(alias)}' not found`);
        }
        break;
        
      case 'list':
        const allAliases = loadAliases();
        if (Object.keys(allAliases).length === 0) {
          console.log('No aliases defined');
          return;
        }
        console.log(chalk.bold('Defined aliases:'));
        Object.entries(allAliases).forEach(([alias, targetPath]) => {
          console.log(`${chalk.green(alias.padEnd(15))} ${chalk.gray('→')} ${chalk.cyan(targetPath)}`);
        });
        break;
        
      case 'remove':
        if (!alias) {
          console.error('Alias name is required');
          return;
        }
        if (removeAlias(alias)) {
          console.log(`Alias '${chalk.green(alias)}' removed`);
        } else {
          console.log(`Alias '${chalk.yellow(alias)}' not found`);
        }
        break;
        
      default:
        console.error(`Unknown action: ${action}`);
        console.log('Valid actions: set, get, list, remove');
    }
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
