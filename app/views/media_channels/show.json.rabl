object @media_channel
attributes :id, :name, :media_channel_type
glue :country do
	attributes :name => :country
end