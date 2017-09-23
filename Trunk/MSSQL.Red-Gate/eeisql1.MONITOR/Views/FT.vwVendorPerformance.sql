SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwVendorPerformance]
as
select	PONumber,
	Part,
	WeekNo,
	AccumOrdered,
	OrderedReleasePlanID,
	AuthorizedAccum,
	AuthorizedReleasePlanID,
	ReceivedAccum,
	LastReceivedDT,
	OnTime = ( case when ReceivedAccum >= AccumOrdered or ReceivedAccum >= AuthorizedAccum then 1 else 0 end )
from	FT.ReceivingHistory
GO
