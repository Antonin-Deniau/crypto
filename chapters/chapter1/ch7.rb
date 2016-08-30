require 'openssl'

text = File.open("#{File.dirname(__FILE__)}/ch6.txt").read
key = "YELLOW SUBMARINE"


c = OpenSSL::Cipher.new('AES-128-ECB')
c.decrypt
c.pkcs5_keyivgen(key)
c.update(text) + c.final


