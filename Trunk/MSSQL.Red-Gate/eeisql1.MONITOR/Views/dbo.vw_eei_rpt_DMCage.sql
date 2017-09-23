SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_rpt_DMCage] as
select	audit_trail.serial, audit_trail.date_stamp, audit_trail.part, object.quantity, audit_trail.notes, audit_trail.operator, audit_trail.from_loc, audit_trail.to_loc,object.cost, (object.quantity*object.cost) as extendedcost
from	object
	join audit_trail on object.serial = audit_trail.serial and
		audit_trail.type = 'T' and
		audit_trail.date_stamp =
		(	select	min (date_stamp)
			from	audit_trail
			where	object.serial = serial and
				type = 'T' and
				to_loc = 'DMCAGE')
where	location = 'DMCAGE' and
		audit_trail.date_stamp <= dateadd (day, -15, getdate()) and object.part not in (select part from eeiVW_MG)
GO
