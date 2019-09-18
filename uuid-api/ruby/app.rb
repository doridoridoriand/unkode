Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"

Cuba.plugin Cuba::Safe

Cuba.define do
  on root do
    res.write JSON.dump({uuid: (0..10).to_a.map {|r| SecureRandom.uuid}})
  end
end
