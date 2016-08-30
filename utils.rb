module Utils
  def self.encode_xor(key, data)
    secret = data.each_with_index.map { |x, i| key[i % key.length].ord }
    data = data.map { |i| i.ord }

    out = secret.zip data

    out.map { |i| i[0] ^ i[1] }
  end

  def self.frequency str
    english_freq = [
      0.08167, 0.01492, 0.02782, 0.04253, 0.12702, 0.02228, 0.02015, # A-G
      0.06094, 0.06966, 0.00153, 0.00772, 0.04025, 0.02406, 0.06749, # H-N
      0.07507, 0.01929, 0.00095, 0.05987, 0.06327, 0.09056, 0.02758, # O-U
      0.00978, 0.02360, 0.00150, 0.01974, 0.00074                    # V-Z
    ]

    count = []
    ignored = 0
    for i in 0..26 - 1
      count[i] = 0
    end

    for i in 0..str.length - 1
      c = str[i].ord

      case true
      when c >= 65 && c <= 90
        count[c - 65] = count[c - 65] + 1 # uppercase A-Z
      when c >= 97 && c <= 122
        count[c - 97] = count[c - 97] + 1 # lowercase a-z
      when c >= 32 && c <= 126
        ignored = ignored + 1 # numbers and punct.
      when c == 9 || c == 10 || c == 13
        ignored = ignored + 1 # TAB, CR, LF
      else
        return 100000000000000000000  # not printable ASCII = impossible(?)
      end
    end

    chi2 = 0
    len = str.length - ignored

    for i in 0..26 - 1
      observed = count[i]
      expected = len * english_freq[i]
      difference = observed - expected
      chi2 += difference * difference / expected
    end

    return chi2
  end

  def self.hamming_byte a, b
    a = a.to_s(2).rjust(8, '0')
    b = b.to_s(2).rjust(8, '0')

    differences = 0

    [a.length, b.length].min.times.count do |index|
      differences += 1 if a[index] != b[index]
    end
  end

  def self.hamming text_1, text_2
    out = text_1.zip text_2
    out.map { |i| hamming_byte(i[0], i[1]) }.inject(0, :+).to_f
  end

  def self.decode_xor chunk
    list = []

    for x in 1..255
      enc = chunk.map { |i| i ^ x }.map { |i| i.chr }.join("")

      freq = frequency(enc)

      list.push [freq, enc, x]
    end

    list.sort { |i, j| i[0] <=> j[0] }
  end
end
