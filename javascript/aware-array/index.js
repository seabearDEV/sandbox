import { writeFile } from 'fs';
import { performance } from 'perf_hooks';

/**
 * Function that returns a 2-dimensional array where each cell is aware of its surrounding neighbors and its own position in the array.
 * @param {number} dimension This number will be the height and width of the 2-dimensional array.
 * @param {boolean} flat Set true if you want the array flattened into a 1-dimensional array.
 * @param {boolean} saveFile Set true if you want to save the array to a JSON file.
 * @returns {Array} The generated map.
 */
function createMap(dimension, flat, saveFile) {
    const map = [];

    function findNeighbors(i, j) {
        const neighbors = {
            top: i > 0 ? (i - 1) * dimension + j : null,
            bottom: i < dimension - 1 ? (i + 1) * dimension + j : null,
            left: j > 0 ? i * dimension + (j - 1) : null,
            right: j < dimension - 1 ? i * dimension + (j + 1) : null
        };
        return neighbors;
    }

    function saveMap(data) {
        const filename = `map-${dimension * dimension}.json`;
        writeFile(filename, JSON.stringify(data, null, 2), (err) => {
            if (err) {
                console.error(`Error saving JSON: ${err}`);
                return;
            }
            console.log(`JSON has been saved as ${filename}`);
        });
    }

    for (let i = 0; i < dimension; i++) {
        const row = [];
        for (let j = 0; j < dimension; j++) {
            row.push({
                id: i * dimension + j,
                neighbors: findNeighbors(i, j),
                position: { x: j, y: i }
            });
        }
        map.push(row);
    }

    const finalMap = flat ? map.flat() : map;
    if (saveFile) {
        saveMap(finalMap);
    }

    return finalMap;
}

const t0 = performance.now();
const map = createMap(256, false, true);
// console.table(map);
const t1 = performance.now();
console.log(`Map with ${256 * 256} sectors created in ${t1 - t0} milliseconds.`);
