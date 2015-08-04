client = Uber::Client.new do |config|
		config.server_token  = "server_token"
		config.client_id     = "client_id"
		config.client_secret = "client_secret"
	end