# nodejs-typescript

This is a template useful for projects wanting to use TypeScript in Node.js with a testing framework. Code goes in the src/app folder and tests follow the same structure in the src/tests folder.

## Primary Technologies

- [Node.js](https://nodejs.org/en/download/) - v16.13.2
- [TypeScript](https://www.npmjs.com/package/typescript) - v4.5.4
- [JestJS](https://www.npmjs.com/package/jest) - v27.4.7

## Supporting Technologies

- [concurrently](https://www.npmjs.com/package/concurrently) - v7.0.0
- [nodemon](https://www.npmjs.com/package/nodemon) - v2.0.15
- [rimraf](https://www.npmjs.com/package/rimraf) - v3.0.2

## Types

- [@tsconfig/node16](https://www.npmjs.com/package/@tsconfig/node16) - v1.0.2
- [@types/jest](https://www.npmjs.com/package/@types/jest) - v27.4.0
- [@types/node](https://www.npmjs.com/package/@types/node) - v.17.0.8

### Scripts (npm run)

- **build**: cleans dist folder and transpiles all TypeScript files in the project
- **dev**: cleans dist folder, transpiles all TypeScript files, and then watches for changes
- **prod**: cleans dist folder, transpiles all TypeScript files, and removes the tests folder from dist
- **test**: cleans dist folder, transpiles all TypeScript files, and runs the JestJS testing framework
