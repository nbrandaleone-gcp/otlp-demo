require "http/client"

loop do
  sequence = (rand * 41000).to_i
  print "Fibonacci ##{sequence}: "
  #response = HTTP::Client.get("http://127.0.0.1:5000?n=#{sequence}")
  response = HTTP::Client.get("https://otel-cloud-run-demo-161156519703.us-central1.run.app?n=#{sequence}")
  if response.success?
    puts response.body
  else
    puts "ERROR: #{response.status}"
  end

  sleep rand(5).seconds
end
