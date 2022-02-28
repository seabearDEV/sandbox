#!/usr/bin/env node

const colors = require("colors");
const greet = require("../lib/greet");

let arguments = process.argv.splice(2);
let lang = null;

if (arguments[0] === '--lang') {
    lang = arguments[1];
}

if (lang) {
    console.log(
        colors.rainbow(
            greet.greet(lang)
        )
    );
} else {
    console.log(
        colors.rainbow(
            greet.greetRandom()
        )
    );
}
