SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure	[dbo].[eeisp_rpt_OHD_AuditTrail] (@part varchar (25), @FromDate datetime, @ThroughDate datetime)
as
Select	sum(quantity),
		sum(std_quantity),
		time_stamp,
		part
from		object_historical_daily
where	part = @part and
		time_stamp>=@FromDate and
		time_stamp<@throughDate
group	by time_stamp,
		part
Select sum(quantity),
		sum(std_quantity),
		type,
		part
from		audit_trail
where	part = @part and
		date_stamp>= @FromDate and
		date_stamp<@throughDate
group by type,
		part
	
GO
