require 'rspec'
require "base64"
include RSpec::Matchers

test = "746865206b696420646f6e277420706c6179"

pass = "1c0111001f010100061a024b53535009181c"
secret = "686974207468652062756c6c277320657965"

zass   =  pass.scan(/../).map { |i| i.to_i(16) }
zecret = secret.scan(/../).map { |i| i.to_i(16) }

o = zass.zip zecret

enc = o.map { |i| i[0] ^ i[1] }.map { |i| i.to_s(16) }.join("")


puts expect(enc).to eq(test)
