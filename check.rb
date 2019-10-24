require "json"
require "net/http"

now = Time.new
uri = URI('http://inet-ip.info/json')
res = Net::HTTP::get_response(uri)
new_data = JSON.parse(res.body)

json_file_path = 'log.json'
data = open(json_file_path) do |io|
  JSON.load(io)
end
keys = ['IP', 'Hostname']
changed = false
for key in keys
  if data[-1][key] != new_data[key]
    changed = true
    break
  end
end

if changed
  puts "changed!"
  pushed = new_data.select {|k, v| keys.include?(k)}
  pushed["time"] = now
  data.push(pushed)
  open(json_file_path, 'w') do |io|
    io.write(JSON.pretty_generate(data))
  end
end
