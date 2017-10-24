SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Select * from [dbo].[fn_LabelNALPlex]()
CREATE FUNCTION [dbo].[fn_LabelNALPlex]
()
RETURNS @LabelData TABLE
(	Serial int unique,
	Part  varchar(50),
	Quantity int,
	BlanketPart varchar(50),
	PartDescription varchar(125),
	CustomerPart varchar(50),
	CustomerPO varchar(50),
	SupplierName varchar(50),
	CompanyAdd1 varchar(50),
	CompanyAdd2 varchar(50),
	CompanyAdd3 varchar(50),
	SupplierPrefix varchar(5),
	ShipToName varchar(50),
	ShipToAdd1 varchar(75),
	ShipToAdd2 varchar(75),
	ShipToAdd3 varchar(75),
	ShipDate datetime
)
AS
BEGIN
Declare @SerialsToPrint table
 (	Serial int unique,
	Part  varchar(50),
	Quantity int )

Insert @SerialsToPrint
Select	Serial,
			part,
			Quantity
From
	object
where
	
	 part != 'PALLET'

Declare @LabelDataa table

(	BlanketPart varchar(50),
	PartDescription varchar(125),
	CustomerPart varchar(50),
	CustomerPO varchar(50),
	SupplierName varchar(50),
	CompanyAdd1 varchar(50),
	CompanyAdd2 varchar(50),
	CompanyAdd3 varchar(50),
	SupplierPrefix varchar(5),
	ShipToName varchar(50),
	ShipToAdd1 varchar(75),
	ShipToAdd2 varchar(75),
	ShipToAdd3 varchar(75),
	ShipDate datetime
)	

Insert @LabelDataa
 
Select 
	blanket_part,
	p.name,
	oh.customer_part,
	oh.customer_po,
	parms.company_name,
	parms.address_1,
	parms.address_2,
	parms.address_3,
	'AAV',
	d.name,
	d.address_1,
	d.address_2,
	d.address_3,
	UPPER(Replace(CONVERT(varchar(15), GETDATE(), 106), ' ', '' ))
	
	
 From
	order_header oh
join
	part p on p.part = oh.blanket_part
join
	destination d on d.destination = oh.destination  
join
	edi_setups es on es.destination = d.destination
cross join
	[parameters] parms
cross apply
	( Select 
		MAX(order_no) LastOrder
		From
			order_header oh2
		where
			oh2.Blanket_part = oh.blanket_part  ) LastOrders
			
	Where
		LastOrder = oh.order_no


Insert @LabelData		
Select *
From
	@SerialsToPrint stp
left join
	@LabelDataa ld on ld.BlanketPart = stp.Part

--- </Body>

---	<Return>
	RETURN
END



























GO
