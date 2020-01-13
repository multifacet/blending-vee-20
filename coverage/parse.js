var parse = require('lcov-parse');
const fs = require('fs');

var myArgs = process.argv.slice(2);
console.log('myArgs: ', myArgs[0]);

parse(myArgs[0], function(err, data) {
    if (err) {
      return console.error(err)
    }
    fs.writeFile(myArgs[1], JSON.stringify(data, null, 2), (err) => {
    // throws an error, you could also catch it here
    if (err) throw err;
    // success case, the file was saved
    //console.log('Lyric saved!');
   });

    //console.log(JSON.stringify(data, null, 2));
    //process the data here
});