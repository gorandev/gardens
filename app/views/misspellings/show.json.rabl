object @misspelling
attributes :id, :value
glue :word do
	attributes :id => :word_id, :value => :word_value
end