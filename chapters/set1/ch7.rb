require 'openssl'
require 'base64'

text = Base64.decode64 File.open("#{File.dirname(__FILE__)}/ch7.txt").read

crypto = OpenSSL::Cipher.new('AES-128-ECB')
crypto.key = "YELLOW SUBMARINE"

puts crypto.update(text) + crypto.final
