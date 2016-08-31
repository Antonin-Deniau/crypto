def longest_repeated_substring text
  size = text.size
  roots = {}
  size.times do |o|
    s = text[o,1]
    if roots.has_key? s
      roots[s] << o
    else
      roots[s] = [o]
    end
  end

  puts "Initial: #{roots.inspect}" if $VERBOSE
  len = 1
  first = nil
  while true do
    # Remove entries which don't have at least 2 non-overlapping  
    # occurances
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
    puts "Filter (len=#{len}): #{roots.inspect}" if $VERBOSE
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
    puts "Grow (len=#{len}): #{roots.inspect}" if $VERBOSE
  end
  text[first,len-1]
end

list = []

text = File.open("#{File.dirname(__FILE__)}/ch8.txt").read
text.gsub!(/\r\n?/, "\n")

text.each_line do |line|
  enc = longest_repeated_substring line
  list.push [enc.length, line]
end

crypted = list.sort { |i, j| i[0] <=> j[0] }[0][1]

puts crypted
