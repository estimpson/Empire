SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FT].[WarehouseInventory]
as
select
	Aisle = substring(object.location, 1, 1)
,	Shelf = case when object.location like '[A-Z]-[1234]-[0-9][0-9]-LST'
					  or object.location like '[A-Z]-[1234]-[0-9][0-9]-FIS'
				 then convert (int, substring(object.location, 3, 1))
			end
,	Subshelf = case	when object.location like '[A-Z]-[1234]-[0-9][0-9]-LST'
						 or object.location like '[A-Z]-[1234]-[0-9][0-9]-FIS'
					then convert (int, substring(object.location, 5, 2))
			   end
,	Address = object.location
,	LocationCode = object.location
,	Serial = object.serial
,	Part = object.part
,	Quantity = object.quantity
,	Type = 'INV'
,	Operator = object.operator
from
	object
where
	(
	 object.location like '[A-Z]-[1234]-[0-9]'
	 or object.location like '[A-Z]-[1234]-[0-9][0-9]'
	)
union all
select
	Aisle = substring(object.location, 1, 1)
,	Shelf = case when object.location like '[A-Z]-[1234]-[0-9][0-9]-LST'
					  or object.location like '[A-Z]-[1234]-[0-9][0-9]-FIS'
				 then convert (int, substring(object.location, 3, 1))
			end
,	Subshelf = case	when object.location like '[A-Z]-[1234]-[0-9][0-9]-LST'
						 or object.location like '[A-Z]-[1234]-[0-9][0-9]-FIS'
					then convert (int, substring(object.location, 5, 2))
			   end
,	Address = substring(object.location, 1, 5)
,	LocationCode = object.location
,	Serial = object.serial
,	Part = object.part
,	Quantity = object.quantity
,	Type = substring(object.location, 7, 4)
,	Operator = object.operator
from
	object
where
	(
	 object.location like '[A-Z]-[1234]-[0-9]-LST'
	 or object.location like '[A-Z]-[1234]-[0-9]-FIS'
	)
union all
select
	Aisle = substring(object.location, 1, 1)
,	Shelf = case when object.location like '[A-Z]-[1234]-[0-9][0-9]-LST'
					  or object.location like '[A-Z]-[1234]-[0-9][0-9]-FIS'
				 then convert (int, substring(object.location, 3, 1))
			end
,	Subshelf = case	when object.location like '[A-Z]-[1234]-[0-9][0-9]-LST'
						 or object.location like '[A-Z]-[1234]-[0-9][0-9]-FIS'
					then convert (int, substring(object.location, 5, 2))
			   end
,	Address = substring(object.location, 1, 6)
,	LocationCode = object.location
,	Serial = object.serial
,	Part = object.part
,	Quantity = object.quantity
,	Type = substring(object.location, 8, 4)
,	Operator = object.operator
from
	object
where
	(
	 object.location like '[A-Z]-[1234]-[0-9][0-9]-LST'
	 or object.location like '[A-Z]-[1234]-[0-9][0-9]-FIS'
	)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [FT].[trWarehouseInventroy_iU] on [FT].[WarehouseInventory]
instead of update
as
--	Declarations:
declare	@TranType char (1),
	@Remark varchar (10),
	@Notes varchar (50)

set	@TranType = 'G'
set	@Remark = 'Begin Phys'
set	@Notes = 'Begin a physical inventory.'

--	I.	Update objects.
update	object
set	last_date = GetDate (),
	operator = inserted.Operator,
	last_time = GetDate (),
	location = inserted.LocationCode
from	object
	join inserted on object.serial = inserted.Serial

--	II.	Insert audit trail.
insert	audit_trail
(	serial,
	date_stamp,
	type,
	part,
	quantity,
	remarks,
	operator,
	from_loc,
	to_loc,
	parent_serial,
	lot,
	weight,
	status,
	shipper,
	unit,
	std_quantity,
	plant,
	notes,
	package_type,
	std_cost,
	user_defined_status,
	tare_weight )
select	object.serial,
	object.last_date,
	@TranType,
	object.part,
	object.quantity,
	@Remark,
	object.operator,
	deleted.LocationCode,
	object.location,
	object.parent_serial,
	object.lot,
	object.weight,
	object.status,
	object.shipper,
	object.unit_measure,
	object.std_quantity,
	object.plant,
	@Notes,
	object.package_type,
	object.cost,
	object.user_defined_status,
	object.tare_weight
from	inserted
	join deleted on inserted.Serial = deleted.Serial
	join object on inserted.Serial = object.serial
GO
