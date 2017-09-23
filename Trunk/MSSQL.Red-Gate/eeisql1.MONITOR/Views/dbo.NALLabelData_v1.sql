SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[NALLabelData_v1]
as
select
	Serial = o.serial
,	Part = o.part
,	Quantity = o.std_quantity
,	PartDescription = p.name
,	CustomerPart = oh.customer_part
,	CustomerPO = oh.customer_po
,	CompanyAdd1 = p2.address_1
,	CompanyAdd2 = p2.address_2
,	CompanyAdd3 = p2.address_3
,	ShipToName = d.destination
,	ShipToAdd1 = d.address_1
,	ShipToAdd2 = d.address_2
,	ShipToAdd3 = d.address_3
,	SupplierPrefix = 'AAV'
,	SupplierName = 'EMPIRE ELECTRONICS'
,	ShipDate = upper(replace(convert(char(11), getdate(), 106), ' ', ''))
from
	dbo.object o
	join dbo.part p
		on p.part = o.part
	cross apply
		(	select
				LastOrder = max(oh.order_no)
			from
				dbo.order_header oh
			where
				oh.blanket_part = o.part
		) ohLast
	join dbo.order_header oh
		on oh.order_no = ohLast.LastOrder
	join dbo.destination d
		on d.destination = oh.destination
	cross join dbo.parameters p2
GO
