
var data_graficos = {};

function dibujar_data(params) {
	var id = params['id'];

	var data = data_graficos[id];

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

	if (Object.keys(prods).length == 1) {
		jQuery.each(lineas[Object.keys(prods)[0]], function(i,v) {
			lineas_promediadas[i] = new Array;
			jQuery.each(v, function(j,x) {
				if (x.length > 1) {
					var total = 0;
					for (var z = 0; z < x.length; z++) {
						total += x[z];
					}
					lineas_promediadas[i].push([parseInt(j), Math.round(total/(x.length))]);
				} else {
					lineas_promediadas[i].push([parseInt(j), x[0]]);
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
								dibujar_data({
									id: id,
									id_producto: this.id_producto
								});
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
		options.exporting.buttons.backButton = {
			_titleKey: 'backButtonTitle',
			x: -62,
			symbol: 'square',
			onclick: function() {
				dibujar_data({id: id});
			}
		};

		if (!params.hasOwnProperty('no_save_button')) {
			options.exporting.buttons.exportButton.menuItems.push({
				text: 'Salvar reporte',
				onclick: function() {
					salvar_reporte({id_producto: id_producto});
				}
			});
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