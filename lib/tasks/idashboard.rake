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

	desc 'Create ruletypes for rules'
	task :create_ruletypes => :environment do
		RuleType.create(:description => 'Cambio de precio').save()
		RuleType.create(:description => 'Retailer').save()
		RuleType.create(:description => 'Marca').save()
		RuleType.create(:description => 'Producto').save()
	end

	desc 'Add country to catalogs'
	task :add_country_to_catalogs => :environment do
		MediaChannel.where(:name => 'cat&aacute;logo Fr&aacute;vega').first.update_attributes(:country => Country.find_by_name('Argentina'))
		MediaChannel.where(:name => 'cat&aacute;logo Garbarino').first.update_attributes(:country => Country.find_by_name('Argentina'))
		MediaChannel.where(:name => 'cat&aacute;logo Falabella').first.update_attributes(:country => Country.find_by_name('Argentina'))
		MediaChannel.where(:name => 'cat&aacute;logo Megatone').first.update_attributes(:country => Country.find_by_name('Argentina'))
		MediaChannel.where(:name => 'cat&aacute;logo Carrefour').first.update_attributes(:country => Country.find_by_name('Argentina'))
		MediaChannel.where(:name => 'cat&aacute;logo Compumundo').first.update_attributes(:country => Country.find_by_name('Argentina'))
		MediaChannel.where(:name => 'cat&aacute;logo Ribeiro').first.update_attributes(:country => Country.find_by_name('Argentina'))
		MediaChannel.where(:name => 'cat&aacute;logo Falabella').first.update_attributes(:country => Country.find_by_name('Chile'))
		MediaChannel.where(:name => 'cat&aacute;logo Ripley').first.update_attributes(:country => Country.find_by_name('Chile'))
		MediaChannel.where(:name => 'cat&aacute;logo Par&iacute;s').first.update_attributes(:country => Country.find_by_name('Chile'))
		MediaChannel.where(:name => 'cat&aacute;logo La Polar').first.update_attributes(:country => Country.find_by_name('Chile'))
		MediaChannel.where(:name => 'cat&aacute;logo Abcdin').first.update_attributes(:country => Country.find_by_name('Chile'))
	end

	desc 'Inicializar memstore'
	task :inicializar_memstore => :environment do
	    REDIS.flushall

	    marcas_por_country = Hash.new
	    marcas_por_product_type = Hash.new
	    Product.all.each do |p|
	      REDIS.set "obj.product:#{p.id}", Marshal.dump(p)
	      REDIS.sadd "descripcion.product:#{p.id}", "#{p.id}|#{p.descripcion}"
	      REDIS.sadd "product_type:#{p.product_type.id}", p.id

	      unless marcas_por_product_type.has_key?(p.product_type.id)
	        marcas_por_product_type[p.product_type.id] = Hash.new
	      end
	      marcas_por_product_type[p.product_type.id][p.property_values.joins(:property).where(:properties => { :name => 'marca' }).first.id] = 1;

	      p.active_in_countries.each do |c|
	        REDIS.sadd "country:#{c.id}", p.id
	        unless marcas_por_country.has_key?(c.id)
	          marcas_por_country[c.id] = Hash.new
	        end
	        marcas_por_country[c.id][p.property_values.joins(:property).where(:properties => { :name => 'marca' }).first.id] = 1;
	      end
	      p.active_in_retailers.each do |r|
	        REDIS.sadd "retailer:#{r.id}", p.id
	        REDIS.sadd "retailers.product:#{p.id}", r.id
	      end
	      p.property_values.all.each do |pv|
	        REDIS.sadd "property_value:#{pv.id}", p.id
	        REDIS.sadd "pvs_product:#{p.id}", "#{pv.id}|#{pv.value}|#{pv.property.name}"
	      end

	      p.items.all.each do |i|
	      	i.prices.all.each do |pr|
			      REDIS.sadd "producto_precio:#{p.id}_#{i.retailer.country.currency.id}", pr.id
		    	end
		    end
	    end

	    marcas_por_product_type.keys.each do |pt|
	      marcas_por_product_type[pt].keys.each do |m|
	        REDIS.sadd "marcas_por_product_type:#{pt}", m
	      end
	    end

	    marcas_por_country.keys.each do |c|
	      marcas_por_country[c].keys.each do |m|
	        REDIS.sadd "marcas_por_country:#{c}", m
	      end
	    end

	    Retailer.all.each do |r|
	      REDIS.set "descripcion.retailer:#{r.id}", r.name
	      REDIS.sadd "retailers_country:#{r.country.id}", r.id
	    end
	end

	desc 'Inicializar MongoDB'
	task :inicializar_mongodb => :environment do
		Price.find_each do |pr|
			if pr.item.product_id.nil? or PricePoint.exists?(conditions: { id_postgres: pr.id })
				next
			end
			pr.create_pricepoint
		end
	end
end