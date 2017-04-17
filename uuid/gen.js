let uuid = require('node-uuid');
let mysql = require('mysql');
console.log(uuid.v4());

let connect = mysql.createConnection({
    host: 'uuid.c9pxhxbdcuca.ap-northeast-1.rds.amazonaws.com',
    user: 'dorian',
    password: 'password'
});

connect.connect();

connect.query('select * from uuid.ruby limit 10', function(error, results, fields) {
    console.log(results);
})
