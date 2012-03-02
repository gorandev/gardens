class SavedReportsController < ApplicationController
	before_filter :authenticate_user!
	respond_to :json

	def create
		last_orden = SavedReport.where(:user_id => current_user.id).order("saved_reports.orden DESC").limit(1).first

		if last_orden.nil?
			last_orden = 1
		else
			last_orden = last_orden.orden + 1
		end

		saved_report = SavedReport.new( 
			:url => params[:url],
			:querystring => params[:querystring],
			:user => current_user,
			:orden => last_orden,
			:product_type => ProductType.find_by_id(@product_type_id)
		)

		if saved_report.save
			render :json => { :id => saved_report.id }
		else
			render :json => { :errors => saved_report.errors }, :status => 400
		end
	end

	def show_all
		@pagina = 'Reportes'
		@saved_reports = SavedReport.where(:user_id => current_user, :product_type_id => @product_type_id).order('saved_reports.orden ASC')
	end
end