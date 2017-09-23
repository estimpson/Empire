SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_AutoApproveSerials_fxDelete]

as

Begin
	


Create	table #serials(
								serial			Integer,
								transcount	Integer)
								
								
Insert	#serials
Select	serial,
				isNULL((select 	isNULL(count(1),99) 
					from 		audit_trail 
					where 	audit_trail.serial = object.serial and
									audit_trail.type not in ('J','T')),0) as trans_post_jc
								
from		object
where		object.status = 'H' and
				part like 'POT%' and
				last_date <= dateadd(hh,-12,getdate())
				
				

-- Modifycation requested by Luis Leonar (EEH) at Jul-07-2006, they need the same as potting the different are 
--    1. This are just 2 Parts EEM0001 AND EEM002
--    2. The time must be 72  hours
Insert	#serials
SELECT     serial, ISNULL
                          ((SELECT     isNULL(COUNT(1), 99)
                              FROM         audit_trail
                              WHERE     audit_trail.serial = object.serial AND audit_trail.type NOT IN ('J', 'T')), 0) AS trans_post_jc
FROM         dbo.object
WHERE     (status = 'H') AND (part = 'EEM0001-WC00-BLK' OR
                      part = 'EEM0002-WC00-GRY') AND (last_date <= DATEADD(hh, - 72, GETDATE()))


Delete	AutoQCApprovedSerials



Insert	AutoQCApprovedSerials
Select	serial
From	#serials
where	transcount<1




insert	audit_trail
	(	serial,
		date_stamp,
		type,
		part,
		quantity,
		remarks,
		price,
		vendor,
		po_number,
		operator,
		from_loc,
		to_loc,
		on_hand,
		lot,
		weight,
		status,
		shipper,
		unit,
		std_quantity,
		cost,
		control_number,
		custom1,
		custom2,
		custom3,
		custom4,
		custom5,
		plant,
		notes,
		gl_account,
		package_type,
		release_no,
		std_cost,
		user_defined_status,
		part_name,
		tare_weight )
	select	object.serial,
		GetDate ( ),
		'Q',
		object.part,
		object.quantity,
		'Quality',
		0,
		NULL,
		object.po_number,
		object.operator,
		'H',
		'A',
		IsNull ( part_online.on_hand, 0 ) + object.std_quantity,
		object.lot,
		IsNull ( object.weight, part_inventory.unit_weight * object.quantity ),
		'A',
		object.shipper,
		object.unit_measure,
		object.std_quantity,
		object.cost,
		convert(varchar (20),getdate(), 109),
		null, --@Custom1,
		null, --@Custom2,
		null, --@Custom3,
		null, --@Custom4,
		null, --@Custom5,
		object.plant,
		'Set to approved by eeisp_AutoApproveSerials', --@Note,
		isNULL(destination.gl_segment, 'NO'),
		object.package_type, --@PackageType,
		NULL,
		object.std_cost,
		'Approved',
		object.name,
		object.tare_weight
	from	object
	left outer join destination on object.plant = destination.destination
	join	part_online on object.part = part_online.part
	join	part_inventory on object.part = part_inventory.part
	join	#serials on object.serial = #serials.serial

	

	Update	object
	set			status = 'A',
					User_defined_status = 'Approved'
	where		serial in (select serial from #serials)
	

	
	
	
End
GO
