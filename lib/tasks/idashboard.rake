# -*- coding: utf-8 -*-
namespace :idashboard do
	desc 'Add description to properties'
	task :add_props => :environment do
		Property.where(:name => 'categoria').first.update_attributes(:description => 'Categoría')
		Property.where(:name => 'marca_procesador').first.update_attributes(:description => 'Marca de Procesador')
		Property.where(:name => 'modelo_procesador').first.update_attributes(:description => 'Modelo de Procesador')
		Property.where(:name => 'marca').first.update_attributes(:description => 'Marca')
		Property.where(:name => 'modelo').first.update_attributes(:description => 'Modelo')
		Property.where(:name => 'disco').first.update_attributes(:description => 'HDD')
		Property.where(:name => 'memoria').first.update_attributes(:description => 'RAM')
		Property.where(:name => 'pantalla').first.update_attributes(:description => 'Pantalla')
		Property.where(:name => 'os').first.update_attributes(:description => 'OS')
		Property.where(:name => 'disp_optico').first.update_attributes(:description => 'CD/DVD')
		Property.where(:name => 'familia_procesador').first.update_attributes(:description => 'Familia de Procesador')
		Property.where(:name => 'touch').first.update_attributes(:description => 'Touch')
	end

	desc 'Send alerts'
	task :send_alerts => :environment do

		mail_template = File.read(File.join(Rails.root, "app/views/events/mail.html.erb"))

		ruletype_signatures = Hash.new
		Alert.all.each do |a|
			if !ruletype_signatures[a.ruletype_signature].is_a?Array
				ruletype_signatures[a.ruletype_signature] = Array.new
			end
			ruletype_signatures[a.ruletype_signature].push(a)
		end

## finding retailer
## Event.joins(:item).where(:items => { :retailer_id => 4 })

## finding marca
## Event.joins(:item => :property_values).where(:property_values => { :id => 36 })
## Event.joins(:item=>{:product => :property_values}).uniq.where(:property_values => { :id => 36 })

## finding modelo
## Event.joins(:item).where(:items => { :product_id => 412 })

## finding porcentaje de cambio de precio
## Event.joins(:item).where('ABS(precio_nuevo - precio_viejo) >= (precio_viejo * :porcentaje)', { :porcentaje => 30/100.to_f })

# combinaciones
# Event.where('ABS(precio_nuevo - precio_viejo) >= (precio_viejo * :porcentaje)', { :porcentaje => 30/100.to_f }).joins(:item).where(:items => { :retailer_id => 4 })

		ruletype_signatures.each do |k,v|
			events = nil
			v.first.rules.each do |r|
				case r.rule_type.description
				when 'Cambio de precio'
					if events.nil?
						events = Event.where('ABS(precio_nuevo - precio_viejo) >= (precio_viejo * :porcentaje)', { :porcentaje => (r.value.nil? ? 0 : r.value)/100.to_f })
					else
						events = events.where('ABS(precio_nuevo - precio_viejo) >= (precio_viejo * :porcentaje)', { :porcentaje => (r.value.nil? ? 0 : r.value)/100.to_f })
					end
				when 'Retailer'
					if events.nil?
						events = Event.joins(:item).where(:items => { :retailer_id => r.value })
					else
						events = events.joins(:item).where(:items => { :retailer_id => r.value })
					end
				when 'Marca'
					if events.nil?
						events = Event.joins(:item=>{:product => :property_values}).uniq.where(:property_values => { :id => r.value })					
					else
						events = events.joins(:item=>{:product => :property_values}).uniq.where(:property_values => { :id => r.value })
					end
				when 'Producto'
					if events.nil?
						events = Event.joins(:item).where(:items => { :product_id => r.value })
					else
						events = events.joins(:item).where(:items => { :product_id => r.value })
					end
				end
			end

 			@events_ordered = Hash.new
 			events.each do |e|
	 			if !@events_ordered[e.item.retailer.name].is_a?Array
					@events_ordered[e.item.retailer.name] = Array.new
				end
				@events_ordered[e.item.retailer.name].push(e)
 			end

	 		Pony.mail(
				:to => 'mondongo@gmail.com',
				:from => 'alertas@idashboard.la',
				:subject => '[iDashboard Alert] Alerta de cambio de precio - Argentina - ' + Time.now.in_time_zone('America/Argentina/Buenos_Aires').strftime('%d-%m-%y %H:%M'),
				:html_body => ERB.new(mail_template).result(binding)
			)
 			
		end
	end

	desc 'Create ruletypes for rules'
	task :create_ruletypes => :environment do
		RuleType.create(:description => 'Cambio de precio').save()
		RuleType.create(:description => 'Retailer').save()
		RuleType.create(:description => 'Marca').save()
		RuleType.create(:description => 'Producto').save()
	end
end