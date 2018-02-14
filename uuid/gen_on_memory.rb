require 'securerandom'
require 'logger'
uuid = []

logger = Logger.new STDOUT

while true do
  begin
    u = SecureRandom.uuid
    uuid << u
    logger.info("UUID: #{u} generated.")
  rescue => e
    p e
  end
end
