// Define more specific option types instead of 'any'
export interface CommandOptions {
  raw?: boolean;
  [key: string]: any;
}

// More specific nested data structure type
export interface CodexData {
  [key: string]: string | CodexData;
}