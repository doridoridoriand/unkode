// 実行時オプションに --max-old-space-size=4096 などと付けないとV8の1.5GB制限に引っかかってまともにメモリ消費できないので注意

let uuid = require('node-uuid');
let uuids = [];

while (true) {
  uuids.push(uuid.v4());
}
