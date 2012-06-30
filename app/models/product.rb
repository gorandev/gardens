# == Schema Information
#
# Table name: products
#
#  id              :integer         not null, primary key
#  status          :string(255)
#  product_type_id :integer
#  show_on_search  :boolean
#  created_at      :datetime
#  updated_at      :datetime
#  imagen_id       :integer
#

class Product < ActiveRecord::Base
  belongs_to :product_type
  has_and_belongs_to_many :property_values
  has_many :items
  has_many :retailers, :through => :items
  has_many :sales
  
  validates_presence_of :product_type, :property_values

  def active_in_countries
    countries_ids = Hash.new
    self.items.each do |i|
      countries_ids[i.retailer.country] = 1
    end
    return countries_ids.keys
  end

  def active_in_retailers
    retailers_ids = Hash.new
    self.items.each do |i|
      retailers_ids[i.retailer] = 1
    end
    return retailers_ids.keys
  end

  def descripcion
    marca = String.new
    modelo = String.new
    self.property_values.each do |pv|
      if pv.property.name == 'marca'
        marca = pv.value
      end
      if pv.property.name == 'modelo'
        modelo = pv.value
      end
    end
    if marca.blank? || modelo.blank?
      return nil
    else
      return marca + ' ' + modelo
    end
  end

  def marca
    return get_property_value('marca')
  end

  def modelo
    return get_property_value('modelo')
  end

  def get_property_value(property)
    propv = String.new
    self.property_values.each do |pv|
      if pv.property.name == property
        propv = pv.value
      end
    end
    return propv
  end
end

