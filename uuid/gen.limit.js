let uuid = require('node-uuid');
require('date-utils');

var date = new Date()
console.log(date);

for (i = 0; i < 1000000; i++) {
  uuid.v4()
}

var date = new Date()
console.log(date);
