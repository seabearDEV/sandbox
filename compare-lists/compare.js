const global = require('./filetypes-global').sort();
const symantec = require('./filetypes-symantec').sort();

const globalDelta = compare(global, symantec, true);
const symantecDelta = compare(symantec, global, true);
const overlap = compare(symantec, global);

function compare(array1, array2, delta) {
    if (delta) {
        return array1.filter(filetype1 => {
            if (!array2.find(filetype2 => filetype2 === filetype1)) {
                debugger;
                return filetype1;
            }
        });
    }

    return array1.filter(filetype1 => {
        if (array2.find(filetype2 => filetype2 === filetype1)) {
            return filetype1;
        }
    });
}

function compare2(array1, array2, delta) {
    let shortArray,
        longArray;
    
    if (array1.length > array2.length) {
        shortArray = array2;
        longArray = array1;
    }

    shortArray = array1;
    longArray = array2;

    if (delta) {

    }
}

console.log(
`
Global File Types (${global.length}):
${global}

Global Delta (${globalDelta.length}):
${globalDelta}

Symantec File Types (${symantec.length}):
${symantec}

Symantec Delta (${symantecDelta.length}):
${symantecDelta}

Overlapped File Types (${overlap.length}):
${overlap}
`
);