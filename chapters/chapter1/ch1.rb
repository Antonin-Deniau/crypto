require "base64"

test = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
hex = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"

res = hex.scan(/../).map { |i| i.to_i(16).chr }

enc = Base64.strict_encode64 res.join("")


puts enc
puts test
