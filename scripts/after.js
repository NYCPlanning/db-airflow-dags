var Mustache = require('mustache')
var exec = require('child_process').exec
var fs = require('fs')

var dataset = process.argv[2];
var argv = require('minimist')(process.argv.slice(3));

db = {
  database: argv.db,
  user: argv.db_user,
}

console.log('Checking for after file...')

fs.open('datasets/' + dataset + '/after.sql', 'r', function(err) {
  if(err) {
    console.log('No after.sql found.')
  } else {
    runCommand();
  }
})

function runCommand() {
  var command = Mustache.render('psql -d {{database}} -U {{user}} -f {{{path}}}after.sql', {
    user: db.user,
    database: db.database,
    path: 'datasets/' + dataset + '/'
  });

  exec(command, {}, function(err, stdout, stderr) {
    if (err) {
      process.exit(1);
    }

    console.log(err, stdout, stderr);
  });
}
