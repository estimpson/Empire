SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[eeisp_set_posted_for_unposted_serial] (@fromdate datetime, @throughdate datetime, @serial int, @type char(1) )
as
Begin

Update	audit_trail
set		posted = 'N'
where	Serial = @serial and
		type = @type and
		date_stamp>= @fromdate and
		date_stamp<= @throughdate  

Select	distinct	convert(varchar(25), date_stamp, 111), audit_trail.part, serial, material_cum
from		audit_trail
join		part_standard on audit_trail.part = part_standard.part
where	Serial = @serial and
		type = @type and
		date_stamp>= @fromdate and
		date_stamp<= @throughdate  
end
GO
