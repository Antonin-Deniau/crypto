require "openssl"
require "base64"
require_relative '../../utils'

$key = (0..15).to_a.map { |i| rand(0..255) }.pack("C*")

def ecb(text)
  crypto = OpenSSL::Cipher.new('AES-128-ECB')
  crypto.encrypt
  crypto.key = $key
  crypto.padding = text.length % $key.length

  crypto.update(text) + crypto.final
end

def oracle(text)
  t = Base64.decode64 "Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkgaGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBqdXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUgYnkK"
  ecb(text + t)
end

list = []
for i in 1..63
  res = oracle("A" * i)

  list.push([i, Utils.longest_repeated_substring(res)])
end

l = list.sort { |a, b| b[1].length <=> a[1].length }[0][1].length

puts "KEYLENGTH: #{l}"

res = oracle("A" * 64)

chunk_1 = res[0..15]
chunk_2 = res[16..31]

if chunk_1 == chunk_2
  puts "===========ecb=========="
else
  puts "===========cbc=========="
end

def brute(t, l)
  j = oracle("A" * l + t)

  for x in 0..255
    r = oracle("A" * l + t + x.chr)

    if j[0..15] == r[0..15]
      return x
    end
  end
end

s = ""
(0..15).to_a.reverse.each do |i|
  s << brute(s, i).chr
end

puts s
