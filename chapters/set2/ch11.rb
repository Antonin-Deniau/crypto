require_relative '../../utils'
require 'openssl'
require 'base64'

def ecb(key, text)
  crypto = OpenSSL::Cipher.new('AES-128-ECB')
  crypto.key = key

  crypto.update(text) + crypto.final
end

def cbc(key, text)
  iv =  (rand(0..255)).chr * key.length

  res = ""

  text.bytes.each_slice(16) do |slice|
    slice = slice.pack("C*")

    crypto = OpenSSL::Cipher.new('AES-128-ECB')
    crypto.key = key
    crypto.padding = 0

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
  data = data + ("\x00" * (16 - (data.length % 16)))

  alg = rand(2) == 1 ? 'ECB' : 'CBC'
  key = generate_key

  if alg == 'CBC'
    cbc key, data
  else
    ecb key, data
  end
end


puts generate_data("1" * 16)
