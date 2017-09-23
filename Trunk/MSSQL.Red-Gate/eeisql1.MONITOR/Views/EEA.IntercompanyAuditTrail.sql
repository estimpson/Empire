SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[IntercompanyAuditTrail]
as
select
	ID = atFrom.id
,	Serial = atFrom.serial
,	TranDT = atFrom.date_stamp
,	Part = atFrom.part
,	PartIntercompany = atTo.part
,	TranCode = atFrom.remarks
,	Operator = atFrom.operator
,	Location = atFrom.from_loc
,	Lot = atFrom.lot
,	MaterialWeight = atFrom.weight
,	WOID = atFrom.workorder
,	QtyTransfer = atFrom.std_quantity
,	UnitCost = atFrom.cost
,	Plant = atFrom.plant
,	Notes = atFrom.notes
,	BFID = atFrom.group_no
,	MaterialStatus = atFrom.status
,	MaterialStatusFull = atFrom.user_defined_status
,	FromProductLine = pFrom.product_line
,	ToProductLine = pTo.product_line
,	FromCompany = plFrom.gl_segment
,	ToCompany = plTo.gl_segment
,	Posted = atFrom.posted
from
	dbo.audit_trail atFrom
		join dbo.part pFrom
			join dbo.product_line plFrom
				on plFrom.id = pFrom.product_line
			on pFrom.part = atFrom.part
	join dbo.audit_trail atTo
		join dbo.part pTo
			join dbo.product_line plTo
				on plTo.id = pTo.product_line
			on pTo.part = atTo.part
		on atTo.serial = atFrom.serial
		and atTo.date_stamp = atFrom.date_stamp
		and atTo.type in ('I2')
where
	atFrom.type in ('I1')
	and
		atFrom.date_stamp > '2011-02-21'
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE trigger [EEA].[trIntercompanyAuditTrail_iud] on [EEA].[IntercompanyAuditTrail] instead of insert, update, delete
as
/*
Inserts:
Records being inserted must specify the serial, transaction datetime, operator, quantity, work order id,
plant, and "to product line".  Notes are optional.  All other values come from the work order, object,
and part definition(s).

Updates:
Updates of this view are not handled.

Deletes:
Deletes from this view will delete both intercompany records.
*/

/*
Create new part numbers (if needed) for intercompany transactions.  Give exception if there are
conflicts with duplicate parts.
*/
if	exists
	(	select
			left(i.part, 24 - len(pl.gl_segment))
		,	count(distinct p.part)
		from
			inserted i
			join dbo.product_line pl
				on pl.id = i.ToProductLine
			join dbo.part p
				on p.part like left(i.part, 24 - len(pl.gl_segment)) + '%'
				and p.part != left(i.Part, 24 - len(pl.gl_segment)) + '~' + pl.gl_segment
		group by
			left(i.part, 24 - len(pl.gl_segment))
		having
			count(distinct p.part) > 1
	) begin
	
	raiserror('Intercompany part number not distinct.', 16, 1)
	rollback
	return
end

insert
	dbo.part
(	part
,	name
,	class
,	type
,	commodity
,	quality_alert
,	serial_type
,	product_line
)
select
	part = left(i.Part, 24 - len(plTo.gl_segment)) + '~' + plTo.gl_segment
,	name = 'Intercompany - do not use'
,	class = 'I'
,	type = MIN(pFrom.type)
,	commodity = pFrom.commodity
,	quality_alert = 'N'
,	serial_type = 'I'
,	product_line = i.ToProductLine
from
	inserted i
	join dbo.part pFrom
		on pFrom.part = i.Part
	join dbo.product_line plTo
		on plTo.id = i.ToProductLine
	left join dbo.part pTo
		on pTo.part = left(i.Part, 24 - len(plTo.gl_segment)) + '~' + plTo.gl_segment
where
	pTo.part is null
group by
	left(i.Part, 24 - len(plTo.gl_segment)) + '~' + plTo.gl_segment
,	pFrom.commodity
,	i.ToProductLine

delete
	psTo
from
	inserted i
	join dbo.part_standard psFrom
		on psFrom.part = i.Part
	join dbo.product_line plTo
		on plTo.id = i.ToProductLine
	join dbo.part_standard psTo
		on psTo.part = left(i.Part, 24 - len(plTo.gl_segment)) + '~' + plTo.gl_segment

insert
	dbo.part_standard
(	part
,	cost
,	material
,	labor
,	burden
,	other
,	cost_cum
,	material_cum
,	burden_cum
,	other_cum
,	labor_cum
,	flag
,	frozen_material_cum
,	cost_changed_date
)
select
	part = left(i.Part, 24 - len(plTo.gl_segment)) + '~' + plTo.gl_segment
,	cost = psFrom.cost
,	material = psFrom.material
,	labor = psFrom.labor
,	burden = psFrom.burden
,	other = psFrom.other
,	cost_cum = psFrom.cost_cum
,	material_cum = psFrom.material_cum
,	burden_cum = psFrom.burden_cum
,	other_cum = psFrom.other_cum
,	labor_cum = psFrom.labor_cum
,	flag = psFrom.flag
,	frozen_material_cum = psFrom.frozen_material_cum
,	cost_changed_date = psFrom.cost_changed_date
from
	inserted i
	join dbo.part_standard psFrom
		on psFrom.part = i.Part
	join dbo.product_line plTo
		on plTo.id = i.ToProductLine
	left join dbo.part_standard psTo
		on psTo.part = left(i.Part, 24 - len(plTo.gl_segment)) + '~' + plTo.gl_segment
where
	psTo.part is null
group by
	left(i.Part, 24 - len(plTo.gl_segment)) + '~' + plTo.gl_segment
,	psFrom.cost
,	psFrom.material
,	psFrom.labor
,	psFrom.burden
,	psFrom.other
,	psFrom.cost_cum
,	psFrom.material_cum
,	psFrom.burden_cum
,	psFrom.other_cum
,	psFrom.labor_cum
,	psFrom.flag
,	psFrom.frozen_material_cum
,	psFrom.cost_changed_date

insert
	dbo.part_inventory
(	part
,	standard_pack
,	unit_weight
,	standard_unit
,	primary_location
,	label_format
,	material_issue_type
)
select
	part = left(i.Part, 24 - len(plTo.gl_segment)) + '~' + plTo.gl_segment
,	standard_pack = piFrom.standard_pack
,	unit_weight = piFrom.unit_weight
,	standard_unit = piFrom.standard_unit
,	primary_location = piFrom.primary_location
,	label_format = piFrom.label_format
,	material_issue_type = piFrom.material_issue_type
from
	inserted i
	join dbo.part_inventory piFrom
		on piFrom.part = i.Part
	join dbo.product_line plTo
		on plTo.id = i.ToProductLine
	left join dbo.part_inventory piTo
		on piTo.part = left(i.Part, 24 - len(plTo.gl_segment)) + '~' + plTo.gl_segment
where
	piTo.part is null
group by
	left(i.Part, 24 - len(plTo.gl_segment)) + '~' + plTo.gl_segment
,	piFrom.standard_pack
,	piFrom.unit_weight
,	piFrom.standard_unit
,	piFrom.primary_location
,	piFrom.label_format
,	piFrom.material_issue_type
	
/*
Create new audit trail records for the intercompany transactions.
*/
insert
	dbo.audit_trail
(	serial, date_stamp, type, part, quantity, remarks
,	po_number, operator, from_loc, to_loc, on_hand, lot
,	weight, status, shipper, unit, workorder, std_quantity
,	cost, custom1, custom2, custom3, custom4, custom5
,	plant, notes, package_type, suffix, due_date, std_cost
,	user_defined_status, engineering_level, parent_serial
,	origin, destination, sequence, object_type, part_name
,	group_no, start_date, field1, field2, show_on_shipper
)
select
	serial = i.Serial, date_stamp = i.TranDT, type = 'I1', part = p.part, quantity = -i.QtyTransfer, remarks = 'IntercoFrm'
,	po_number = o.po_number, operator = i.Operator, from_loc = left(p.product_line, 10), to_loc = left(i.ToProductLine, 10), on_hand = po.on_hand, lot = o.lot
,	weight = pi.unit_weight * i.QtyTransfer, status = o.status, shipper = o.shipper, unit = pi.standard_unit, workorder = i.WOID, std_quantity = -i.QtyTransfer
,	cost = ps.cost_cum, custom1 = o.custom1, custom2 = o.custom2, custom3 = o.custom3, custom4 = o.custom4, custom5 = o.custom5
,	plant = i.Plant, notes = i.Notes, package_type = o.package_type, suffix = o.suffix, due_date = o.date_due, std_cost = ps.cost_cum
,	user_defined_status = o.user_defined_status, engineering_level = o.engineering_level, parent_serial = o.parent_serial
,	origin = o.origin, destination = o.destination, sequence = o.sequence, object_type = o.type, part_name = p.name
,	group_no = i.BFID, start_date = o.start_date, field1 = o.field1, field2 = o.field2, show_on_shipper = o.show_on_shipper
from
	inserted i
	join dbo.object o
		on o.serial = i.Serial
	join dbo.part p
		on p.part = i.Part
	join dbo.part_inventory pi
		on pi.part = p.part
	join dbo.part_standard ps
		on ps.part = p.part
	left join dbo.part_online po
		on po.part = p.part

insert
	dbo.audit_trail
(	serial, date_stamp, type, part, quantity, remarks
,	po_number, operator, from_loc, to_loc, on_hand, lot
,	weight, status, shipper, unit, workorder, std_quantity
,	cost, custom1, custom2, custom3, custom4, custom5
,	plant, notes, package_type, suffix, due_date, std_cost
,	user_defined_status, engineering_level, parent_serial
,	origin, destination, sequence, object_type, part_name
,	group_no, start_date, field1, field2, show_on_shipper
)
select
	serial = i.Serial, date_stamp = i.TranDT, type = 'I2', part = p.part, quantity = i.QtyTransfer, remarks = 'IntercoTo'
,	po_number = o.po_number, operator = i.Operator, from_loc = left(pFrom.product_line, 10), to_loc = left(i.ToProductLine, 10), on_hand = i.QtyTransfer, lot = o.lot
,	weight = pi.unit_weight * i.QtyTransfer, status = o.status, shipper = o.shipper, unit = pi.standard_unit, workorder = i.WOID, std_quantity = i.QtyTransfer
,	cost = ps.cost_cum, custom1 = o.custom1, custom2 = o.custom2, custom3 = o.custom3, custom4 = o.custom4, custom5 = o.custom5
,	plant = i.Plant, notes = i.Notes, package_type = o.package_type, suffix = o.suffix, due_date = o.date_due, std_cost = ps.cost_cum
,	user_defined_status = o.user_defined_status, engineering_level = o.engineering_level, parent_serial = o.parent_serial
,	origin = o.origin, destination = o.destination, sequence = o.sequence, object_type = o.type, part_name = p.name
,	group_no = i.BFID, start_date = o.start_date, field1 = o.field1, field2 = o.field2, show_on_shipper = o.show_on_shipper
from
	inserted i
		join dbo.part pFrom
			on pFrom.part = i.Part
	join dbo.product_line plTo
		on plTo.id = i.ToProductLine
	join dbo.object o
		on o.serial = i.Serial
	join dbo.part p
		on p.part = left(i.Part, 24 - len(plTo.gl_segment)) + '~' + plTo.gl_segment
	join dbo.part_inventory pi
		on pi.part = p.part
	join dbo.part_standard ps
		on ps.part = p.part
	left join dbo.part_online po
		on po.part = p.part
GO
