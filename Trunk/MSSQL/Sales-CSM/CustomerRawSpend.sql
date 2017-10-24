use Monitor
go

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
order by
	1

select
	CustomerCode = left(CSM_VendorSpend.base_part,3)
,	RawPartSpend2015 = sum(CSM_VendorSpend.RawPartSpend2015)
,	RawPartSpend2016 = sum(CSM_VendorSpend.RawPartSpend2016)
,	RawPartSpend2017 = sum(CSM_VendorSpend.RawPartSpend2017)
,	RawPartSpend2018 = sum(CSM_VendorSpend.RawPartSpend2018)
,	RawPartSpend2019 = sum(CSM_VendorSpend.RawPartSpend2019)
from
	FT.CSM_VendorSpend
group by
	left(CSM_VendorSpend.base_part,3)
order by
	1

select
	BasePart = left(sd.part,7)
,	SalesQty2015 = sum(case when datepart(yy, s.date_shipped) = 2015 then sd.price * sd.qty_packed else 0 end)
,	Sales2016 = sum(case when datepart(yy, s.date_shipped) = 2016 then sd.price * sd.qty_packed else 0 end)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on s.id = sd.shipper
where
	s.date_shipped between '2015-01-01' and '2017-01-01'
	and s.type is null
	and sd.part_original not like '%-PT%'
group by
	left(sd.part,7)
order by
	1

select
	CustomerCode = left(sd.part,3)
,	SalesQty2015 = sum(case when datepart(yy, s.date_shipped) = 2015 then sd.price * sd.qty_packed else 0 end)
,	Sales2016 = sum(case when datepart(yy, s.date_shipped) = 2016 then sd.price * sd.qty_packed else 0 end)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on s.id = sd.shipper
where
	s.date_shipped between '2015-01-01' and '2017-01-01'
	and s.type is null
	and sd.part_original not like '%-PT%'
group by
	left(sd.part,3)
order by
	1