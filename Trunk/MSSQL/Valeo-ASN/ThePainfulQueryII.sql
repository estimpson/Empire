declare
	@ShipperID int = 107198

declare
	@ValeoASNDetails table
(	SupplierCode varchar(20)
,	BasePart char(7)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	EngineeringLevel varchar(50)
,	DockCode varchar(50)
,	PackagingCode varchar(50)
,	ShipQty numeric(20,6)
,	AccumShipQty numeric(20,6)
,	TotalShipperQty numeric(20,6)
,	BoxQuantity numeric(20,6)
,	BoxSerial int
,	ParentSerial int
,	MasterSerial int
,	PartDenseRank int
,	PartPalletDenseRank int
,	PartPalletPackQtyDenseRank int
,	PalletDenseRank int
,	PackQtyDenseRank int
)

insert
	@ValeoASNDetails
select
	r.SupplierCode
,	r.BasePart
,	r.CustomerPart
,	r.CustomerPO
,	r.EngineeringLevel
,	r.DockCode
,	r.PackagingCode
,	r.ShipQty
,	r.AccumShipQty
,	r.TotalShipperQty
,	r.BoxQuantity
,	r.BoxSerial
,	r.ParentSerial
,	r.MasterSerial
,	r.PartDenseRank
,	r.PartPalletDenseRank
,	r.PartPalletPackQtyDenseRank
,	r.PalletDenseRank
,	r.PackQtyDenseRank
from
	(	select distinct
			SupplierCode = coalesce(es.supplier_code, '834')
		,	BasePart = left(at.part, 7)
		,	CustomerPart = sd.customer_part
		,	CustomerPO = sd.customer_po
		,	EngineeringLevel = oh.engineering_level
		,	DockCode = oh.dock_code
		,	PackagingCode = 'PLT71'
		,	ShipQty =
				(	select
						sum(sd2.alternative_qty)
					from
						dbo.shipper_detail sd2
					where
						sd2.shipper = @ShipperID
						and sd2.customer_part = sd.customer_part
				)
		,	AccumShipQty = max(sd.alternative_qty) over (partition by sd.customer_part)
		,	TotalShipperQty = sum(at.std_quantity) over (partition by @ShipperID)
		,	BoxQuantity = at.quantity
		,	BoxSerial = at.serial
		,	ParentSerial = coalesce(at.parent_serial, 0)
		,	MasterSerial = min(at.serial) over (partition by sd.customer_part, at.parent_serial) * 10

		,	PartDenseRank = dense_rank() over (order by sd.customer_part)
		,	PartPalletDenseRank = dense_rank() over (partition by sd.customer_part order by at.parent_serial)
		,	PartPalletPackQtyDenseRank = dense_rank() over (partition by sd.customer_part, at.parent_serial order by at.quantity)

		,	PalletDenseRank = dense_rank() over (order by sd.customer_part, at.parent_serial)
		,	PackQtyDenseRank = dense_rank() over (order by sd.customer_part, at.parent_serial, at.quantity)

		from
			audit_trail at
			join shipper s
				join dbo.edi_setups es
					on es.destination = s.destination
				on s.id = @ShipperID
			join dbo.shipper_detail sd
				on sd.shipper = @ShipperID
				and sd.part_original = at.part
			left join dbo.order_header oh
				on oh.order_no = sd.order_no
		where
			at.type = 'S'
			and at.shipper = convert(varchar(10), @ShipperID)
			and at.part != 'PALLET'
	) r

declare
	@detailXML table
(	HLID int
,	HL_XML xml
)

insert
	@detailXML
select
	IDNumber = 2 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1))
,	(	select
			EDI_XML.LOOP_INFO('HL')
		,	EDI_XML_V4010.SEG_HL
				(	2 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1))
				,	1
				,	'T'
				,	null
				)
		,	EDI_XML_VALEO_ASN.SEG_LIN(null, 'BP', vad.CustomerPart, 'PO', max(vad.CustomerPO), 'EC', max(vad.EngineeringLevel))
		,	EDI_XML_V4010.SEG_SN1(null, max(vad.ShipQty), 'EA', max(vad.AccumShipQty))
		,	EDI_XML_V4010.SEG_REF('DK', max(vad.DockCode))
		for xml raw ('LOOP-HL'), type
	)
from
	@ValeoASNDetails vad
group by
	vad.CustomerPart

insert
	@detailXML
select
	IDNumber = 3 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1))
,	(	select
			EDI_XML.LOOP_INFO('HL')
		,	EDI_XML_V4010.SEG_HL
				(	3 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1))
				,	2 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1) - 2*(vad.PartPalletDenseRank - 1))
				,	'O'
				,	null
				)
		,	EDI_XML_V4010.SEG_REF('LS', vad.SupplierCode + convert(varchar, max(vad.MasterSerial)))
		for xml raw ('LOOP-HL'), type
	)
from
	@ValeoASNDetails vad
group by
	vad.SupplierCode
,	vad.CustomerPart
,	vad.ParentSerial
,	vad.MasterSerial

insert
	@detailXML
select
	IDNumber = 4 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1) - (vad.PartPalletPackQtyDenseRank - 1))
,	(	select
			EDI_XML.LOOP_INFO('HL')
		,	EDI_XML_V4010.SEG_HL
				(	4 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1) - (vad.PartPalletPackQtyDenseRank - 1))
				,	3 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1) - (vad.PartPalletPackQtyDenseRank - 1))
				,	'I'
				,	null
				)
			,	EDI_XML_V4010.SEG_SN1(null, max(vad.BoxQuantity), 'PC', null)
		,	(	select
		 			EDI_XML_V4010.SEG_REF('LS', vad.SupplierCode + convert(varchar, vads.BoxSerial))
		 		from
		 			@ValeoASNDetails vadS
				where
					vads.CustomerPart = vad.CustomerPart
					and vadS.ParentSerial = vad.ParentSerial
				for xml path (''),type
		 	)
		for xml raw ('LOOP-HL'), type
	)
from
	@ValeoASNDetails vad
group by
	vad.SupplierCode
,	vad.CustomerPart
,	vad.ParentSerial
,	vad.MasterSerial

select
	(	select
			dx.HL_XML
	)
from
	@detailXML dx
order by
	dx.HLID
for xml path(''), type
