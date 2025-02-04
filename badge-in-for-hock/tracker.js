#!/usr/bin/env node

// Import necessary modules from Node.js
import { promises as fs } from 'fs';
import { join, basename } from 'path';
import { homedir } from 'os';
import { createInterface } from 'readline';
import chalk from 'chalk';

// Configuration object containing file paths and default settings
const CONFIG = {
  DATA_FILE: join(homedir(), '.timetracker'),
  CONFIG_FILE: join(homedir(), '.timetracker.config'),
  DEFAULT_CONFIG: {
    allowedDays: 52,
    warningThreshold: 80,
    criticalThreshold: 70
  }
};

// Function to get the current year, adjusting for fiscal year starting in November
const getCurrentYear = () => {
  const now = new Date();
  return now.getMonth() < 10 ? now.getFullYear() - 1 : now.getFullYear();
};

// Function to calculate the number of workdays between two dates
const calculateWorkDays = (start, end) => {
  let count = 0;
  const current = new Date(start);
  const endDate = new Date(end);

  while (current <= endDate) {
    const day = current.getDay();
    if (day !== 0 && day !== 6) count++;
    current.setDate(current.getDate() + 1);
  }
  return count;
};

// Function to get information about workdays for the current fiscal year
const getWorkDaysInfo = () => {
  const currentYear = getCurrentYear();
  const today = new Date();
  const startDate = new Date(currentYear, 10, 1);
  const endDate = new Date(currentYear + 1, 9, 31);
  const tomorrow = new Date(today.setDate(today.getDate() + 1));

  const daysPassed = calculateWorkDays(startDate, today);
  const daysRemaining = calculateWorkDays(tomorrow, endDate);

  return { daysPassed, daysRemaining, totalDays: daysPassed + daysRemaining };
};

// Function to prompt user for input
const promptUser = (question) => {
  const rl = createInterface({
    input: process.stdin,
    output: process.stdout
  });

  return new Promise(resolve => rl.question(question, answer => {
    rl.close();
    resolve(answer);
  }));
};

// Generic function to read or initialize a file
const readOrInitializeFile = async (filePath, defaultValue) => {
  try {
    const data = await fs.readFile(filePath, 'utf8');
    return JSON.parse(data);
  } catch {
    await fs.writeFile(filePath, JSON.stringify(defaultValue, null, 2));
    return defaultValue;
  }
};

// Function to configure settings
const configureSettings = async () => {
  console.log('\nConfiguring time tracker settings:');
  const config = { ...CONFIG.DEFAULT_CONFIG };

  const inputs = [
    ['Enter allowed out-of-office days (default: 52): ', 'allowedDays'],
    ['Enter warning threshold percentage (default: 80): ', 'warningThreshold'],
    ['Enter critical threshold percentage (default: 70): ', 'criticalThreshold']
  ];

  for (const [prompt, key] of inputs) {
    const value = parseInt(await promptUser(prompt)) || config[key];
    config[key] = value;
  }

  await fs.writeFile(CONFIG.CONFIG_FILE, JSON.stringify(config, null, 2));
  return config;
};

// Function to read configuration
const getConfig = async () => readOrInitializeFile(CONFIG.CONFIG_FILE, CONFIG.DEFAULT_CONFIG);

// Function to read data
const readData = async () => {
  const defaultData = { days: 0, year: getCurrentYear() };
  const data = await readOrInitializeFile(CONFIG.DATA_FILE, defaultData);
  if (data.year !== getCurrentYear()) {
    data.days = 0;
    data.year = getCurrentYear();
    await fs.writeFile(CONFIG.DATA_FILE, JSON.stringify(data, null, 2));
  }
  return data;
};

// Function to display status
const displayStatus = (used, config) => {
  const year = getCurrentYear();
  const { daysPassed, daysRemaining, totalDays } = getWorkDaysInfo();
  const percentage = Math.floor(100 - (used * 100 / totalDays));
  const remaining = config.allowedDays - used;

  console.log(chalk.white(`
Current tracking period: Nov 1, ${year} - Oct 31, ${year + 1}
Work days passed: ${daysPassed}
Work days remaining: ${daysRemaining}
Total work days: ${totalDays}

Out-of-office status:
Used: ${chalk.red(used)} out of ${chalk.red(config.allowedDays)} allowed out-of-office days
Remaining: ${chalk.green(remaining)} days
Office presence: ${chalk.yellow(percentage)}%
${percentage < config.criticalThreshold ? chalk.bgRed('\n⚠️  CRITICAL: Office presence below critical threshold!') :
      percentage < config.warningThreshold ? chalk.bgYellow('\n⚠️  WARNING: Office presence below warning threshold!') : ''}`));
};

// Function to show help
const showHelp = () => {
  const script = basename(process.argv[1]);
  console.log(chalk.white(`
Office Time Tracker
Usage:
  ${script} add <days>    - Add out-of-office days
  ${script} remove <days> - Remove out-of-office days
  ${script} check        - Check remaining days
  ${script} reset        - Reset counter and update settings`));
};

// Function to handle commands
const handleCommand = async (command, days, config, data) => {
  switch (command) {
    case 'add':
      data.days += days;
      break;
    case 'remove':
      data.days -= days;
      break;
    case 'reset':
      data.days = 0;
      config = await configureSettings();
      break;
    case 'check':
      displayStatus(data.days, config);
      return;
    default:
      showHelp();
      return;
  }
  await fs.writeFile(CONFIG.DATA_FILE, JSON.stringify(data, null, 2));
  displayStatus(data.days, config);
};

// Main function
const main = async () => {
  const [,, command, daysArg] = process.argv;
  const days = parseInt(daysArg) || 0;
  const config = await getConfig();
  const data = await readData();

  await handleCommand(command, days, config, data);
};

main().catch(err => console.error(chalk.red(err)));
