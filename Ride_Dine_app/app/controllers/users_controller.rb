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
		config.server_token  = "hhQrISZdmGcX6TCMC3gst2krkMYDLyrvZVohY-uS"
		config.client_id     = "PXBXYIADJaPVH6xEMzLL1073X9jkwL_t"
		config.client_secret = "m4Y4hxC5FQ5Tc_Zz7kU0tFpViJ5GQPoHgcdCikpD"
	end


		if params[:address] && params[:destination]
			google = GooglePlaces::Client.new('AIzaSyCDK7Ir3cMrH1SfraqLDQTfNLVYfWBAaYY')
			@restaurants = google.spots_by_query(params[:destination])
			address = @restaurants[0].formatted_address

			@yelp = Yelp.client.search(address)


			start_lat = Geocoder.coordinates(params[:address])[0]
			start_long = Geocoder.coordinates(params[:address])[1]
			end_lat = @yelp.businesses[0].location.coordinate.latitude
			end_long = @yelp.businesses[0].location.coordinate.longitude

			#enter address from Google Places into Yelp search 
			# @yelp = Yelp.client.search(address)
			#grab business rating via address 
			@name = @yelp.businesses[0].name

			@rating = @yelp.businesses[0].rating_img_url_large
	     	 #grab business image via address
	     	 @image = @yelp.businesses[0].image_url

	     	 @address = @yelp.businesses[0].location.display_address[2]

	     	 @ride = client.price_estimations(start_latitude: start_lat, 
	     	 	start_longitude: start_long, end_latitude: end_lat, 
	     	 	end_longitude: end_long).first
	     	 @surge = @ride.surge_multiplier.to_i

	     	 @closest_driver = client.time_estimations(start_latitude: 
	     	 	start_lat, start_longitude: start_long).first.estimate

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
