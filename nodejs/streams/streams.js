import fs from 'node:fs';
import { Readable } from 'node:stream';

// console.time();
// const file = fs.createWriteStream('./big.file');

// for (let i = 0; i <= 1e6; i += 1) {
// 	file.write(
// 		'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n'
// 	);
// }

// file.end();

// console.timeEnd();

const inStream = new Readable({
    read(size) {
        console.log(this);

        this.push(`${String.fromCharCode(this.currentCharCode += 1)}\n`);

        if (this.currentCharCode > 90) {
            this.push(null);
        }
    }
});

inStream.currentCharCode = 65;
inStream.pipe(process.stdout);