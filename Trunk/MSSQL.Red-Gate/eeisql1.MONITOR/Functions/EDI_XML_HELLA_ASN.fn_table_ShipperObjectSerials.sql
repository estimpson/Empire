SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE function [EDI_XML_HELLA_ASN].[fn_table_ShipperObjectSerials]
(	@ShipperID int
,	@CustomerPart varchar(30)
,	@packType varchar(25)
,	@PackQty varchar(25)
)
returns @AuditTrailPartPackGroupSerialRange table (
ShipperID int,
Part varchar(25),
PackageType varchar(35),
PartPackQty int,
SerialRange varchar(50), primary key (SerialRange))
as
begin
--- <Body>

	declare	@AuditTrailLooseSerial table (
Part varchar(25),
PackageType varchar(35),
PartPackCount int,
SerialQuantity int,
ParentSerial int,
Serial int, 
id int identity primary key (id))
	
insert	@AuditTrailLooseSerial 
(	Part,
	PackageType,
	PartPackCount,
	SerialQuantity,
	ParentSerial,
	Serial 
)
	
select
	customer_part,
	coalesce(nullif(at.package_type,''),'XXX.XXX-XX') ,
	1,
	quantity,
	0,
	serial
from
	dbo.audit_trail at
join
	shipper_detail sd on sd.shipper = @ShipperID and
	sd.part_original = at.part
left join
	dbo.package_materials pm on pm.code = at.package_type
Where
	at.shipper = convert(varchar(15), @shipperID) and
	at.type = 'S' and
	at.part != 'Pallet'
order by serial	

declare	@AuditTrailPartPackGroup table (
Part varchar(25),
PackageType varchar(35),
PartPackQty int, 
PartPackCount int, primary key (Part, PackageType, PartPackQty))


insert	@AuditTrailPartPackGroup
(	Part,
	PackageType,
	PartPackQty,
	PartPackCount
)

Select 
	part,
	PackageType,
	SerialQuantity,
	sum(PartPackCount)
From
	@AuditTrailLooseSerial
group by
	part,
	PackageType,
	SerialQuantity



declare	@AuditTrailPartPackGroupRangeID table (
Part varchar(25),
PackageType varchar(35),
PartPackQty int,
Serial int,
RangeID int, primary key (Serial))


insert	@AuditTrailPartPackGroupRangeID
(	Part,
	PackageType,
	PartPackQty,
	Serial,
	RangeID
)

Select 
	atl.part,
	atl.PackageType,
	SerialQuantity,
	Serial,
	Serial-id
	
From
	@AuditTrailLooseSerial atL
join
	@AuditTrailPartPackGroup atG on
	atG.part = atl.part and
	atg.packageType = atl.PackageType and
	atg.partPackQty = atl.SerialQuantity



insert	@AuditTrailPartPackGroupSerialRange
(	Part,
	PackageType,
	PartPackQty,
	SerialRange
)

Select 
	atl.part,
	atl.PackageType,
	SerialQuantity,
	Serial
	
From
	@AuditTrailLooseSerial atL




--asb FT, LLC 08/26/2016 - Commenting becuase we will send each serial in a GIN to iconnect
--Select 
--	part,
--	PackageType,
--	PartPackQty,
--	Case when min(serial) = max(serial)  
--		then convert(varchar(15), max(serial)) 
--		else convert(varchar(15), min(serial)) + ':' + convert(varchar(15), max(serial)) end
--From
--	@AuditTrailPartPackGroupRangeID atR
--Where
--	Part = @CustomerPart and
--	PackageType = @packType and
--	PartPackQty = @PackQty

--group by
--	part,
--	PackageType,
--	PartPackQty,
--	RangeID

--- </Body>

---	<Return>
	return
end





GO
