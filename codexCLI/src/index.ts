/**
 * CodexCLI - Command line information storage and retrieval
 * 
 * This file handles command line arguments parsing and processing
 */

import { Command } from 'commander';
import chalk from 'chalk';
import { showHelp } from './formatting';
import { addEntry, getEntry, listEntries, removeEntry, searchEntries } from './commands';
import { loadConfig, saveConfig, UserConfig } from './config'; // Add this import

console.log('CodexCLI - Command Line Information Storage and Retrieval');

const program = new Command();

program
  .version('1.0.0')
  .description('Command Line Information Storage and Retrieval');

program
  .option('--debug', 'Enable debug output')
  .hook('preAction', (thisCommand) => {
    if (thisCommand.opts().debug) {
      process.env.DEBUG = 'true';
    }
  });

program
  .command('add <key> <value...>')
  .description('Add or update an entry')
  .action((key, valueArray) => {
    const value = valueArray.join(' ');
    addEntry(key, value);
  });

program
  .command('get <key>')
  .description('Retrieve an entry')
  .option('--raw', 'Output raw value without formatting')
  .action((key, options) => {
    console.log(`Executing get with options:`, options); // Debug log
    getEntry(key, options);
  });

program
  .command('list [path]')
  .description('List all entries or entries under specified path')
  .action((path) => {
    listEntries(path);
  });

program
  .command('find <term>')
  .description('Find entries by key or value')
  .action((term) => {
    searchEntries(term);
  });

program
  .command('remove <key>')
  .description('Remove an entry')
  .action((key) => {
    removeEntry(key);
  });

program
  .command('config <key> [value]')
  .description('Get or set configuration options')
  .action((key, value) => {
    const config = loadConfig();
    
    if (value === undefined) {
      // Get config
      console.log(`${key}: ${config[key as keyof UserConfig]}`);
    } else {
      // Set config
      (config as any)[key] = value;
      saveConfig(config);
      console.log(`Config ${key} set to ${value}`);
    }
  });

program
  .command('help')
  .description('Display help information')
  .action(() => {
    showHelp();
  });

// Handle unknown commands
program.on('command:*', () => {
  console.error('Invalid command: %s\n', program.args.join(' '));
  showHelp();
  process.exit(1);
});

// Parse arguments or show help if none provided
if (process.argv.length <= 2) {
  showHelp();
} else {
  program.parse(process.argv);
}

// Then in other files:
function debug(message: string, data?: any): void {
  if (process.env.DEBUG === 'true') {
    console.log(chalk.gray(`[DEBUG] ${message}`));
    if (data) console.log(chalk.gray(JSON.stringify(data, null, 2)));
  }
}
