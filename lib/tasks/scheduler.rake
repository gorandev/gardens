# -*- coding: utf-8 -*-
namespace :scheduler do
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

		ruletype_signatures.each do |k,v|
			events = nil
			desc_alerta = Array.new
			v.first.rules.each do |r|
				case r.rule_type.description
				when 'Cambio de precio'
					if events.nil?
						events = Event.where('ABS(precio_nuevo - precio_viejo) >= (precio_viejo * :porcentaje)', { :porcentaje => (r.value.nil? ? 0 : r.value.to_i)/100.to_f })
					else
						events = events.where('ABS(precio_nuevo - precio_viejo) >= (precio_viejo * :porcentaje)', { :porcentaje => (r.value.nil? ? 0 : r.value.to_i)/100.to_f })
					end
					if r.value.nil?
						desc_alerta.push('Cambio de precio: cualquiera')
					else
						desc_alerta.push("Cambio de precio: en un #{r.value}%")
					end
				when 'Retailer'
					if r.value.nil?
						next
					end
					if events.nil?
						events = Event.joins(:item).where(:items => { :retailer_id => r.value })
					else
						events = events.joins(:item).where(:items => { :retailer_id => r.value })
					end
					desc_alerta.push('Retailer: ' + Retailer.find(r.value).name)
				when 'Marca'
					if r.value.nil?
						next
					end
					if events.nil?
						events = Event.joins(:item=>{:product => :property_values}).uniq.where(:property_values => { :id => r.value })					
					else
						events = events.joins(:item=>{:product => :property_values}).uniq.where(:property_values => { :id => r.value })
					end
					desc_alerta.push('Marca: ' + PropertyValue.find(r.value).value)
				when 'Producto'
					if r.value.nil?
						next
					end
					if events.nil?
						events = Event.joins(:item).where(:items => { :product_id => r.value })
					else
						events = events.joins(:item).where(:items => { :product_id => r.value })
					end
					desc_alerta.push('Producto: ' + Product.find(r.value).descripcion)
				end
			end

			if events.nil?
				next
			end

			v.each do |a|
				latest_event_id = 0
				@events_ordered = Hash.new
				@desc_alerta = desc_alerta.join(', ')
				@country_id = a.country.id

				ev = events.where('events.id > ?', (a.event.nil? ? 0 : a.event.id))
				ev = ev.joins(:item => [:product, :retailer]).where(
					:products => { :product_type_id => a.product_type.id }, :retailers => { :country_id => a.country.id }
				)
				
				ev.each do |e|
					if e.item.product.nil?
						next
					end
		 			if !@events_ordered[e.item.retailer.name].is_a?Array
						@events_ordered[e.item.retailer.name] = Array.new
					end
					@events_ordered[e.item.retailer.name].push(e)
					if e.id > latest_event_id
						latest_event_id = e.id
					end
				end

				if @events_ordered.keys.length > 0
			 		Pony.mail(
						:to => a.user.email,
						:from => 'alertas@idashboard.la',
						:subject => '[iDashboard Alert] Alerta de cambio de precio - ' + a.country.name + ' - ' + Time.now.in_time_zone('America/Argentina/Buenos_Aires').strftime('%d-%m-%y %H:%M'),
						:html_body => ERB.new(mail_template).result(binding)
					)
		 		end

				if latest_event_id > 0
					a.event = Event.find(latest_event_id)
					a.save
				end
			end
		end
	end
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