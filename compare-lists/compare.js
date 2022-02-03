const boyNames2000 = require('./boy-names-2000').sort();
const boyNames2020 = require('./boy-names-2020').sort();

const boyNames2000Delta = compare(boyNames2000, boyNames2020, true);
const boyNames2020Delta = compare(boyNames2020, boyNames2000, true);
const overlap = compare(boyNames2000, boyNames2020);

function compare(array1, array2, delta) {
    const
        findItem = (item1) => array2.find(item2 => item2 === item1),
        findDelta = (item1) => delta ? !findItem(item1) : findItem(item1);

    return array1.filter(item1 => findDelta(item1));
}

console.log(
`
Boy Names Year 2000 (${boyNames2000.length}):
${boyNames2000}

Boy Names Year 2000 Delta (${boyNames2000Delta.length}):
${boyNames2000Delta}

Boy Names Year 2020  (${boyNames2020.length}):
${boyNames2020}

Boy Names Year 2020 Delta (${boyNames2020Delta.length}):
${boyNames2020Delta}

Boy Names in both Years (${overlap.length}):
${overlap}
`
);