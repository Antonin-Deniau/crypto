require_relative '../../utils'
require 'openssl'
require 'base64'

def ecb(key, text)
  puts "=======ecb========"
  crypto = OpenSSL::Cipher.new('AES-128-ECB')
  crypto.encrypt
  crypto.key = key

  crypto.update(text) + crypto.final
end

def cbc(key, text)
  puts "=======cbc========"
  iv =  (rand(0..255)).chr * key.length

  res = ""

  text.bytes.each_slice(16) do |slice|
    slice = slice.pack("C*")

    crypto = OpenSSL::Cipher.new('AES-128-ECB')
    crypto.encrypt
    crypto.key = key

    out = crypto.update(slice) + crypto.final

    res << Utils.encode_xor(iv, out.bytes).pack("C*")

    iv = slice
  end
  res
end

def generate_key
  (0..15).to_a.map { |i| rand(0..255) }.pack("C*")
end

def generate_random
  (0..rand(4..9)).to_a.map { |i| rand(0..255) }.pack("C*")
end

def generate_data(data)
  data = generate_random + data + generate_random
  key = generate_key

  padding  = (key.length - (data.length % key.length))
  data = data + (padding.chr * padding)

  if rand(2) == 1
    cbc(key, data)
  else
    ecb(key, data)
  end

  # 16 pout skip rand | 2 * 16 pout detect | 16 pour skip rand | idk
  # rand * 16         | input              | rand * 16         | padding
end

for i in 0..10
  puts
  res = generate_data("0" * 64)

  chunk_1 = res[16..31]
  chunk_2 = res[32..47]

  if chunk_1 == chunk_2
    puts "-------ecb--------"
  else
    puts "-------cbc--------"
  end
end
