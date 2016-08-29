require 'rspec'
extend RSpec::Matchers

test = "Cooking MC's like a pound of bacon"
pass = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

list = []

def get_chi2 str
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


for x in 1..255
  ztest   = pass.scan(/../).map { |i| i.to_i(16) }
  zsecret = pass.scan(/../).map { |i| x }

  o = ztest.zip zsecret

  enc = o.map { |i| i[0] ^ i[1] }.map { |i| i.chr }.join("")

  freq = get_chi2(enc)

  list.push [freq, enc]
end

res = list.sort { |i, j| i[0] <=> j[0] }[0][1]

describe do
  it { expect(res).to eq(test) }
end
