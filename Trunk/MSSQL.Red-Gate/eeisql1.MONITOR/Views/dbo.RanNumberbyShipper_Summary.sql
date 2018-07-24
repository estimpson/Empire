SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[RanNumberbyShipper_Summary]
as 
Select RanNumber, Shipper, orderno, SUM(Qty) as RAN_Quantity  from NALRanNumbersShipped  group by rannumber,Shipper,orderno

GO
