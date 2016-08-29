#require 'rspec'
require 'base64'
#extend RSpec::Matchers

def find_string text
  size = text.size
  # Build a map from each (1-character) string to a list of its positions
  roots = {}
  size.times do |o|
    s = text[o,1]
    if roots.has_key? s
      roots[s] << o
    else
      roots[s] = [o]
    end
  end

  len = 1
  first = nil

  while true do
    # Remove entries which don't have at least 2 non-overlapping  
    roots.delete_if do |s,offsets|
      count = 0
      last = nil
      offsets.each do |o|
        next if last && last+len > o
        last = o
        count += 1
      end
      count < 2
    end
    break if roots.size == 0
    first = roots[roots.keys[0]][0]

    # Increase len by 1 and replace each existing root with the set of  
    len += 1
    new_roots = {}
    roots.each do |s,offsets|
      offsets.each do |o|
        next if o > size - len
        s = text[o,len]
        if new_roots.has_key? s
          new_roots[s] << o
        else
          new_roots[s] = [o]
        end
      end
    end
    roots = new_roots
  end

  [text[first,len-1], first, len-1]
end

text = File.open("#{File.dirname(__FILE__)}/ch6.txt").read.each_byte.map { |i| i }

puts find_string(text).inspect

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
