SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[udf_GetGMServicePackingSlips]
(
	@ShipperID int
)
returns @GMServicePackingSlips table
(	ShipperID int
,	Part varchar(25)
,	Quantity numeric(20,6)
,	Serial int
,	Boxes int
,	NetWeight numeric(20,6)
,	TareWeight numeric(20,6)
,	GrossWeight numeric(20,6)
,	ASN_Number varchar(25)
)
begin
--- <Body>
	declare
		@objects table
	(	Serial int
	,	Part varchar(25)
	,	Quantity numeric(20,6)
	,	NetWeight numeric(20,6)
	,	TareWeight numeric(20,6)
	,	GrossWeight numeric(20,6)
	)

	insert
		@objects
	(	Serial
	,	Part
	,	Quantity
	,	NetWeight
	,	TareWeight
	,	GrossWeight
	)
	select
		Serial = o.serial
	,	Part = o.part
	,	Quantity = o.std_quantity
	,	NetWeight = coalesce(o.weight, 0)
	,	TareWeight = coalesce(o.tare_weight, 0)
	,	GrossWeight = coalesce(o.weight, 0) + coalesce(o.tare_weight, 0)
	from
		dbo.object o
	where
		o.shipper = @ShipperID
		and o.type is null
	union all
	select
		Serial = at.serial
	,	Part = at.part
	,	Quantity = at.std_quantity
	,	NetWeight = coalesce(at.weight, 0)
	,	TareWeight = coalesce(at.tare_weight, 0)
	,	GrossWeight = coalesce(at.weight, 0) + coalesce(at.tare_weight, 0)
	from
		dbo.audit_trail at
	where
		at.shipper = convert(varchar, @ShipperID)
		and at.type = 'S'
		and at.object_type is null

	if	(	select
  				count(*)
  			from
				dbo.shipper s
				join dbo.shipper_detail sd
					on sd.shipper = s.id
				cross join @objects o
			where
				s.destination in
					(	select
							es.destination
						from
							dbo.edi_setups es
						where
							es.parent_destination = '17177'
					)
				and s.id = @ShipperID
  		) > 1 begin

		insert
			@GMServicePackingSlips
		(	ShipperID
		,	Part
		,	Quantity
		,	Serial
		,	Boxes
		,	NetWeight
		,	TareWeight
		,	GrossWeight
		,	ASN_Number
		)
		select
			ShipperID = s.id
		,	Part = sd.part_original
		,	Quantity = coalesce(o.Quantity, sd.qty_packed)
		,	Serial = o.Serial
		,	Boxes = 1
		,	NetWeight = s.net_weight * coalesce(o.Quantity, sd.qty_packed) /  totpack.QtyPack--o.NetWeight
		,	TareWeight = s.tare_weight * coalesce(o.Quantity, sd.qty_packed) / totpack.QtyPack --o.TareWeight
		,	GrossWeight = s.gross_weight * coalesce(o.Quantity, sd.qty_packed) / totpack.QtyPack --o.GrossWeight
		,	ASN_Number = convert(varchar, s.id) + '-' + convert(varchar, row_number() over (partition by s.id order by o.serial))
		from
			dbo.shipper s
			join dbo.shipper_detail sd
				on sd.shipper = s.id
			left join @objects o
				on o.Part = sd.part
			outer apply
			(	select
					QtyPack = sum(qty_packed)
				from
					shipper_detail
				where
					shipper = @ShipperID
			) totpack
		where
			s.destination in
				(	select
						es.destination
					from
						dbo.edi_setups es
					where
						es.parent_destination = '17177'
				)
			and s.id = @ShipperID
	end
	else begin
		insert
			@GMServicePackingSlips
		(	ShipperID
		,	Part
		,	Quantity
		,	Serial
		,	Boxes
		,	NetWeight
		,	TareWeight
		,	GrossWeight
		,	ASN_Number
		)
		select
			ShipperID = s.id
		,	Part = sd.part_original
		,	Quantity = sd.qty_packed
		,	Serial = null
		,	Boxes = null
		,	NetWeight = null
		,	TareWeight = null
		,	GrossWeight = null
		,	ASN_Number = convert(varchar, s.id)
		from
			dbo.shipper s
			join dbo.shipper_detail sd
				on sd.shipper = s.id
		where
			s.id = @ShipperID
	end
--- </Body>

---	<Return>
	return
end
GO
