const boyNames = {
    '2000': require('./boy-names-2000').sort(),
    '2020': require('./boy-names-2020').sort()
};

const boyNamesDelta = {
    '2000': compare(boyNames[2000], boyNames[2020], true),
    '2020': compare(boyNames[2020], boyNames[2000], true),
    'overlap': compare(boyNames[2000], boyNames[2020])
};

function compare(array1, array2, delta) {
    const findDelta = (item1) => delta ? !findItem(item1) : findItem(item1);
    const findItem = (item1) => array2.find(item2 => item2 === item1);

    return array1.filter(item1 => findDelta(item1));
}

console.log(
`
Boy Names Year 2000 (${boyNames[2000].length}):
${boyNames[2000]}

Boy Names Year 2000 Delta (${boyNamesDelta[2000].length}):
${boyNamesDelta[2000]}

Boy Names Year 2020  (${boyNames[2020].length}):
${boyNames[2020]}

Boy Names Year 2020 Delta (${boyNamesDelta[2020].length}):
${boyNamesDelta[2020]}

Boy Names in Both Years (${boyNamesDelta.overlap.length}):
${boyNamesDelta.overlap}
`
);