require 'json'

describe "message" do
	before(:all) do
    message = {"from" => "zack", "to" => "charles", "message" => "pizza tonight?"}.to_json
    uri = URI.parse("http://localhost:4567")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new("/")
		request.add_field('Content-Type', 'application/json')
		request.body = message
		@response = http.request(request)
  end

  it "returns with success" do
  	expect(@response.code).to eq("200")
  end

  it "returns at least 1 message when queried" do
		uri = URI.parse("http://localhost:4567/zack/charles/")
  	response = Net::HTTP.get_response(uri)
  	expect(response.code).to eq("200")
  	expect(JSON.parse(response.body).length).to be > 0
  end

  it "returns timestamps when queried" do
		uri = URI.parse("http://localhost:4567/zack/charles/")
  	response = Net::HTTP.get_response(uri)
  	expect(response.code).to eq("200")
  	expect(JSON.parse(response.body)[0]["at"]).to be > 1461740865
  end

  it "returns the message text when queried" do
		uri = URI.parse("http://localhost:4567/zack/charles/")
  	response = Net::HTTP.get_response(uri)
  	expect(JSON.parse(response.body)[0]['message']).to eq("pizza tonight?")
  end

  it "returns the message text when queried in the opposite order" do
		uri = URI.parse("http://localhost:4567/charles/zack/")
  	response = Net::HTTP.get_response(uri)
  	expect(JSON.parse(response.body)[0]['message']).to eq("pizza tonight?")
  end

  it "returns nothing when queried with wrong names on first part" do
		uri = URI.parse("http://localhost:4567/charlesx/zack/")
  	response = Net::HTTP.get_response(uri)
  	expect(JSON.parse(response.body).length).to eq(0)
  end

  it "returns nothing when queried with wrong names on second part" do
		uri = URI.parse("http://localhost:4567/charles/zackx/")
  	response = Net::HTTP.get_response(uri)
  	expect(JSON.parse(response.body).length).to eq(0)
  end

  it "returns nothing when queried in the future" do
		uri = URI.parse("http://localhost:4567/zack/charles/#{Time.now.to_i + 20000}")
  	response = Net::HTTP.get_response(uri)
  	expect(response.code).to eq("200")
  	expect(JSON.parse(response.body).length).to eq(0)
  end

  it "returns something when queried in the past" do
		uri = URI.parse("http://localhost:4567/zack/charles/#{Time.now.to_i - 20000}")
  	response = Net::HTTP.get_response(uri)
  	expect(response.code).to eq("200")
  	expect(JSON.parse(response.body).length).to be > 0
  end
end

describe "malfomed message" do
	before(:all) do
    message = {"from" => "zack", "to" => "charles"}.to_json
    uri = URI.parse("http://localhost:4567")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new("/")
		request.add_field('Content-Type', 'application/json')
		request.body = message
		@response = http.request(request)
  end

   it "returns 400" do
  	expect(@response.code).to eq("400")
  end
end

describe "blank message" do
	before(:all) do
    message = {"from" => "zack", "to" => "charles", "message" => ""}.to_json
    uri = URI.parse("http://localhost:4567")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new("/")
		request.add_field('Content-Type', 'application/json')
		request.body = message
		@response = http.request(request)
  end

   it "succeeds if the message text is blank" do
  	expect(@response.code).to eq("200")
  end
end

describe "blank username" do
	before(:all) do
    message = {"from" => "", "to" => "charles", "message" => "who am i????"}.to_json
    uri = URI.parse("http://localhost:4567")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new("/")
		request.add_field('Content-Type', 'application/json')
		request.body = message
		@response = http.request(request)
  end

   it "returns 400" do
  	expect(@response.code).to eq("400")
  end
end

describe "blank body when sending message" do
	before(:all) do
    uri = URI.parse("http://localhost:4567")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new("/")
		request.add_field('Content-Type', 'application/json')
		request.body = ""
		@response = http.request(request)
  end

   it "returns 400" do
  	expect(@response.code).to eq("400")
  end
end

describe "time filtered results" do
	before(:all) do
		6.times do
	    message = {"from" => "zack", "to" => "charles", "message" => "time"}.to_json
	    uri = URI.parse("http://localhost:4567")
			http = Net::HTTP.new(uri.host, uri.port)
			request = Net::HTTP::Post.new("/")
			request.add_field('Content-Type', 'application/json')
			request.body = message
			@response = http.request(request)
			sleep(1)
		end
  end


  it "returns less if recent" do
		uri = URI.parse("http://localhost:4567/zack/charles/#{Time.now.to_i - 2}")
  	response = Net::HTTP.get_response(uri)
  	expect(response.code).to eq("200")
  	expect(JSON.parse(response.body).length).to be < 3
  end

   it "returns more if older" do
		uri = URI.parse("http://localhost:4567/zack/charles/#{Time.now.to_i - 9}")
  	response = Net::HTTP.get_response(uri)
  	expect(response.code).to eq("200")
  	expect(JSON.parse(response.body).length).to be > 6
  end
end