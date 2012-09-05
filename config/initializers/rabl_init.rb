# config/initializers/rabl_init.rb
Rabl.configure do |config|
  # Commented as these are the defaults
  config.include_json_root = false
  # config.include_xml_root  = false
  config.enable_json_callbacks = true
  # config.xml_options = { :dasherize  => true, :skip_types => false }}
  config.cache_sources = true
  config.cache_all_output = true
end