#require 'rspec'
require 'base64'
#extend RSpec::Matchers

text = File.open("#{File.dirname(__FILE__)}/ch6.txt").read.each_byte.map { |i| i }

def hamming text_1, text_2
  def hamming_byte a, b
    a = a.to_s(2)
    b = b.to_s(2)

    differences = 0

    [a.length, b.length].min.times.count do |index|
      differences += 1 if a[index] != b[index]
    end
  end

  puts text_1.bytes.map { |i| i.to_s(2).rjust(8, ' ') }.join("-")
  puts text_2.bytes.map { |i| i.to_s(2).rjust(8, ' ') }.join("-")

  text_1 = text_1.bytes
  text_2 = text_2.bytes

  out = text_1.zip text_2

  out.map { |i| hamming_byte(i[0], i[1]) }.inject(0, :+)
end

puts hamming("this is a test", "wokka wokka!!!")

=begin
################################################



plain = Base64.decode64 File.open("#{File.dirname(__FILE__)}/ch6.txt").read

def xor(key, data)
  secret = data.scan(/.|\n/).each_with_index.map { |x, i| key[i % key.length].ord }
  data = data.scan(/.|\n/).map { |i| i.ord }

  out = secret.zip data

  out.map { |i| i[0] ^ i[1] }.map { |i| i.to_s(16).rjust(2, '0') }.join("")
end

plain.each_byte.each_slice(7) do |i|
end

#describe do
#  it { expect(res).to eq(test) }
#end
=end
