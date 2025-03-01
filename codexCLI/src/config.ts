import * as fs from 'fs';
import { getConfigFilePath } from './utils/paths';

// Get the config file path from the utility
const CONFIG_FILE = getConfigFilePath();

// Make sure to export the interface
export interface UserConfig {
  defaultFormat?: 'text' | 'json';
  colorEnabled?: boolean;
  indentSize?: number;
}

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

export function saveConfig(config: UserConfig): void {
  try {
    fs.writeFileSync(CONFIG_FILE, JSON.stringify(config, null, 2));
  } catch (error) {
    console.error('Error saving config:', error);
  }
}