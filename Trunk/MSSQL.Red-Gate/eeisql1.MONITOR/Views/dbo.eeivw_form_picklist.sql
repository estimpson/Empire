SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--select * from eeivw_form_picklist where shipper_id =  86135


CREATE VIEW [dbo].[eeivw_form_picklist]
AS
SELECT
	shipper_id = s.id
,	parameters_company_name = p2.company_name
,	shipper_destination = s.destination
,	destination_name = d.name
,	shipper_ship_via = s.ship_via
,	shipper_date_stamp = s.date_stamp
,	shipper_scheduled_ship_time = s.scheduled_ship_time
,	shipper_notes = s.notes
,	shipper_detail_customer_part = sd.customer_part
,	shipper_detail_part = sd.part
,	shipper_detail_part_original = sd.part_original
,	PartClass = p.class
,	shipper_detail_qty_required = sd.qty_required
,	std_pack = COALESCE(ft.fn_InventoryStdPack(p.part),NULLIF(oh.standard_pack, 0), pi.standard_pack)
,	pull_qty = dbo.fn_GreaterOf(CEILING(qty_required / COALESCE(ft.fn_InventoryStdPack(p.part),NULLIF(oh.standard_pack, 1), pi.standard_pack) * COALESCE(ft.fn_InventoryStdPack(p.part),NULLIF(oh.standard_pack, 1), pi.standard_pack)),COALESCE(ft.fn_InventoryStdPack(p.part),NULLIF(oh.standard_pack, 0), pi.standard_pack))
,	part_inventory_primary_location = pi.primary_location
,	part_online_on_hand = po.on_hand
,	shipper_detail_qty_original = sd.qty_original
,	shipper_detail_qty_packed = sd.qty_packed
,	shipper_detail_note = sd.note
,	partonlineonhand = po.on_hand
,	app_qty = 
		(	SELECT
				SUM(o2.quantity)
			FROM
				object o2
			WHERE
				o2.part = sd.part_original
				AND o2.status = 'A'
				AND o2.location NOT LIKE '%ELPASO%'
				AND o2.location NOT LIKE '%LOST%'
				AND o2.location NOT LIKE '%SCRAP%'
				AND o2.location NOT LIKE '%EEI%STAGE%'
				AND o2.location NOT LIKE '%recv%insp%'
				AND o2.location NOT LIKE '%rtv%pallet%'
		)
,	non_app_qty =
		(	SELECT
				SUM(o2.quantity)
			FROM
				object o2
			WHERE
				o2.part = sd.part_original
				AND o2.status <> 'A'
				AND o2.location NOT LIKE '%ELPASO%'
				AND o2.location NOT LIKE '%LOST%'
				AND o2.location NOT LIKE '%SCRAP%'
				AND o2.location NOT LIKE '%EEI%STAGE%'
				AND o2.location NOT LIKE '%recv%insp%'
				AND o2.location NOT LIKE '%rtv%pallet%'
		)
,	Accum = COALESCE
		(	(	SELECT
					SUM(O2.quantity)
				FROM
					object O2
				WHERE
					O2.part = o.part
					AND CASE WHEN o2.location LIKE '%TRAN%' THEN (o2.serial)*10 ELSE o2.serial END < CASE WHEN o.location LIKE '%TRAN%' THEN (o.serial)*10 ELSE o.serial END
				AND o2.location NOT LIKE '%ELPASO%'
				AND o2.location NOT LIKE '%LOST%'
				AND o2.location NOT LIKE '%SCRAP%'
				AND o2.location NOT LIKE '%EEI%STAGE%'
				AND o2.location NOT LIKE '%recv%insp%'
				AND o2.location NOT LIKE '%rtv%pallet%'
			)
		,	0
		) + quantity
,	serial
,	object_location = o.location
,	relative_object_location = CASE WHEN o.location LIKE '%TRAN%' THEN 'ZZ'+ o.location ELSE o.location END
,	object_status = o.status
,	ITNumber = o.custom4
,	object_parent_serial = o.parent_serial
,	order_header_zone_code = oh.zone_code
,	order_header_dock_code = oh.dock_code
,	order_header_package_type = oh.package_type
,	order_header_line_feed_code = oh.line_feed_code
,	additional_notes = da1.field_desc3
FROM
	dbo.shipper s
	JOIN dbo.shipper_detail sd
		ON sd.shipper = s.id
	LEFT JOIN dbo.order_header oh
		ON oh.customer = s.customer
			AND oh.order_no = sd.order_no
	JOIN dbo.part_inventory pi
		ON sd.part = pi.part
	JOIN dbo.part_online po
		ON po.part = sd.part
	LEFT JOIN dbo.destination d
		ON s.destination = d.destination
	LEFT JOIN dbo.destination_a1 da1
		ON s.destination = da1.destination
	LEFT JOIN dbo.object o
		ON	o.part = sd.part_original
			AND o.location NOT LIKE '%ELPASO%'
			AND o.location NOT LIKE '%LOST%'
			AND o.location NOT LIKE '%SCRAP%'
			AND o.location NOT LIKE '%EEI%STAGE%'
			AND o.location NOT LIKE '%recv%insp%'
			AND o.location NOT LIKE '%rtv%pallet%'
	JOIN dbo.part p
		ON p.part = sd.part
	CROSS JOIN dbo.parameters p2
WHERE
	s.status IN ('O', 'S')
	AND COALESCE(s.type, 'N') = 'N' AND
	NULLIF(o.shipper,0) IS NULL -- and s.id = 88136






GO
