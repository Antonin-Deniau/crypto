require_relative '../../utils'
require 'base64'

text = Base64.decode64(File.open("#{File.dirname(__FILE__)}/ch6.txt").read).each_byte.map { |i| i }

list = []

puts "=============BEGIN BREAK CYPHER=============="

puts "====GUESS KEYSIZES===="
def get_key(index, length, text)
  text[length * index..(length * (index + 1)) - 1]
end

for keysize in 1..39
  puts "=====TRY #{keysize + 1}====="

  worths = []
  for i in 0..13
    worths.push(get_key(i, keysize + 1, text))
  end

  worths = worths.each_slice(2).map { |i| Utils.hamming(i[0], i[1]) / (keysize + 1).to_f }
  hamming = worths.inject(0, :+) / worths.length


  puts "HAMMING: " + hamming.to_s
  puts "========================"
  puts

  list << [hamming, keysize + 1]
end
puts
puts

puts "====KEYSIZES===="
puts "1: " + list.sort { |a,b| a[0] <=> b[0] }[0][1].to_s
puts "2: " + list.sort { |a,b| a[0] <=> b[0] }[1][1].to_s
puts "3: " + list.sort { |a,b| a[0] <=> b[0] }[2][1].to_s
puts "4: " + list.sort { |a,b| a[0] <=> b[0] }[3][1].to_s
puts "5: " + list.sort { |a,b| a[0] <=> b[0] }[4][1].to_s
place = 0 # 0 = first, 1 = second, 2 = third

keysize = list.sort { |a,b| a[0] <=> b[0] }[place][1]
puts "================"
puts
puts

puts "=======CREATE SLICES======"
slices = text.each_slice(keysize).map { |i| keysize.times.collect { |j| i[j] || 0 } }
puts "1ST SLICE: " + text.each_slice(keysize).map { |i| i }[0].join("-")
puts "2ST SLICE: " + text.each_slice(keysize).map { |i| i }[1].join("-")
puts "=========================="
puts
puts

puts "====TRANSPOSE SLICES======"
chunks = slices.transpose
puts "1ST CHUNK: " + chunks[0].join("-")
puts
puts "2ND CHUNK: " + chunks[1].join("-")
puts "=========================="
puts
puts

puts "=====BREAK KEY===="
key = ""
for i in 0..keysize -1
  key << Utils.decode_xor(chunks[i])[0][2]
end
puts key
puts "========================"
puts
puts

puts "====MANUAL CORRECTION===="
key = "Terminator X: Bring the noise"
puts key
puts "========================="
puts
puts

puts "=====RESULT============="
puts Utils.encode_xor(key, text).map { |i| i.chr }.join("")
puts "========================"
