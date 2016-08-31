require_relative '../../utils'

list = []

text = File.open("#{File.dirname(__FILE__)}/ch8.txt").read
text.gsub!(/\r\n?/, "\n")

text.each_line do |line|
  enc = Utils.longest_repeated_substring line
  list.push [enc.length, line]
end

crypted = list.sort { |i, j| i[0] <=> j[0] }[0][1]

puts crypted
