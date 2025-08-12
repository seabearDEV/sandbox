const binary = {
    count: 0,
    middle: 0,
    previousMiddle: 0,
    search: function(array, element, low, high) {
        if (typeof (element) === 'number' && element < low || element > high) {
            return console.log(`${element} is outside the array bounds.`);
        }

        this.middle = Math.floor((low + high) / 2);

        if (typeof (element) === 'string' && this.middle === this.previousMiddle) {
            return console.log(`---\n${element} not found in the array.`);
        }

        this.count += 1;
        this.previousMiddle = this.middle;

        console.log(`Iteration ${this.count}: ${array[this.middle]} at index ${this.middle}`);

        if (array[this.middle] > element) {
            return this.search(array, element, low, this.middle - 1);
        } else if (array[this.middle] < element) {
            return this.search(array, element, this.middle + 1, high);
        }

        this.count = 0;

        return console.log(`---\n${element} found at index ${this.middle} in the array.`);
    }
};

const namesData = require('./data/names');
console.log(`There are ${namesData.length} items in the array.\n---`);
binary.search(namesData, 'Zuriel', 0, namesData.length - 1);

const numbersData = require('./data/numbers');
console.log(`There are ${numbersData.length} items in the array.\n---`);
binary.search(numbersData, 498, 0, numbersData.length - 1);