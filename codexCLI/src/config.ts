/**
 * Configuration management module for CodexCLI
 * 
 * This module handles loading and saving user configuration settings.
 * It provides a typed interface for configuration options and manages
 * serialization/deserialization to a JSON configuration file.
 */
import * as fs from 'fs';
import { getConfigFilePath } from './utils/paths';

/**
 * Path to the configuration file
 * Retrieved from utility function to ensure consistent location across the application
 */
const CONFIG_FILE = getConfigFilePath();

/**
 * Interface defining available user configuration options
 * 
 * @property {('text'|'json')} [defaultFormat] - Default output format for commands
 * @property {boolean} [colorEnabled] - Whether to use colored output in the terminal
 * @property {number} [indentSize] - Number of spaces to use for indentation in formatted output
 */
export interface UserConfig {
  defaultFormat?: 'text' | 'json';
  colorEnabled?: boolean;
  indentSize?: number;
}

/**
 * Loads user configuration from disk
 * 
 * Attempts to read and parse the configuration file.
 * Returns empty object if file doesn't exist or can't be parsed,
 * which will cause the application to use default values.
 * 
 * @returns {UserConfig} The loaded configuration object or empty default
 */
export function loadConfig(): UserConfig {
  try {
    if (fs.existsSync(CONFIG_FILE)) {
      return JSON.parse(fs.readFileSync(CONFIG_FILE, 'utf8'));
    }
  } catch (error) {
    console.error('Error loading config, using defaults');
  }
  
  return {};
}

/**
 * Saves user configuration to disk
 * 
 * Serializes the configuration object to JSON and writes it to the configuration file.
 * Uses pretty formatting with 2-space indentation for human readability.
 * 
 * @param {UserConfig} config - The configuration object to save
 */
export function saveConfig(config: UserConfig): void {
  try {
    fs.writeFileSync(CONFIG_FILE, JSON.stringify(config, null, 2));
  } catch (error) {
    console.error('Error saving config:', error);
  }
}