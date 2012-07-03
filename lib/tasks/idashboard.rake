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
end