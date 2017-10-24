SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FT].[vwSOD]
(	OrderNo,
	LineID,
	ShipDT,
	Part,
	StdQty )
as
--	Description:
--	Get open sales order details.
select	OrderNO = order_no,
	LineID = ID,
	ShipDT = due_date,
	Part = part_number,
	StdQty = std_qty
from	dbo.order_detail
where	std_qty > 0
GO
