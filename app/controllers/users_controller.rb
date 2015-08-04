class UsersController < ApplicationController

	def index

	end

	def show
		@user = User.find(params[:id])
	    @past_searches = Restaurant.where(:user_id => @user.id)
	    @recent_searches = @past_searches.last(4)




	end

	def rides

		@current_id = session[:user_id]


		client = Uber::Client.new do |config|
		config.server_token  = ENV["server_token"] 
		config.client_id     = ENV["client_id"]
		config.client_secret = ENV["client_secret"]
	end


		if params[:address] && params[:destination]

			#Load GOOGLE PLACES API
			google = GooglePlaces::Client.new(ENV['google_places'])
			
			#Take user input and search the GOOGLE API
			@restaurants = google.spots_by_query(params[:destination])
			
			#Grab address to the User destination
			address = @restaurants[0].formatted_address


			#Load in the YELP API and insert address 
			@yelp = Yelp.client.search(address)

			#Convert user address and location into lat and long 
			start_lat = Geocoder.coordinates(params[:address])[0]
			start_long = Geocoder.coordinates(params[:address])[1]
			end_lat = @yelp.businesses[0].location.coordinate.latitude
			end_long = @yelp.businesses[0].location.coordinate.longitude

			 #Get business name from Yelp
			 @name = @yelp.businesses[0].name

			 #Get business name from Yelp
			 @rating = @yelp.businesses[0].rating_img_url_large

	     	 #grab business image via address
	     	 @image = @yelp.businesses[0].image_url

	     	 #grab business image via address
	     	 @address = @yelp.businesses[0].location.display_address[2]

	     	 #Calculate estimates based on the user location and destination
	     	 @ride = client.price_estimations(start_latitude: start_lat, 
	     	 	start_longitude: start_long, end_latitude: end_lat, 
	     	 	end_longitude: end_long).first
	     	 @surge = @ride.surge_multiplier.to_i


	     	 @closest_driver = client.time_estimations(start_latitude: 
	     	 	start_lat, start_longitude: start_long).first.estimate

	     	 @ride_dine = (@ride.low_estimate + @ride.high_estimate) / 2
	     	 #When user searches, it saves their ride and dine in their user profiles
	     	 Restaurant.create(name: @name, address: @address, image: @image, 
	     	 rating: @rating, ride_estimate: @ride.estimate, user_id: @current_id)
	end
end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			log_in @user
			flash[:success] = "Welcome to Ride n' Dine!"
			redirect_to @user
		else
			render 'new'
		end
	end

	private	

	def user_params
		params.require(:user).permit(:user, :name, :email, :password,
			:password_confirmation)
		
	end

end
