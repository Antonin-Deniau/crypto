require "openssl"
require "base64"
require_relative '../../utils'

=begin
  - Knowing the block size, craft an input block that is exactly 1 byte short (for instance, if the block size is 8 bytes, make "AAAAAAA"). Think about what the oracle function is going to put in that last byte position.
  - Make a dictionary of every possible last byte by feeding different strings to the oracle; for instance, "AAAAAAAA", "AAAAAAAB", "AAAAAAAC", remembering the first block of each invocation.
  - Match the output of the one-byte-short input to one of the entries in your dictionary. You've now discovered the first byte of unknown-string.
  - Repeat for the next byte.
=end

def generate_key
  (0..15).to_a.map { |i| rand(0..255) }.pack("C*")
end

def ecb(text)
  crypto = OpenSSL::Cipher.new('AES-128-ECB')
  crypto.encrypt
  crypto.key = $key

  crypto.update(text) + crypto.final
end

$key = generate_key

#res = ecb Base64.decode("Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkgaGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBqdXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUgYnkK")

list = []
for i in 1..63
  res = ecb("A" * i)

  list.push([i, Utils.longest_repeated_substring(res)])
end

l = list.sort { |a, b| b[1].length <=> a[1].length }[0][1].length

puts "KEYLENGTH: #{l}"

res = ecb("A" * 64)

chunk_1 = res[0..15]
chunk_2 = res[16..31]

if chunk_1 == chunk_2
  puts "===========ecb=========="
else
  puts "===========cbc=========="
end

cmp = ecb("A" * 15)

for i in 0..255
  res = ecb(("A" * 15) + i.chr)

  puts "#{i.chr.inspect} #{ res == cmp ? "SUCCESS================" : "BAD"}"
end
