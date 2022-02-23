import process from 'process';

process.stdout.write('Type something then hit enter:\n');
process.stdin.setEncoding('utf8');
process.stdin.on('readable', () => {
    const chunk = process.stdin.read();

    if (chunk !== null) {
        process.stdout.write(`You wrote: ${chunk}`);
    }

    process.on('exit', (code) => {
        console.log(`Exit with code: ${code}`)
    });
});