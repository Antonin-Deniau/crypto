require_relative '../../utils'

test = "Now that the party is jumping"
list = []

text=File.open("#{File.dirname(__FILE__)}/ch4.txt").read
text.gsub!(/\r\n?/, "\n")

text.each_line do |line|
  for x in 1..255
    ztest   = line.scan(/../).map { |i| i.to_i(16) }
    zsecret = line.scan(/../).map { |i| x }

    o = ztest.zip zsecret

    enc = o.map { |i| i[0] ^ i[1] }.map { |i| i.chr }.join("")

    freq = Utils.frequency(enc)

    list.push [freq, enc]
  end
end

res = list.sort { |i, j| i[0] <=> j[0] }[2][1].strip

puts res
puts test
