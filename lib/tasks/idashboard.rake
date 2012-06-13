# -*- coding: utf-8 -*-
namespace :idashboard do
	desc 'Add description to properties'
	task :add_props => :environment do
		Property.where(:name => 'categoria').first.description = 'Categoría'
		Property.where(:name => 'marca_procesador').first.description = 'Marca de Procesador'
		Property.where(:name => 'modelo_procesador').first.description = 'Modelo de Procesador'
		Property.where(:name => 'marca').first.description = 'Marca'
		Property.where(:name => 'modelo').first.description = 'Modelo'
		Property.where(:name => 'disco').first.description = 'HDD'
		Property.where(:name => 'memoria').first.description = 'RAM'
		Property.where(:name => 'pantalla').first.description = 'Pantalla'
		Property.where(:name => 'os').first.description = 'OS'
		Property.where(:name => 'disp_optico').first.description = 'CD/DVD'
		Property.where(:name => 'familia_procesador').first.description = 'Familia de Procesador'
		Property.where(:name => 'touch').first.description = 'Touch'
	end
end