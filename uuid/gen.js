let uuid = require('node-uuid');
let mysql = require('mysql');

let connect = mysql.createConnection({
    host: 'uuid.c9pxhxbdcuca.ap-northeast-1.rds.amazonaws.com',
    user: 'dorian',
    password: 'password'
});

connect.connect();

while (true) {
    let sql = 'insert into uuid.node (`uuid`) values ' + '"' + uuid.v4() + '"';
    connect.query(sql, function(error, results, fields) {
        console.log(results);
    })
}
