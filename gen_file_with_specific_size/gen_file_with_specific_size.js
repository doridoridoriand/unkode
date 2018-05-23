let argv = require('argv');

argv.option({
  name: 'size',
  short: 's',
  type : 'integer',
  description :'File size(GB)',
  example: "'gen_file_with_specific_size.js --size 1' or 'gen_file_with_specific_size.js -s 1'"
});
console.log(argv.run());
