require 'securerandom'

while true do
  p SecureRandom.uuid.upcase
  sleep(1)
end
