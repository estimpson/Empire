SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create procedure [dbo].[usp_Label_NAL_Plex_byShipper] ( @ShipperID int)

as Begin
Set nocount on
--exec dbo.usp_Label_NAL_Plex_byShipper 1234567

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NALlabelDataByShipper]') AND type in (N'U'))
DROP TABLE [dbo].[NALlabelDataByShipper]


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
	shipper =  @ShipperID
	and
	 part != 'PALLET'

Declare @LabelData table

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
	ShipDate VARChAR(25)
)	

Insert @LabelData
 
Select 
	blanket_part,
	p.name,
	oh.customer_part,
	oh.customer_po,
	'EMPIRE ELECTRONICS',
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
	shipper_detail sd on sd.order_no = oh.order_no and sd.shipper = @ShipperID
join
	part p on p.part = oh.blanket_part
join
	destination d on d.destination = oh.destination  
join
	edi_setups es on es.destination = d.destination
cross join
	[parameters] parms
	

		
Select *
into
NALlabelDataByShipper
From
	@SerialsToPrint stp
left join
	@LabelData ld on ld.BlanketPart = stp.Part
	
	--Select * From NALLabelDataByShipper


End
GO
