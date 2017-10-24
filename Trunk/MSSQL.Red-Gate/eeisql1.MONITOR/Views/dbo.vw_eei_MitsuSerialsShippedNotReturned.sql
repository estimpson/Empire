SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_MitsuSerialsShippedNotReturned]
as
Select 	object.Serial, 
		object.part,
		object.quantity,
		object.station,
		object.shipper 
from	object
where	object.part like 'MIT0005-H%' 
		and not exists(select 1 from audit_trail at2 where at2.type = 'U' and at2.serial = object.serial)
GO
