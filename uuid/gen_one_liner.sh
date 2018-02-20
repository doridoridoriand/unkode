ruby -e "require 'securerandom'; uuid = []; while true do; ; uuid << SecureRandom.uuid; end"
node -e "let uuid = require('node-uuid');let uuids = [];while(true){uuids.push(uuid.v4());}"
