SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[eeivw_RANHistory]
as
select
	ShipDT = s.date_shipped, nrns.OrderNo
	,   ReleaseDT = nrns.ShipDate
	,   nrns.Qty
	,   nrns.RanNumber
	,   nrns.Shipper
from
	dbo.NALRanNumbersShipped nrns
	join dbo.shipper s
		on s.id = nrns.Shipper
GO
