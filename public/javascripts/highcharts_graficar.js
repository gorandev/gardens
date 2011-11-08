
var data_graficos = {};
var data_promos_graficos = {};

var promos = {};
var promos_por_producto = {};

function get_promos(id) {
	var querystring;
	if (arguments[1]) {
		querystring = arguments[1];
	} else {
		querystring = prices_last_query_string_sent[id];
	}

	var opts = { id: id };
	if (arguments[2]) {
		opts.no_save_button = true;
	}

	jQuery.ajax({
		url: "/sales/search",
		data: querystring,
		cache: false,
		statusCode: {
			200: function(data) {
				data_promos_graficos[id] = data;
				dibujar_data(opts);
			},
			400: function() {
				alert('Error 400!');
			}
		}
	});	
}

var global_prods = {};

function dibujar_data(params) {
	var id = params['id'];

	var data = data_graficos[id];
	var data_promos = data_promos_graficos[id];

	var prods = {};
	var lineas = {};
	var lineas_por_fecha = {};
	var retailers = {};

	var max_value = 0;
	var min_value = 9999999;

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

		if (!global_prods.hasOwnProperty(v.id_product)) {
			global_prods[v.id_product] = v.name_product;
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

		if (v.valid_since && v.valid_until) {

			var fecha_desde = v.valid_since.split('-');
			var fDesde = new Date(fecha_desde[0], fecha_desde[1]-1, fecha_desde[2]);

			var fecha_hasta = v.valid_until.split('-');
			var fHasta = new Date(fecha_hasta[0], fecha_hasta[1]-1, fecha_hasta[2]);

			for (var fecha = fDesde; fecha <= fHasta; fecha.setDate(fecha.getDate()+1)) {
				var fecha_utc = Date.UTC(fecha.getFullYear(), fecha.getMonth(), fecha.getDate());

				if (!promos_por_producto[v.id_product].hasOwnProperty(fecha_utc)) {
					promos_por_producto[v.id_product][fecha_utc] = {};
				}
				promos_por_producto[v.id_product][fecha_utc][v.retailer] = v.id;
			}

		} else {
			var fecha = v.sale_date.split('-');
			var fecha_utc = Date.UTC(fecha[0], fecha[1]-1, fecha[2]);

			if (!promos_por_producto[v.id_product].hasOwnProperty(fecha_utc)) {
				promos_por_producto[v.id_product][fecha_utc] = {};
			}

			promos_por_producto[v.id_product][fecha_utc][v.retailer] = v.id;
		}
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
					!params.hasOwnProperty('no_sales') &&
					promos_por_producto.hasOwnProperty(Object.keys(prods)[0]) && 
					promos_por_producto[Object.keys(prods)[0]].hasOwnProperty(j) &&
					promos_por_producto[Object.keys(prods)[0]][j].hasOwnProperty(i)
				) {
					lineas_promediadas[i].push({
						x: parseInt(j),
						y: promos[promos_por_producto[Object.keys(prods)[0]][j][i]].price,
						producto: Object.keys(prods)[0],
						fecha: j,
						marker: {
							symbol: 'diamond'
						}
					});
					
					if (promos[promos_por_producto[Object.keys(prods)[0]][j][i]].price > max_value) {
						max_value = promos[promos_por_producto[Object.keys(prods)[0]][j][i]].price;
					}

					if (promos[promos_por_producto[Object.keys(prods)[0]][j][i]].price < min_value) {
						min_value = promos[promos_por_producto[Object.keys(prods)[0]][j][i]].price;
					}
				} else {
					lineas_promediadas[i].push({
						x: parseInt(j),
						y: valor_y
					});

					if (valor_y > max_value) {
						max_value = valor_y;
					}

					if (valor_y < min_value) {
						min_value = valor_y;
					}
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
						tooltip += '<b>' + p.series.name + ':</b> $';
						tooltip += Highcharts.numberFormat(p.y, 0, ',', '.');
						tooltip += '<br/>';
					}
				});
				
				return tooltip;
			},
			shared: true
		},

		plotOptions: {
			series: {
				marker: {
					enabled: true,
					symbol: 'url(blank.png)'
				},
				point: {
					events: {
						click: function() {
							if (this.producto && this.fecha) {
								mostrar_promos({
									producto: this.producto,
									fecha: this.fecha
								});
							}

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

	if (Object.keys(prods).length == 1) {
		var subtitulo;

		if (!params.hasOwnProperty('no_sales')) {
			subtitulo = '(con publicaciones)';
		} else {
			subtitulo = '(sin publicaciones)';
		}

		options.subtitle = {
			text: subtitulo,
			style: {
				fontFamily: 'Verdana',
				fontSize: '10px'
			}
		};
	}

	var chart = new Highcharts.Chart(options);
	
	if (Object.keys(prods).length == 1) {
		var opts_dblclick = { id: id };

		if (!params.hasOwnProperty('no_sales')) { opts_dblclick.no_sales = true; }
		if (params.hasOwnProperty('no_save_button')) { opts_dblclick.no_save_button = true; }
		if (id_producto) { opts_dblclick.id_producto = id_producto; }

		jQuery(chart.container).dblclick(function() {
			dibujar_data(opts_dblclick);
		});
	}

	if (typeof mostrar_minimos_y_maximos === 'object') {
		jQuery('#min_precio').html(Highcharts.numberFormat(min_value, 0, ',', '.'));
		jQuery('#max_precio').html(Highcharts.numberFormat(max_value, 0, ',', '.'));
		jQuery('#dif_precio').html(Highcharts.numberFormat((max_value-min_value), 0, ',', '.'));
		jQuery('#avg_precio').html(Highcharts.numberFormat((Math.round((max_value+min_value)/2)), 0, ',', '.'));
	}
}

function mostrar_promos(params) {
	var producto = params['producto'];
	var fecha = params['fecha'];
	var promo = params['promo'];

	if (!producto && !fecha && !promo) {
		return false;
	}

	var prods;
	if (producto && fecha) {
		prods = promos_por_producto[producto][fecha];
	} else {
		prods = { promo: promo };
	}

	var promos_html = new String;

	promos_html += '<table align="center" style="font-size: 14px;" width="100%">';

	jQuery.each(prods, function(i,v) {
		var pr = promos[v];

		promos_html += '<tr>';
		promos_html += '<td>';
		promos_html += '<table align="center">';

		promos_html += '<td align="right"><b>Fuente:</b></td>';
		promos_html += '<td>' + pr.media_channel + '</td>';
		promos_html += '</tr>';

		promos_html += '<tr>';
		promos_html += '<td align="right"><b>Retailer:</b></td>';
		promos_html += '<td>' + pr.retailer + '</td>';
		promos_html += '</tr>';

		promos_html += '<tr>';
		promos_html += '<td align="right"><b>Producto:</b></td>';
		promos_html += '<td>' + global_prods[pr.id_product] + '</td>';
		promos_html += '</tr>';

		promos_html += '<tr>';
		promos_html += '<td align="right"><b>Precio:</b></td>';
		promos_html += '<td>$' + Highcharts.numberFormat(pr.price, 0, ',', '.') + '</td>';
		promos_html += '</tr>';

		promos_html += '<tr>';
		promos_html += '<td align="right"><b>Validez:</b></td>';
		promos_html += '<td>';

		var fecha_desde = pr.valid_since.split('-');
		var fecha_desde_utc = Date.UTC(fecha_desde[0], fecha_desde[1]-1, fecha_desde[2]);

		if (pr.valid_until) {
			var fecha_hasta = pr.valid_until.split('-');
			var fecha_hasta_utc = Date.UTC(fecha_hasta[0], fecha_hasta[1]-1, fecha_hasta[2]);
			promos_html += 'Del ' + Highcharts.dateFormat('%e/%m/%Y', fecha_desde_utc) + ' al ' + Highcharts.dateFormat('%e/%m/%Y', fecha_hasta_utc);
		} else {
			promos_html += Highcharts.dateFormat('%e/%m/%Y', fecha_desde_utc);
		}
		promos_html += '</td>';
		promos_html += '</tr>';

		promos_html += '<tr>';
		promos_html += '<td align="right"><b>Bundle:</b></td>';
		promos_html += '<td>';
		promos_html += ( pr.bundle ? 'S&iacute;' : 'No' );
		promos_html += '</td>';
		promos_html += '</tr>';

		promos_html += '</table>';
		promos_html += '</td>';

		promos_html += '<td align="center">';

		if (pr.currency_id == 1) {
			promos_html += '<a href="http://computadoras.idashboard.com.ar/uploaded_images/promocion-' + pr.imagen_id + '.png" target="verPromo">';
			promos_html += '<img height="500" width="500" class="img_promo" src="http://computadoras.idashboard.com.ar/uploaded_images/promocion-' + pr.imagen_id + '_med.png" border="0"/>';
		} else {
			promos_html += '<a href="http://chile.computadoras.idashboard.com.ar/uploaded_images/promocion-' + pr.imagen_id + '.png" target="verPromo">';
			promos_html += '<img height="500" width="500" class="img_promo" src="http://chile.computadoras.idashboard.com.ar/uploaded_images/promocion-' + pr.imagen_id + '_med.png" border="0"/>';
		}
				
		promos_html += '</a>';
		promos_html += '</td>';

		promos_html += '</tr>';
	});

	promos_html += '</table>';

	Modalbox.show(
		promos_html,
		{
			title: 'Ver promoci&oacute;n',
			width: 800,
			height: 600
		}
	);
}