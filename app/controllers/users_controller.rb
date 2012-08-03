class UsersController < ApplicationController
	def index
		@pagina = 'Usuarios'
		@users = User.joins(:subscriptions).where(:subscriptions => { :country_id => @country_id, :product_type_id => @product_type_id})
	end

	def create
		if User.where(:email=> params[:email]).exists?
			sub = Subscription.new(
				:country => Country.find(@country_id),
				:product_type => ProductType.find(@product_type_id),
				:user => User.find_by_email(params[:email])
			)
			sub.save
			render :json => { :id => User.find_by_email(params[:email]).id }
			return
		end

		user = User.new( 
			:email => params[:email],
			:password => Devise.friendly_token.first(6)
		)

		if user.save
			sub = Subscription.new(
				:country => Country.find(@country_id),
				:product_type => ProductType.find(@product_type_id),
				:user => user
			)
			sub.save
			render :json => { :id => user.id }
		else
			render :json => { :errors => user.errors }, :status => 400
		end
	end

	def destroy
		unless user = User.find_by_id(params[:id])
			return render :json => { :errors => { :user => "must be valid" } }, :status => 400
		end
		Subscription.where(:user_id => user.id, :country_id => @country_id, :product_type_id => @product_type_id).each do |s|
			s.destroy
		end
		if !Subscription.where(:user_id => user.id).exists?
			user.destroy
		end
		render :json => "OK"
	end
end
