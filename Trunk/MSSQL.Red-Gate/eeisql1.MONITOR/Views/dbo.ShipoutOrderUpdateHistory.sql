SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[ShipoutOrderUpdateHistory]
as
select
	spoc.Shipper
,	spoc.OrderNo
,	spoc.PriorOrderQtyChecksum
,	spoc.ShipQtyChecksum
,	spoc.PriorOrderDetailXML
,	spoc2.PostOrderQtyChecksum
,	ExpectedPostOrderQtyChecksum = spoc.PriorOrderQtyChecksum - spoc.ShipQtyChecksum
,	spoc2.PostOrderDetailXML
from
	dbo.ShipperPriorOrderChecksum spoc
	join dbo.ShipperPostOrderChecksum spoc2
		on spoc2.Shipper = spoc.Shipper
		and spoc2.OrderNo = spoc.OrderNo
GO
