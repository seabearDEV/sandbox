# project-genesis

The goal of **project-genesis** is to be a starting place for applications written in TypeScript for Node.js.

## Instructions

* Run "**npm run genesis**" without any flags to generate a base TypeScript application
  * "npm run genesis base" generates a base TypeScript Node.js application
  * "npm run genesis web-server" generates a TypeScript Node.js web server using Express.js
* Run "**npm run dev:watch**" to start the HTML, SCSS, and TypeScript compilers in watch mode
* Run "**npm run dev**" to execute your application from index.js
* Run "**npm run test**" to test your JavaScript files using Jest

*You may want to run "npm run dev:watch" and "npm run dev" in separate terminal windows for easier development.*

*Running "npm run test" will generate a coverage folder where Jest creates test reports.*

### Scripts (npm run)

* **build**: Deletes dist folder, compiles TypeScript and Sass files, and copies all CSS/HTML/JS into new dist folder
* **cleanup**: Deletes dist folder, deletes node_modules folder, and deletes the src folder
* **dev**: Runs the build script, sets Node environment to development, and executes dist/app/index.js
* **dev:watch**: Watches the /src directory for any file changes and runs the build when necessary
* **test**: Runs the build script and then runs JestJS testing framework against the /src directory
* **update**: Updates all dependencies in the project to their latest versions
