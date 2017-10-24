use Monitor
go

--rollback
begin transaction
go

create table
	#BasePartSales
(	BasePart char(7) primary key
,	Part2015 varchar(25)
,	SalesQty2015 numeric (20,6)
,	Sales2015 numeric (20,6)
,	Part2016 varchar(25)
,	SalesQty2016 numeric (20,6)
,	Sales2016 numeric (20,6)
)

alter table #BasePartSales add unique (Part2015, BasePart)
alter table #BasePartSales add unique (Part2016, BasePart)

insert
	#BasePartSales
(	BasePart
,	Part2015
,	SalesQty2015
,	Sales2015
,	Part2016
,	SalesQty2016
,	Sales2016
)
select
	sd.BasePart
,	Part2015 = max(case when sd.SalesYear = 2015 then sd.Part end)
,	SalesQty2015 = max(case when sd.SalesYear = 2015 then sd.SalesQty end)
,	Sales2015 = max(case when sd.SalesYear = 2015 then sd.Sales end)
,	Part2016 = max(case when SalesYear = 2016 then sd.Part end)
,	SalesQty2016 = max(case when sd.SalesYear = 2016 then sd.SalesQty end)
,	Sales2016 = max(case when sd.SalesYear = 2016 then sd.Sales end)
from
	(	select
			oq.BasePart
		,	SalesYear = 2015
		,	SalesQty = sum(SalesQty)
		,	Sales = sum(Sales)
		,	Part = max(Part)
		from
			openquery
			(	EEISQL1
			,	'
		select
			sd.BasePart
		,	sd.SalesQty
		,	sd.Sales
		,	Part = coalesce(xr.ChildPart, sd.LastShippedPart)
		from
			(	select
					BasePart = left(sd.part_original,7)
				,	SalesQty = sum(sd.qty_packed)
				,	Sales = sum(sd.qty_packed * sd.price)
				,	LastShippedPart =
						(	select top 1
								sd2.part_original
							from
								MONITOR.dbo.shipper s2
								join MONITOR.dbo.shipper_detail sd2
									on s2.id = sd2.shipper
							where
								datepart(year, s2.date_shipped) = 2015
								and s2.type is null
								and left(sd2.part_original,7) = left(sd.part_original,7)
							order by
								s2.date_shipped desc
						)
				from
					MONITOR.dbo.shipper s
					join MONITOR.dbo.shipper_detail sd
						on s.id = sd.shipper
				where
					datepart(year, s.date_shipped) = 2015
					and s.type is null
					and sd.part_original not like ''%-PT%''
					and sd.part_original like ''[A-Z][A-Z][A-Z]____-%''
				group by
					left(sd.part_original,7)
			) sd
			left join MONITOR.FT.XRt xr
				join MONITOR.dbo.po_header ph1
					on ph1.blanket_part = xr.ChildPart
					and ph1.vendor_code = ''EEH''
				on xr.TopPart = sd.LastShippedPart
				and xr.TopPart != xr.ChildPart
		'
			) oq
		group by
			oq.BasePart
		union all
		select
			oq.BasePart
		,	SalesYear = 2016
		,	SalesQty = sum(SalesQty)
		,	Sales = sum(Sales)
		,	Part = max(Part)
		from
			openquery
			(	EEISQL1
			,	'
		select
			sd.BasePart
		,	sd.SalesQty
		,	sd.Sales
		,	Part = coalesce(xr.ChildPart, sd.LastShippedPart)
		from
			(	select
					BasePart = left(sd.part_original,7)
				,	SalesQty = sum(sd.qty_packed)
				,	Sales = sum(sd.qty_packed * sd.price)
				,	LastShippedPart =
						(	select top 1
								sd2.part_original
							from
								MONITOR.dbo.shipper s2
								join MONITOR.dbo.shipper_detail sd2
									on s2.id = sd2.shipper
							where
								datepart(year, s2.date_shipped) = 2016
								and s2.type is null
								and left(sd2.part_original,7) = left(sd.part_original,7)
							order by
								s2.date_shipped desc
						)
				from
					MONITOR.dbo.shipper s
					join MONITOR.dbo.shipper_detail sd
						on s.id = sd.shipper
				where
					datepart(year, s.date_shipped) = 2016
					and s.type is null
					and sd.part_original not like ''%-PT%''
					and sd.part_original like ''[A-Z][A-Z][A-Z]____-%''
				group by
					left(sd.part_original,7)
			) sd
			left join MONITOR.FT.XRt xr
				join MONITOR.dbo.po_header ph1
					on ph1.blanket_part = xr.ChildPart
					and ph1.vendor_code = ''EEH''
				on xr.TopPart = sd.LastShippedPart
				and xr.TopPart != xr.ChildPart
		'
			) oq
		group by
			oq.BasePart
	) sd
group by
	sd.BasePart
order by
	1

create table
	#ValidTopParts
(	BasePart varchar(7)
,	TopPart varchar(25)
)

insert
	#ValidTopParts
select distinct
	BasePart = left(vrqpfp.TopPart, 7)
,	vrqpfp.TopPart
from
	dbo.vw_RawQtyPerFinPart vrqpfp

alter table #ValidTopParts alter column TopPart varchar(25) not null
alter table #ValidTopParts add primary key (TopPart)
alter table #ValidTopParts add unique (BasePart, TopPart)

create table
	#BasePartRawSpend
(	BasePart char(7) primary key
,	RawPartSpend2015 numeric (20,6)
,	RawPartSpend2016 numeric (20,6)
,	RawPartSpend2017 numeric (20,6)
,	RawPartSpend2018 numeric (20,6)
,	RawPartSpend2019 numeric (20,6)
)

insert
	#BasePartRawSpend
select
	BasePart = CSM_VendorSpend.base_part
,	RawPartSpend2015 = sum(CSM_VendorSpend.RawPartSpend2015)
,	RawPartSpend2016 = sum(CSM_VendorSpend.RawPartSpend2016)
,	RawPartSpend2017 = sum(CSM_VendorSpend.RawPartSpend2017)
,	RawPartSpend2018 = sum(CSM_VendorSpend.RawPartSpend2018)
,	RawPartSpend2019 = sum(CSM_VendorSpend.RawPartSpend2019)
from
	FT.CSM_VendorSpend
group by
	CSM_VendorSpend.base_part

update
	bps
set	Part2015 = coalesce
	(	(	select
				max(vtp.TopPart)
			from
				#ValidTopParts vtp
			where
				vtp.TopPart = bps.Part2015
		)
	,	(	select
				max(vtp.TopPart)
			from
				#ValidTopParts vtp
			where
				vtp.BasePart = bps.BasePart
		)
	)
from
	#BasePartSales bps
where
	bps.BasePart not in
	(	select
			bprs.Basepart
		from
			#BasePartRawSpend bprs
	)
	and bps.Part2015 is not null


update
	bps
set	Part2016 = coalesce
	(	(	select
				max(vtp.TopPart)
			from
				#ValidTopParts vtp
			where
				vtp.TopPart = bps.Part2016
		)
	,	(	select
				max(vtp.TopPart)
			from
				#ValidTopParts vtp
			where
				vtp.BasePart = bps.BasePart
		)
	)
from
	#BasePartSales bps
where
	bps.BasePart not in
	(	select
			bprs.Basepart
		from
			#BasePartRawSpend bprs
	)
	and bps.Part2016 is not null

insert
	#BasePartRawSpend
select
	rps.BasePart
,	RawPartSpend2015 = sum(case when SalesYear = 2015 then rps.RawPartSpend end)
,	RawPartSpend2016 = sum(case when SalesYear = 2016 then rps.RawPartSpend end)
,	RawPartSpend2017 = 0
,	RawPartSpend2018 = 0
,	RawPartSpend2019 = 0
from
	(	select
			bps.BasePart
		,	SalesYear = 2015
		,	RawPartSpend = sum(bps.SalesQty2015 * bom.Quantity * ps.material_cum)
		from
			#BasePartSales bps
			join EEH.dbo.vw_RawQtyPerFinPart bom
				on bom.TopPart = bps.Part2015
			join dbo.part_standard ps
				on ps.part = bom.ChildPart
		where
			bps.BasePart not in
			(	select
					bprs.Basepart
				from
					#BasePartRawSpend bprs
			)
		group by
			bps.BasePart
		union all
		select
			bps.BasePart
		,	SalesYear = 2016
		,	RawPartSpend = sum(bps.SalesQty2016 * bom.Quantity * ps.material_cum)
		from
			#BasePartSales bps
			join dbo.vw_RawQtyPerFinPart bom
				on bom.TopPart = bps.Part2016
			join dbo.part_standard ps
				on ps.part = bom.ChildPart
		where
			bps.BasePart not in
			(	select
					bprs.Basepart
				from
					#BasePartRawSpend bprs
			)
		group by
			bps.BasePart
	) rps
group by
	rps.BasePart

--	Results:
select
	*
from
	#BasePartRawSpend bprs
order by
	bprs.BasePart

select
	CustomerCode = left(bprs.BasePart, 3)
,	RawPartSpend2015 = sum(bprs.RawPartSpend2015)
,	RawPartSpend2016 = sum(bprs.RawPartSpend2016)
,	RawPartSpend2017 = sum(bprs.RawPartSpend2017)
,	RawPartSpend2018 = sum(bprs.RawPartSpend2018)
,	RawPartSpend2019 = sum(bprs.RawPartSpend2019)
from
	#BasePartRawSpend bprs
group by
	left(bprs.BasePart, 3)

select
	bps.BasePart
,	bps.Sales2015
,	bps.Sales2016
from
	#BasePartSales bps

select
	CustomerCode = left(bps.BasePart, 3)
,	Sales2015 = sum(bps.Sales2015)
,	Sales2016 = sum(bps.Sales2016)
from
	#BasePartSales bps
group by
	left(bps.BasePart, 3)

select
	*
from
	#BasePartSales bps
where
	not exists
	(	select
			*
		from
			#BasePartRawSpend bprs
		where
			bprs.BasePart = bps.BasePart
	)