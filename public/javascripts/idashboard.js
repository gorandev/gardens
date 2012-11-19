
function mostrar_promo(fecha, retailer, producto) {
	var fechahoy = new Date;

	Modalbox.show(
		'/dashboard/ajax_mostrar_promo?fecha=' + fecha
		+ '&retailer=' + retailer
		+ '&producto=' + producto
		+ '&r=' + fechahoy.getMilliseconds(),
		{
			title: 'Ver promoci&oacute;n',
			width: 800,
			height: 600
		}
	);
}

function mostrar_promo_por_id(promo_id) {
	var fecha = new Date;
	Modalbox.show(
		'/dashboard/ajax_mostrar_promo_por_id?id_promo=' + promo_id + '&r=' + fecha.getMilliseconds(),
		{
			title: 'Ver promoci&oacute;n',
			width: 800,
			height: 600
		}
	);
}

function mostrar_promo_por_producto(fecha, producto) {
	var fechahoy = new Date;
	Modalbox.show(
		'/dashboard/ajax_mostrar_promo_por_producto?fecha=' + fecha
		+ '&producto=' + producto
		+ '&r=' + fechahoy.getMilliseconds(),
		{
			title: 'Ver promoci&oacute;n',
			width: 800,
			height: 600
		}
	);
}
