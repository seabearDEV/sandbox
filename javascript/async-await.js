async function a() {
    return 1;
}
// a().then(value => console.log(value));

async function b() {
    let promise = new Promise((resolve, reject) => {
        setTimeout(() => resolve("Done!"), 1000);
    })

    let result = await promise;

    console.log(result);
}
// b();

function one() {
    return 10;
}
function two() {
    return 20;
}
function three() {
    return 30;
}

let array = [one(), two(), three()];