require_relative '../../utils'

test = "Cooking MC's like a pound of bacon"
pass = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

list = []

for x in 1..255
  ztest   = pass.scan(/../).map { |i| i.to_i(16) }
  zsecret = pass.scan(/../).map { |i| x }

  o = ztest.zip zsecret

  enc = o.map { |i| i[0] ^ i[1] }.map { |i| i.chr }.join("")

  freq = Utils.frequency(enc)

  list.push [freq, enc]
end

res = list.sort { |i, j| i[0] <=> j[0] }[0][1]

puts res
puts test
