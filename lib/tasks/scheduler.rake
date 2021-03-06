# -*- coding: utf-8 -*-
namespace :scheduler do
	desc 'Send totales diarios'
	task :enviar_totales_diarios, [:fecha] => [:environment] do |t, args|
		if args.fecha.nil?
			fecha = Time.now.to_date
		else
			fecha = Date.parse(args.fecha)
		end

		items_hoy = Item.select('retailer_id, count(*)').joins(:prices).where(:prices => { :price_date => fecha }).group('retailer_id')
		items_ayer = Item.select('retailer_id, count(*)').joins(:prices).where(:prices => { :price_date => fecha - 1.day }).group('retailer_id')

		totales = Hash.new
		items_ayer.each do |i|
			if !totales[i.retailer_id].is_a?Hash
				totales[i.retailer_id] = Hash.new
			end
			totales[i.retailer_id]['ayer'] = i.count
		end
		items_hoy.each do |i|
			if !totales[i.retailer_id].is_a?Hash
				totales[i.retailer_id] = Hash.new
			end
			totales[i.retailer_id]['hoy'] = i.count
		end

		@retailers = Hash.new
		Retailer.all.each do |r|
			@retailers[r.id] = [ r.name, r.country.name, totales[r.id], Item.where(:product_id => nil, :ignored => nil, :retailer_id => r.id).count ]
		end

		mail_template = File.read(File.join(Rails.root, "app/views/items/mail.totales.diarios.html.erb"))
		@titulo = 'Totales scraping'
 		Pony.mail(
			:to => 'andres.marin@idashboard.com.ar',
			:cc => 'ptraverso@gmail.com',
			:from => 'noreply@idashboard.la',
			:subject => '[iDashboard] Totales scraping de ' +  fecha.strftime('%d/%m/%Y'),
			:html_body => ERB.new(mail_template).result(binding)
		)
	end
	desc 'Send catalogs'
	task :send_catalogs, [:mes] => [:environment] do |t, args|
		if Time.now.in_time_zone('America/Argentina/Buenos_Aires').strftime('%d') != "07" and args.mes.nil?
			abort('no es el 7 del mes')
		end

		mail_template = File.read(File.join(Rails.root, "app/views/sales/mail.catalogos.html.erb"))
		meses = [nil, 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre']

		if !args.mes.nil?
			query = 'extract(month from sale_date) = ' + args.mes + ' and extract(year from sale_date) = extract(year from current_date) and sales.retailer_id = :retailer_id and media_channels.media_channel_type_id = :media_channel_type_id and products.product_type_id = :product_type_id and retailers.country_id = :country_id'
		else
			query = 'extract(month from sale_date) = extract(month from current_date) and extract(year from sale_date) = extract(year from current_date) and sales.retailer_id = :retailer_id and media_channels.media_channel_type_id = :media_channel_type_id and products.product_type_id = :product_type_id and retailers.country_id = :country_id'
		end
		

		Subscription.select('product_type_id, country_id').group('product_type_id, country_id').each do |s|
			Retailer.all.each do |r|
				@sales = Sale.joins(:retailer, :product, :media_channel).where(
					query,
					{
						:retailer_id => r.id, 
						:media_channel_type_id => MediaChannelType.find_by_name('catalogo').id,
						:product_type_id => s.product_type_id,
						:country_id => s.country_id
					}
				)

				if !@sales.empty?
					Subscription.where(:product_type_id => s.product_type_id, :country_id => s.country_id).each do |ss|
						@titulo = 'Publicaciones ' + r.name + ' de ' +  meses[Time.now.in_time_zone('America/Argentina/Buenos_Aires').strftime('%m').to_i]
				 		Pony.mail(
							:to => ss.user.email,
							:from => 'publicaciones@idashboard.la',
							:subject => '[iDashboard Publicaciones] Publicaciones ' + r.name + ' de ' +  meses[Time.now.in_time_zone('America/Argentina/Buenos_Aires').strftime('%m').to_i],
							:html_body => ERB.new(mail_template).result(binding)
						)
				 	end
				end
			end
		end
	end
	desc 'Send diarios'
	task :send_diarios, [:custom_date] => [:environment] do |t, args|
		if !args.custom_date.nil?
			interval = " and sale_date > '" + args.custom_date + "'"
		else
			if Time.now.in_time_zone('America/Argentina/Buenos_Aires').strftime('%w') == "1"
				interval = " and sale_date > current_date - interval '4 days'"
			elsif Time.now.in_time_zone('America/Argentina/Buenos_Aires').strftime('%w') == "4"
				interval = " and sale_date > current_date - interval '3 days'"
			else
				abort('ni lunes ni jueves')
			end
		end

		query = 'media_channels.media_channel_type_id = :media_channel_type_id and products.product_type_id = :product_type_id and retailers.country_id = :country_id' + interval

		mail_template = File.read(File.join(Rails.root, "app/views/sales/mail.diarios.html.erb"))

		Subscription.select('product_type_id, country_id').group('product_type_id, country_id').each do |s|
			@sales = Sale.joins(:retailer, :product, :media_channel).where(
				query,
				{
					:media_channel_type_id => MediaChannelType.find_by_name('diario').id,
					:product_type_id => s.product_type_id,
					:country_id => s.country_id
				}
			)

			if !@sales.empty?
				Subscription.where(:product_type_id => s.product_type_id, :country_id => s.country_id).each do |ss|
					@titulo = 'Publicaciones al ' +  Time.now.in_time_zone('America/Argentina/Buenos_Aires').strftime('%d/%m/%Y')
			 		Pony.mail(
						:to => ss.user.email,
						:from => 'publicaciones@idashboard.la',
						:subject => '[iDashboard Publicaciones] Publicaciones al ' +  Time.now.in_time_zone('America/Argentina/Buenos_Aires').strftime('%d/%m/%Y'),
						:html_body => ERB.new(mail_template).result(binding)
					)
			 	end
			end	
		end
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
