import chalk from 'chalk';

export function debug(message: string, data?: any): void {
  if (process.env.DEBUG === 'true') {
    console.log(chalk.gray(`[DEBUG] ${message}`));
    if (data) console.log(chalk.gray(JSON.stringify(data, null, 2)));
  }
}