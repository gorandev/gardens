# == Schema Information
# Schema version: 20110618000754
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

  def inicializar_memstore
    REDIS.flushall

    Product.all.each do |p|
      REDIS.set "obj.product:#{p.id}", Marshal.dump(p)
      REDIS.sadd "descripcion.product:#{p.id}", "#{p.id}|#{p.descripcion}"
      REDIS.sadd "product_type:#{p.product_type.id}", p.id
      p.active_in_countries.each do |c|
        REDIS.sadd "country:#{c.id}", p.id
      end
      p.active_in_retailers.each do |r|
        REDIS.sadd "retailer:#{r.id}", p.id
        REDIS.sadd "retailers.product:#{p.id}", r.id
      end
      p.property_values.all.each do |pv|
        REDIS.sadd "property_value:#{pv.id}", p.id
        REDIS.sadd "pvs_product:#{p.id}", "#{pv.id}|#{pv.value}|#{pv.property.name}"
      end
    end

    Retailer.all.each do |r|
      REDIS.set "descripcion.retailer:#{r.id}", r.name
      REDIS.sadd "retailers_country:#{r.country.id}", r.id
    end
  end
end