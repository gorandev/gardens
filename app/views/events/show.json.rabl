object @event
attributes :id, :precio_viejo, :precio_nuevo
attributes :created_at => :date
child :item do
	extends "items/show"
end