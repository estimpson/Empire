SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FT].[EEIReceiveAccum]
as
select	BasePart = left (part.part, 7),
	CurrentAccum = IsNull (Sum (ShipLog.Quantity), 0)
from	part
	left join FT.CommonSerialShipLog ShipLog on part.part = ShipLog.Part and
		ShipLog.ShipDT >= '2007-06-01'
where	type = 'F'
group by
	left (part.part, 7)
GO
