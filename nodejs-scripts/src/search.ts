// Global imports
import { readFile } from 'fs/promises';
import  minimist  from 'minimist';

// Global constants
const argv = minimist(process.argv.slice(2));

//Global methods
const getData = async () => {
    const searchParam = new RegExp(/(http|https):\/\//);
    const input = await readFile(argv.file, 'utf-8');

    const linkStart = input.search(searchParam);
    const link = input.substring(linkStart, input.indexOf(' ', linkStart));

    return link;
}

// node search.js --file data/test001.txt
getData()
    .then(data => console.log(data))
    .catch(error => console.error(`${error}`));