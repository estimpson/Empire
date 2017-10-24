declare
	@ShipperID int = 107198

declare
	@ValeoASNDetails table
(	BasePart char(7)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	EngineeringLevel varchar(50)
,	DockCode varchar(50)
,	PackagingCode varchar(50)
,	ShipQty numeric(20,6)
,	AccumShipQty numeric(20,6)
,	TotalShipperQty numeric(20,6)
,	BoxQuantity numeric(20,6)
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
	r.BasePart
,	r.CustomerPart
,	r.CustomerPO
,	r.EngineeringLevel
,	r.DockCode
,	r.PackagingCode
,	r.ShipQty
,	r.AccumShipQty
,	r.TotalShipperQty
,	r.BoxQuantity
,	r.ParentSerial
,	r.MasterSerial
,	r.PartDenseRank
,	r.PartPalletDenseRank
,	r.PartPalletPackQtyDenseRank
,	r.PalletDenseRank
,	r.PackQtyDenseRank
from
	(	select distinct
			BasePart = left(at.part, 7)
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
		--,	BoxSerial = at.serial
		,	ParentSerial = coalesce(at.parent_serial, 0)
		,	MasterSerial = min(at.serial) over (partition by sd.customer_part, at.parent_serial) * 10

		,	PartDenseRank = dense_rank() over (order by sd.customer_part)
		,	PartPalletDenseRank = dense_rank() over (partition by sd.customer_part order by at.parent_serial)
		,	PartPalletPackQtyDenseRank = dense_rank() over (partition by sd.customer_part, at.parent_serial order by at.quantity)

		,	PalletDenseRank = dense_rank() over (order by sd.customer_part, at.parent_serial)
		,	PackQtyDenseRank = dense_rank() over (order by sd.customer_part, at.parent_serial, at.quantity)

		from
			audit_trail at
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
--order by
--	left(at.part, 7)
--,	coalesce(at.parent_serial, 0)
--,	at.serial

select
	vad.CustomerPart + ':' + min(vad.CustomerPO) + ':' + min(vad.BasePart)
,	Type = 'T'
,	IDNumber = 2 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1))
,	ParentIDNumber = 1
from
	@ValeoASNDetails vad
group by
	vad.CustomerPart
union all
select
	vad.CustomerPart + ':' + convert(varchar, vad.MasterSerial)
,	Type = 'O'
,	IDNumber = 3 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1))
,	ParentIDNumber = 2 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1) - 2*(vad.PartPalletDenseRank - 1))
from
	@ValeoASNDetails vad
group by
	vad.CustomerPart
,	vad.ParentSerial
,	vad.MasterSerial
union all
select
	vad.CustomerPart + ':' + convert(varchar, vad.MasterSerial)
,	Type = 'I'
,	IDNumber = 4 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1) - (vad.PartPalletPackQtyDenseRank - 1))
,	ParentIDNumber = 3 + min((vad.PartDenseRank - 1) + (vad.PalletDenseRank - 1) + (vad.PackQtyDenseRank - 1) - (vad.PartPalletPackQtyDenseRank - 1))
from
	@ValeoASNDetails vad
group by
	vad.CustomerPart
,	vad.ParentSerial
,	vad.MasterSerial
order by
	3

--select
--	*
--from
--	@ValeoASNDetails vad
--order by
--	vad.CustomerPart
--,	vad.ParentSerial