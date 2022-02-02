const global = require('./filetypes-global').sort();
const symantec = require('./filetypes-symantec').sort();

const globalDelta = compare(global, symantec, true);
const symantecDelta = compare(global, symantec, true);
const overlap = compare(global, symantec);

function compare(array1, array2, delta) {
    const find = (filetype1) => longArray.find(filetype2 => {
        if (filetype2 === filetype1) {
            return true;
        }
    });
    let longArray,
        shortArray;

    if (array1.length <= array2.length) {
        shortArray = array1;
        longArray = array2;
    } else {
        shortArray = array2;
        longArray = array1;
    }

    if (delta) {
        return shortArray.filter(filetype1 => {
            if (!find(filetype1)) {
                return filetype1;
            }
        });
    }

    return shortArray.filter(filetype1 => {
        if (find(filetype1)) {
            return filetype1;
        }
    });
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