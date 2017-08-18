var Mustache = require('mustache')
var exec = require('child_process').exec
var fs = require('fs')

// run preprocess.sh
function runCommand(resolve, dataset) {
    var command = Mustache.render('./datasets/{{ds}}/preprocess.sh', {
        ds: dataset
    });
    console.log(command);
    exec(command, {}, function(err, stdout, stderr) {
        console.log(err, stdout, stderr);
        resolve();
    })
}

const preprocess = (dataset) => {
    return new Promise(function(resolve, reject) {

        console.log('Checking for preprocess script...')

        fs.open('datasets/' + dataset + '/preprocess.sh', 'r', function(err) {
            if(err) {
                console.log('No preprocess.sh found.')
                reject();
            } else {
                runCommand(resolve,(dataset));
            }
        });
    });
}

module.exports = preprocess;
