require 'rspec'
extend RSpec::Matchers

require "base64"
require "words_counted"

test = "Cooking MC's like a pound of bacon"
pass = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

list = []

for x in 1..255
  ztest   = pass.scan(/../).map { |i| i.to_i(16) }
  zsecret = pass.scan(/../).map { |i| x }

  o = ztest.zip zsecret

  enc = o.map { |i| i[0] ^ i[1] }.map { |i| i.chr }.join("")

  counter = WordsCounted.count(enc) rescue next

  list.push [counter.char_count, enc]
end

puts list.sort { |i, j| i[0] <=> j[0] }[-1]
puts list.sort { |i, j| i[0] <=> j[0] }[-2]
puts list.sort { |i, j| i[0] <=> j[0] }[-3]
puts list.sort { |i, j| i[0] <=> j[0] }[-4]

=begin
E	12.02
T	9.10
A	8.12
O	7.68
I	7.31
N	6.95
S	6.28
R	6.02
H	5.92
D	4.32
L	3.98
U	2.88
C	2.71
M	2.61
F	2.30
Y	2.11
W	2.09
G	2.03
P	1.82
B	1.49
V	1.11
K	0.69
X	0.17
Q	0.11
J	0.10
Z	0.07
=end


describe do
  it { expect(enc).to eq(test) }
end
