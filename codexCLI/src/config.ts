import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';

const CONFIG_DIR = path.join(os.homedir(), '.codexcli');
const CONFIG_FILE = path.join(CONFIG_DIR, 'config.json');

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
    if (!fs.existsSync(CONFIG_DIR)) {
      fs.mkdirSync(CONFIG_DIR, { recursive: true });
    }
    fs.writeFileSync(CONFIG_FILE, JSON.stringify(config, null, 2));
  } catch (error) {
    console.error('Error saving config:', error);
  }
}