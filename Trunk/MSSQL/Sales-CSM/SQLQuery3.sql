use Monitor
go

declare
	@BasePartSales table
(	BasePart char(7) primary key
,	Part2015 varchar(25)
,	SalesQty2015 numeric (20,6)
,	Sales2015 numeric (20,6)
,	Part2016 varchar(25)
,	SalesQty2016 numeric (20,6)
,	Sales2016 numeric (20,6)
)

insert
	@BasePartSales
(	BasePart
,	Part2015
,	SalesQty2015
,	SalesQty2016
,	Sales2015
,	Sales2016
)
select
	*
from
	openquery
	(	EEISQL1
	,	'
select
	CustomerCode = left(coalesce(xr.ChildPart, sd.part),7)
,	SalesQty2015 = sum(case when datepart(yy, s.date_shipped) = 2015 then sd.qty_packed else 0 end)
,	SalesQty2016 = sum(case when datepart(yy, s.date_shipped) = 2016 then sd.qty_packed else 0 end)
,	Sales2015 = sum(case when datepart(yy, s.date_shipped) = 2015 then sd.price * sd.qty_packed else 0 end)
,	Sales2016 = sum(case when datepart(yy, s.date_shipped) = 2016 then sd.price * sd.qty_packed else 0 end)
from
	MONITOR.dbo.shipper s
	join MONITOR.dbo.shipper_detail sd
		on s.id = sd.shipper
	left join MONITOR.FT.XRt xr
		join MONITOR.dbo.po_header ph1
			on ph1.blanket_part = xr.ChildPart
			and ph1.vendor_code = ''EEH''
		on xr.TopPart = sd.LastShippedPart
		and xr.TopPart != xr.ChildPart
where
	datepart(yy, s.date_shipped) in (''2015'', ''2016'')
	and s.type is null
	and sd.part_original not like ''%-PT%''
group by
	left(sd.part,7)
order by
	1
') oq

declare
	@BasePartRawSpend table
(	BasePart char(7) primary key
,	RawPartSpend2015 numeric (20,6)
,	RawPartSpend2016 numeric (20,6)
,	RawPartSpend2017 numeric (20,6)
,	RawPartSpend2018 numeric (20,6)
,	RawPartSpend2019 numeric (20,6)
)

insert
	@BasePartRawSpend
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
union all
select
	Sales.BasePart
,	RawPartSpend2015 = coalesce(max(case when Sales.SalesYear = 2015 then Sales.RawSpend end), 0.0)
,	RawPartSpend2016 = coalesce(max(case when Sales.SalesYear = 2016 then Sales.RawSpend end), 0.0)
,	RawPartSpend2017 = 0
,	RawPartSpend2018 = 0
,	RawPartSpend2019 = 0
from
	(	select
			sales.BasePart
		,	SalesYear = 2016
		,	SalesQty = sum(sales.SalesQty)
		,	Sales = sum(sales.Sales)
		,	RawSpend = sum(bom.Quantity * ps.material_cum * sales.SalesQty)
		from
			(	select
			 		oq.BasePart
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
			) sales
			join dbo.vw_RawQtyPerFinPart bom
				on bom.TopPart = coalesce
					(	(	select
					 			max(vrqpfp.TopPart)
					 		from
					 			dbo.vw_RawQtyPerFinPart vrqpfp
							where
								vrqpfp.TopPart = sales.Part
						)
					,	(	select
					 			max(vrqpfp.TopPart)
					 		from
					 			dbo.vw_RawQtyPerFinPart vrqpfp
							where
								left(vrqpfp.TopPart,7) = left(sales.Part,7)
						)
					)
			join dbo.part_standard ps
				on ps.part = bom.ChildPart
		group by
			sales.BasePart
		union all
		select
			sales.BasePart
		,	SalesYear = 2016
		,	SalesQty = sum(sales.SalesQty)
		,	Sales = sum(sales.Sales)
		,	RawSpend = sum(bom.Quantity * ps.material_cum * sales.SalesQty)
		from
			(	select
			 		oq.BasePart
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
			) sales
			join dbo.vw_RawQtyPerFinPart bom
				on bom.TopPart = coalesce
					(	(	select
					 			max(vrqpfp.TopPart)
					 		from
					 			dbo.vw_RawQtyPerFinPart vrqpfp
							where
								vrqpfp.TopPart = sales.Part
						)
					,	(	select
					 			max(vrqpfp.TopPart)
					 		from
					 			dbo.vw_RawQtyPerFinPart vrqpfp
							where
								left(vrqpfp.TopPart,7) = left(sales.Part,7)
						)
					)
			join dbo.part_standard ps
				on ps.part = bom.ChildPart
		group by
			sales.BasePart
	) Sales
where
	Sales.BasePart not in
	(	select
			cvs.base_part
		from
			FT.CSM_VendorSpend cvs
	)
group by
	Sales.BasePart

select
	*
from
	@BasePartRawSpend bprs
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
	@BasePartRawSpend bprs
group by
	left(bprs.BasePart, 3)

select
	*
from
	@BasePartSales bps

select
	CustomerCode = left(bps.BasePart, 3)
,	Sales2015 = sum(bps.Sales2015)
,	Sales2016 = sum(bps.Sales2016)
from
	@BasePartSales bps
group by
	left(bps.BasePart, 3)

select
	*
from
	@BasePartSales bps
where
	not exists
	(	select
			*
		from
			@BasePartRawSpend bprs
		where
			bprs.BasePart = bps.BasePart
	)