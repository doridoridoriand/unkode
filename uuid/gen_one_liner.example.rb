require 'securerandom'; uuid = []; while true do; begin; uuid << SecureRandom.uuid; rescue => e; end; end
