SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_lostfinishedgoods] as
Select	object.serial,
		object.part,
		object.quantity,
		object.location,
		audit_trail.from_loc,
		audit_trail.to_loc,
		isNULL(object.quantity*(CASE WHEN exists( Select 1 from audit_trail at2 where at2.serial = audit_trail.serial and at2.date_stamp< audit_trail.date_stamp) THEN 0 ELSE object.std_cost END),0) as extended_cost,
		audit_trail.date_stamp,
		convert(datetime,(convert(varchar (5), datepart(yy,audit_trail.date_stamp))+'-'+convert(varchar (5), datepart(m,audit_trail.date_stamp))+'-'+'1'))as yearmonthcreatedstring,
		object.last_date,
		audit_trail.type,
		isNULL((CASE WHEN rtrim(audit_trail.field1)=''  and audit_trail.type = 'R' THEN 1 ELSE 0 END),0) as rfreceipt ,
		(Select max((CASE WHEN a2.to_loc like 'TRAN[0-9]%' and a2.type = 'T' and a2.from_loc not like  'TRAN[0-9]%'  THEN 1 ELSE 0 END)) from audit_trail a2 where a2.serial = audit_trail.serial) as transfertoCont,
		audit_trail.operator
from		object
join		audit_trail on object.serial = audit_trail.serial
 where	(object.location like '%Lost%' or object.location like '%FIS%')  and
		object.quantity > 0 and
		(audit_trail.type = 'R' or audit_trail.type = 'B' or audit_trail.type = 'A') and object.part not in (select part from eeiVW_MG)
GO
