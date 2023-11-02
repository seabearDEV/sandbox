function nestedArray() {
    const columns = 4;
    const rows = 4;

    let count = 1;
    let data = [];

    // Create columns
    for (i = 0; i < columns; i += 1) {

        // Every column will receive this array of rows
        let row = [];

        // Create rows
        for (j = 0; j < rows; j += 1) {
            row.push(count);

            count += 1;
        }

        // Push the row to the data array
        data.push(row);
    }

    console.log(data);
}

function arrayBuilder() {
    let count = 1;
    let data = [];

    
}

// nestedArray();
arrayBuilder();
