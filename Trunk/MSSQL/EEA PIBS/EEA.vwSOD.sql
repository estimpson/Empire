
if	objectproperty(object_id('EEA.vwSOD'), 'IsView') = 1 begin
	drop view EEA.vwSOD
end
go

create view EEA.vwSOD
as
--	Description:
--	Get open sales order details.
select	OrderNO = order_no
,	LineID = id
,	ShipDT = due_date
,	Part = part_number
,	StdQty = std_qty
from
	dbo.order_detail od
where
	std_qty > 0
go

