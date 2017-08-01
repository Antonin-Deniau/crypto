import urlparse
import urllib
import os
from Crypto import Random
from Crypto.Cipher import AES

key = os.urandom(16)

def parse(url):
  return dict(urlparse.parse_qsl(urlparse.urlsplit(url).query))

def create(json):
  return urllib.urlencode(json)

def pad(s):
  return s + (AES.block_size - len(s) % AES.block_size) * chr(AES.block_size - len(s) % AES.block_size)

def unpad(s):
  return s[:-ord(s[len(s)-1:])]

def ecb(raw):
  global key

  raw = pad(raw)

  iv = Random.new().read(AES.block_size)
  cipher = AES.new(key, AES.MODE_ECB, iv )
  return iv + cipher.encrypt(raw)

def de_ecb(raw):
  iv = raw[:AES.block_size]
  cipher = AES.new(key, AES.MODE_ECB, iv)
  return unpad(cipher.decrypt(raw[AES.block_size:]))

def profile_for(email):
  email = email.replace("=", "").replace("&", "")
  prof = {
      "email": email,
      "uid": 10,
      "role": "user"
  }
  return create(prof)

def encrypt(profile):
  return ecb(profile)

def decrypt(profile):
  return de_ecb(profile)

profile = profile_for("antonin.deniau@protonmail.com")
print "Init: {}".format(profile)

encrypted = encrypt(profile)
print "Encrypted: {}".format(encrypted)

decrypted = decrypt(encrypted)
print "Decrypted: {}".format(decrypted)
