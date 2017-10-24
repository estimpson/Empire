SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwCommonSerial_POReceipts]
as
select	Origin,
	Destination,
	PONumber,
	TotQuantity = sum (Quantity)
from	FT.vwCommonSerial_ShipLogInProcess
group by
	Origin,
	Destination,
	PONumber
GO
