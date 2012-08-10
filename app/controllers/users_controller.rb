# -*- coding: utf-8 -*-
class UsersController < ApplicationController
	def index
		@pagina = 'Usuarios'
		@users = User.joins(:subscriptions).where(:subscriptions => { :country_id => @country_id, :product_type_id => @product_type_id})
	end

	def reset_password
		unless current_user and current_user.administrator
			return render :json => { :errors => { :user => "not admin" } }, :status => 400
		end

		unless user = User.find_by_id(params[:id])
			return render :json => { :errors => { :user => "must be valid" } }, :status => 400
		end

		@email = user.email
		@pass = Devise.friendly_token.first(6)
		user.password = @pass
		user.save

		mail_template = File.read(File.join(Rails.root, "app/views/users/mail.newpassword.html.erb"))
		Pony.mail(
			:to => user.email,
			:from => 'cuentas@idashboard.la',
			:subject => '¡Su cuenta tiene una nueva clave!',
			:html_body => ERB.new(mail_template).result(binding)
		)
		render :json => "OK"
	end

	def create
		unless current_user and current_user.administrator
			return render :json => { :errors => { :user => "not admin" } }, :status => 400
		end

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

		@email = params[:email]
		@pass = Devise.friendly_token.first(6)
		user = User.new( 
			:email => params[:email],
			:password => @pass
		)

		if user.save
			sub = Subscription.new(
				:country => Country.find(@country_id),
				:product_type => ProductType.find(@product_type_id),
				:user => user
			)
			sub.save

			mail_template = File.read(File.join(Rails.root, "app/views/users/mail.bienvenida.html.erb"))
			Pony.mail(
				:to => user.email,
				:from => 'cuentas@idashboard.la',
				:subject => '¡Le damos la bienvenida a iDashboard!',
				:html_body => ERB.new(mail_template).result(binding)
			)

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
