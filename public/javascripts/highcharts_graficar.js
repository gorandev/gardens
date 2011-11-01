
var data_graficos = {};
var data_promos_graficos = {};

var promos = {};
var promos_por_producto = {};

function get_promos(id) {
	jQuery.ajax({
		url: "/sales/search",
		data: prices_last_query_string_sent[id],
		cache: false,
		statusCode: {
			200: function(data) {
				data_promos_graficos[id] = data;
				dibujar_data({
					id: id
				});
			},
			400: function() {
				alert('Error 400!');
			}
		}
	});	
}

function dibujar_data(params) {
	var id = params['id'];

	var data = data_graficos[id];
	var data_promos = data_promos_graficos[id];

	var prods = {};
	var lineas = {};
	var lineas_por_fecha = {};
	var retailers = {};

	var id_producto;
	if (params.hasOwnProperty('id_producto')) {
		id_producto = params['id_producto'];
	}

	jQuery.each(data, function(i,v) {
		if (id_producto && v.id_product != id_producto) {
			return;
		}

		if (!retailers.hasOwnProperty(v.retailer)) {
			retailers[v.retailer] = v.retailer_color;
		}

		if (!prods.hasOwnProperty(v.id_product)) {
			prods[v.id_product] = v.name_product;
		}

		if (!lineas.hasOwnProperty(v.id_product)) {
			lineas[v.id_product] = {}
		}

		if (!lineas_por_fecha.hasOwnProperty(v.id_product)) {
			lineas_por_fecha[v.id_product] = {}
		}

		if (!lineas[v.id_product].hasOwnProperty(v.retailer)) {
			lineas[v.id_product][v.retailer] = {};
		}

		var fecha = v.price_date.split('-');
		var fecha_utc = Date.UTC(fecha[0], fecha[1]-1, fecha[2]);

		if (!lineas[v.id_product][v.retailer].hasOwnProperty(fecha_utc)) {
			lineas[v.id_product][v.retailer][fecha_utc] = new Array;
		}

		if (!lineas_por_fecha[v.id_product].hasOwnProperty(fecha_utc)) {
			lineas_por_fecha[v.id_product][fecha_utc] = new Array;
		}

		lineas[v.id_product][v.retailer][fecha_utc].push(v.price);
		lineas_por_fecha[v.id_product][fecha_utc].push(v.price);
	});

	var lineas_promediadas = {};
	var titulo;

	jQuery.each(data_promos, function(i,v) {
		if (!promos.hasOwnProperty(v.id)) {
			promos[v.id] = v;
		}
		if (!promos_por_producto.hasOwnProperty(v.id_product)) {
			promos_por_producto[v.id_product] = {};
		}

		var fecha = v.sale_date.split('-');
		var fecha_utc = Date.UTC(fecha[0], fecha[1]-1, fecha[2]);

		if (!promos_por_producto[v.id_product].hasOwnProperty(fecha_utc)) {
			promos_por_producto[v.id_product][fecha_utc] = new Array;
		}

		promos_por_producto[v.id_product][fecha_utc].push(v.id);
	});

	if (Object.keys(prods).length == 1) {
		jQuery.each(lineas[Object.keys(prods)[0]], function(i,v) {
			lineas_promediadas[i] = new Array;
			jQuery.each(v, function(j,x) {
				var valor_y = x[0];

				if (x.length > 1) {
					var total = 0;
					for (var z = 0; z < x.length; z++) {
						total += x[z];
					}
					valor_y = Math.round(total/(x.length))
				}

				if (
					promos_por_producto.hasOwnProperty(Object.keys(prods)[0]) && 
					promos_por_producto[Object.keys(prods)[0]].hasOwnProperty(j)
				) {
					lineas_promediadas[i].push({
						x: parseInt(j),
						y: valor_y,
						prod: Object.keys(prods)[0],
						fecha: j,	
						marker: {
							enabled: true
						}
					});					
				} else {
					lineas_promediadas[i].push({
						x: parseInt(j),
						y: valor_y
					});
				}
			});
		});

		titulo = prods[Object.keys(prods)[0]];
	}

	if (Object.keys(prods).length > 1) {
		jQuery.each(lineas_por_fecha, function(i,v) {
			lineas_promediadas[prods[i]] = new Array;
			jQuery.each(v, function(j,x) {
				if (x.length > 1) {
					var total = 0;
					for (var z = 0; z < x.length; z++) {
						total += x[z];
					}
					lineas_promediadas[prods[i]].push({
						x: parseInt(j),
						y: Math.round(total/(x.length)),
						id_producto: i
					});
				} else {
					lineas_promediadas[prods[i]].push({
						x: parseInt(j),
						y: x[0],
						id_producto: i
					});
				}
			});
		})

		titulo = 'Varios productos';
	}

	var series = new Array;
	if (titulo == 'Varios productos') {
		jQuery.each(lineas_promediadas, function(i,v) {
			series.push({
			 	name: i,
			 	data: v
			 });
		});
	} else {
		jQuery.each(lineas_promediadas, function(i,v) {
			series.push({
			 	name: i,
			 	color: retailers[i],
			 	data: v
			 });
		});
	}

	var options = {
		chart: {
			renderTo: 'chart_' + id,
			zoomType: 'x'
		},
		title: {
			text: titulo,
			style: {
				fontFamily: 'Verdana',
				fontSize: '12px',
				fontWeight: 'bold'
			}
		},
		xAxis: {
			type: 'datetime'
		},
		yAxis: {
			title: {
				text: 'Precio'
			}
		},
		credits: {
			enabled: false
		},
		tooltip: {
			formatter: function() {
				var tooltip = new String();
				
				tooltip = '<i>' + Highcharts.dateFormat('%A %e %b %Y', this.x) + '</i><br/><br/>';

				this.points.each(function(p){
					if (p.y) {
						tooltip += '<b>' + p.series.name + ':</b> $' + p.y + '<br/>';
					}
				});
				
				return tooltip;
			},
			shared: true
		},

		plotOptions: {
			series: {
				marker: {
					enabled: false
				},
				point: {
					events: {
						click: function() {
							if (this.id_producto) {
								var props = {
									id: id,
									id_producto: this.id_producto
								};
								if (params.hasOwnProperty('no_save_button')) {
									props['no_save_button'] = true;
								}
								dibujar_data(props);
							}
						}
					}
				}
			}	
		},

		series: series,
		
		exporting: {
			buttons: {
				exportButton: {
					menuItems: [ {}, {}, {}, {} ]
				}
			}
		} 
	};

	if (id_producto) {
		if (!params.hasOwnProperty('no_save_button')) {
			options.exporting.buttons.backButton = {
				_titleKey: 'backButtonTitle',
				x: -62,
				symbol: 'square',
				onclick: function() {
					dibujar_data({id: id});
				}
			};
			options.exporting.buttons.exportButton.menuItems.push({
				text: 'Salvar reporte',
				onclick: function() {
					salvar_reporte({id_producto: id_producto});
				}
			});
		} else {
			options.exporting.buttons.backButton = {
				_titleKey: 'backButtonTitle',
				x: -62,
				symbol: 'square',
				onclick: function() {
					dibujar_data({id: id, no_save_button: true});
				}
			};
		}
	} else {
		if (!params.hasOwnProperty('no_save_button')) {
			options.exporting.buttons.exportButton.menuItems.push({
				text: 'Salvar reporte',
				onclick: function() {
					salvar_reporte({});
				}
			});
		}
	}

	var chart = new Highcharts.Chart(options);
}