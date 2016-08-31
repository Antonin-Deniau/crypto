require_relative '../../utils'
require 'openssl'
require 'base64'

text = Base64.decode64 File.open("#{File.dirname(__FILE__)}/ch10.txt").read

key = "YELLOW SUBMARINE"
iv =  "\x00" * key.length

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

puts res
