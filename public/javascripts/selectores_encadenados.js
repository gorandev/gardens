function find_prop(campo) {
	var indice = -1;
	jQuery.each(pulldowns_ok, function(i, v) {
		if (v.campo == campo) {
			indice = i;
		}
	})
	return indice;
}

var _auto_start = 0;

function dibujar_pulldown_productos(obj) {
	var indice;
	if (obj == 'start_up') {
		indice = -1;
		_auto_start = 1;
	} else {
		indice = find_prop(obj.name);
		if (indice < 0) {
			return;
		}
	}

	agregar_tooltips();

	var data = '';

	var filtros = [];
	for ( var i = 0; i <= indice; i++ ) {
		if (jQuery('#' + pulldowns_ok[i].campo + '_pulldown').val()) {
			if (pulldowns_ok[i].campo == 'retailer') {
				data += 'retailers=' + jQuery('#' + pulldowns_ok[i].campo + '_pulldown').val().join(',');
				data += '&';
			} else {
				filtros.push(jQuery('#' + pulldowns_ok[i].campo + '_pulldown').val());	
			}
		}
	}

	for ( var i = indice+1; i < pulldowns_ok.length; i++ ) {
		jQuery('#span_' + pulldowns_ok[i].campo + '_pulldown').html(spinner);
	}
	jQuery('#span_producto_pulldown').html(spinner);

	if (filtros.length > 0) {
		data += 'property_values=' + filtros.join(',');	
	}
	
	data += '&country=' + country_id + '&product_type=' + product_type_id + '&fast=yeah';

	jQuery.ajax({
		url: "http://api." + global_hostname + "/products/search",
		data: data,
		dataType: 'jsonp',
		cache: false,
		statusCode: {
			200: function(data) {
				llenar_pulldown_productos(indice, data);
			},
			400: function() {
				alert('Error 400!');
			}
		}
	});
}

var global_ids_productos;
var selected_product;

function llenar_pulldown_productos(indice, data) {
	llenar_pulldown(data, 'producto', 'Producto');
	
	var ids_productos = new Array();
	jQuery.each(data, function(i, v){
		ids_productos.push(v.id);
	});

	global_ids_productos = ids_productos;

	jQuery.ajax({
		url: "http://api." + global_hostname + "/property_values/search",
		data: 'products=' + ids_productos.join(','),
		dataType: 'jsonp',
		cache: false,
		statusCode: {
			200: function(data) {
				llenar_pulldowns_propiedades(indice, data, ids_productos);
			},
			400: function() {
				alert('Error 400!');
			}
		}
	});
}

function llenar_pulldowns_propiedades(indice, data, ids_productos) {
	for (var i = indice+1; i < pulldowns_ok.length; i++) {
		var campo = pulldowns_ok[i].campo;
		var name = pulldowns_ok[i].name;

		if (campo == 'retailer') {
			jQuery.ajax({
				url: "http://api." + global_hostname + "/retailers/search",
				data: 'products=' + ids_productos.join(',') + '&country=' + country_id ,
				dataType: 'jsonp',
				cache: false,
				statusCode: {
					200: function(data) {
						llenar_pulldown(data, 'retailer', 'Retailer');
					},
					400: function() {
						alert('Error 400!');
					}
				}
			});
			continue;
		}

		var valores = [];

		jQuery.each(data, function(i,v) {
			if (v.descripcion_property == campo && v.value != 'CRT') { // hardcode para Televisores
				valores.push({ id: v.id, value: v.value });
			}
		})

		llenar_pulldown(valores, campo, name);
	}

	if (_auto_start == 1 && typeof _auto_start_eval !== 'undefined') {
		eval(_auto_start_eval);
	}
}

function llenar_pulldown(data, campo, name) {
	var change = 'onChange="set_max_min_date();" ';
	if (campo != 'producto') {
		change = 'onChange="dibujar_pulldown_productos(this);" ';
	}

	var select = generate_select(campo, name, change);

	var props_ordered = data.sort(function(a, b) {
		return ( a.value < b.value ? -1 : (a.value > b.value ? 1 : 0 ) );
	});
	
	for (var i = 0; i < props_ordered.length; i++) {
		if (campo == 'producto' && selected_product == props_ordered[i].id) {
			select.append('<option selected value="' + props_ordered[i].id + '">' + props_ordered[i].value + '</option>');
		} else {
			select.append('<option value="' + props_ordered[i].id + '">' + props_ordered[i].value + '</option>');
		}
	}

	jQuery('#span_' + campo + '_pulldown').html(select);
	jQuery('#' + campo + '_pulldown').chosen();
	jQuery('#' + campo + '_pulldown').bind('change', agregar_tooltips);
}

function generate_select(campo, name, change) {
	return jQuery('<select ' + change + 'name="' + campo + '" id="' + campo + '_pulldown" class="pulldown_selector chzn-select" size="4" multiple  title="' + name + '" data-placeholder="' + name + '"></select>');
}