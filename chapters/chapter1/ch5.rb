require 'rspec'
extend RSpec::Matchers

test = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
data = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"

key = "ICE"

def xor(key, data)
  secret = data.scan(/.|\n/).each_with_index.map { |x, i| key[i % key.length].ord }
  data = data.scan(/.|\n/).map { |i| i.ord }

  out = secret.zip data

  out.map { |i| i[0] ^ i[1] }.map { |i| i.to_s(16).rjust(2, '0') }.join("")
end

res = xor(key, data)

describe do
  it { expect(res).to eq(test) }
end
