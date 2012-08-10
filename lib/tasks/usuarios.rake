# -*- coding: utf-8 -*-
namespace :usuarios do
	desc 'Crear alertas'
	task :crear_alertas => :environment do
		User.all.each do |u|
		    alert = Alert.create( 
      			:user => u,
      			:product_type => ProductType.find(1),
      			:country => Country.find(1),
      			:event => Event.last
			)
			rules = [
				Rule.create(
					:alert => alert,
					:rule_type => RuleType.find_by_description('Cambio de precio'),
					:value => 5
  				)
			]
			alert.rules = rules
			alert.save
		end
	end
end