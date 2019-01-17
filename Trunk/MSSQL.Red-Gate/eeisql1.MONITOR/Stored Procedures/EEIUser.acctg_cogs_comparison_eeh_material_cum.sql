SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- exec eeiuser.acctg_cogs_comparison_eeh_material_cum 2018,11,2018,12

CREATE procedure [EEIUser].[acctg_cogs_comparison_eeh_material_cum]	(
											@fiscal_year1 int,					
											@period1 int,
											@fiscal_year2 int,
											@period2 int
										)
as
begin



declare		@oh_time1 datetime,
			@ph_time1 datetime,
			@psh_time1 datetime, 
			@oh_time2 datetime, 
			@ph_time2 datetime, 
			@psh_time2 datetime,
			@eehpsh_time1 datetime,
			@eehpsh_time2 datetime,
			@labor_rate decimal(20,6),
			@burden_rate decimal(20,6),
			@Period1BeginDT datetime,
			@Period1EndDT datetime,
			@Period2BeginDT datetime,
			@Period2EndDT datetime

Select		@Period1BeginDT = (Select convert(datetime, convert(varchar(4) ,@fiscal_year1 )+'-'+ convert(varchar(2) ,@period1 )+ '-' + '01' ))
Select		@Period1EndDT= (Select dateadd(mm,1,@Period1BeginDT) )
Select		@Period2BeginDT = (Select convert(datetime, convert(varchar(4) ,@fiscal_year2 )+'-'+ convert(varchar(2) ,@period2 )+ '-' + '01' ))
Select		@Period2EndDT = (Select dateadd(mm,1,@Period2BeginDT) )

select		@ph_time1 = (select max(time_stamp) from historicaldata.dbo.part_historical_daily where fiscal_year = @fiscal_year1 and period = @period1);
select		@psh_time1 = (select max(time_stamp) from historicaldata.dbo.part_standard_historical_daily where fiscal_year = @fiscal_year1 and period = @period1);
select		@ph_time2 = (select max(time_stamp) from historicaldata.dbo.part_historical_daily where fiscal_year = @fiscal_year2 and period = @period2);
select		@psh_time2 = (select max(time_stamp) from historicaldata.dbo.part_standard_historical_daily where fiscal_year = @fiscal_year2 and period = @period2);
select		@labor_rate = 2.11795
select		@burden_rate = 1.475
select		@eehpsh_time1 = (select max(time_stamp) from [EEHSQL1].[historicaldata].[dbo].part_standard_historical_daily where fiscal_year = @fiscal_year1 and period = @period1);
select		@eehpsh_time2 = (select max(time_stamp) from [EEHSQL1].[historicaldata].[dbo].part_standard_historical_daily where fiscal_year = @fiscal_year2 and period = @period2);

/*Declare	@fiscal_year1 int,					
			@period1 int,
			@fiscal_year2 int,
			@period2 int

Select		@fiscal_year1 = 2008
Select		@period1 = 7
Select		@fiscal_year2 = 2008
Select		@period2 = 8*/


create table	#PartList 
(
Part varchar(25), 
primary key (Part)
)

delete		#PartList

Insert		#PartList

Select		part_original
from		historicaldata.dbo.part_historical_daily
join		shipper_detail on part_historical_daily.part = shipper_detail.part_original
join		shipper  on shipper_detail.shipper = shipper.id
where		fiscal_year = @fiscal_year1 
		and period = @period1 
		and	isNULL (shipper.type, 'Y') <> 'V' and isNULL (shipper.type, 'Y') <> 'T'
		and	shipper_detail.qty_packed is not null 
		and	shipper.date_shipped >= @Period1BeginDT 
		and	shipper.date_shipped< @Period1EndDT 
		and	part_historical_daily.time_stamp = @ph_time1 
UNION
Select		part_original
from		historicaldata.dbo.part_historical_daily
join		shipper_detail on part_historical_daily.part = shipper_detail.part_original
join		shipper  on shipper_detail.shipper = shipper.id
where		fiscal_year = @fiscal_year2 
		and period = @period2 and
			isNULL (shipper.type, 'Y') <> 'V' and isNULL (shipper.type, 'Y') <> 'T' and
			shipper_detail.qty_packed is not null and
			shipper.date_shipped >= @Period2BeginDT and
			shipper.date_shipped< @Period2EndDT and 
			part_historical_daily.time_stamp = @ph_time2 

create table #EEHMC1
(	eeh_part1 varchar(25),
	eeh_timestamp1 datetime,
	eeh_material_cum1 numeric (18,6))

create table #EEHMC2
(	eeh_part2 varchar(25),
	eeh_timestamp2 datetime,
	eeh_material_cum2 numeric (18,6))

declare	@Syntax nvarchar (4000)
set	@Syntax = N'

delete
	#EEHMC1

insert
	#EEHMC1
select
	oq.part
,	oq.time_stamp
,	oq.material_cum
from
	OpenQuery ([EEHSQL1],
	''
				
select
	pshd.part
,	pshd.time_stamp
,	pshd.material_cum
from
	HistoricalData.dbo.part_standard_historical_daily pshd
where
	pshd.time_stamp = ''''' + convert(nvarchar, @eehpsh_time1, 126) + '''''
	''
		) oq
	join #partlist pl
		on pl.part = oq.part					
'

execute	sp_executesql
	@Syntax

declare	@Syntax2 nvarchar (4000)
set	@Syntax2 = N'

delete
	#EEHMC2

insert
	#EEHMC2
select
	oq.part
,	oq.time_stamp
,	oq.material_cum
from
	OpenQuery ([EEHSQL1],
	''
				
select
	pshd.part
,	pshd.time_stamp
,	pshd.material_cum
from
	HistoricalData.dbo.part_standard_historical_daily pshd
where
	pshd.time_stamp = ''''' + convert(nvarchar, @eehpsh_time2, 126) + '''''
	''
		) oq
	join #partlist pl
		on pl.part = oq.part					
'

execute	sp_executesql
	@Syntax2


select		LEFT(PartList.Part,7) AS base_part,
			PartList.Part as part_number, 
			coalesce(nullif(ph1.product_line,''), nullif(ph2.product_line,''), 'No Product Line') as product_line,
			coalesce(nullif(ph1.type,''), nullif(ph2.type,''), 'No Type') as type,
			isnull(a.quantity,0) as quantity1, 
			isnull(b.quantity,0) as quantity2,	
			isnull(b.quantity,0)-isnull(a.quantity,0) as quantity_change,
			ph1.product_line as product_line1,
			ph2.product_line as product_line2,
			(case when ph1.product_line = ph2.product_line then 'false' else 'true' end) as product_line_change,
			
			ph1.type as type1,
			ph2.type as type2,
			(case when ph1.type = ph2.type then 'false' else 'true' end) as type_change,
			
			(case when (ISNULL(psh1.price,0)=0 and isnulL(a.quantity,0)=0) then psh2.price else psh1.price end) as price1,
			(case when (ISNULL(psh2.price,0)=0 and isnulL(b.quantity,0)=0) then psh1.price else psh2.price end) as price2,
			(case when (ISNULL(psh2.price,0)=0 and isnulL(b.quantity,0)=0) then psh1.price else psh2.price end)-(case when (ISNULL(psh1.price,0)=0 and isnulL(a.quantity,0)=0) then psh2.price else psh1.price end) as price_change,			
			ISNULL(b.quantity,0)*((case when (ISNULL(psh2.price,0)=0 and isnulL(b.quantity,0)=0) then psh1.price else psh2.price end)-(case when (ISNULL(psh1.price,0)=0 and isnulL(a.quantity,0)=0) then psh2.price else psh1.price end)) AS price_impact,
			
			(ISNULL(a.quantity,0)*ISNULL(psh1.price,0)) as ext_price1,
			(ISNULL(b.quantity,0)*ISNULL(psh2.price,0)) as ext_price2,
			((ISNULL(b.quantity,0)*ISNULL(psh2.price,0))-(ISNULL(a.quantity,0)*ISNULL(psh1.price,0))) as ext_price_change,

			(case when (ISNULL(psh1.material_cum,0)=0 and isnulL(a.quantity,0)=0) then psh2.material_cum else psh1.material_cum end) AS material_cum1, 
			(case when (ISNULL(psh2.material_cum,0)=0 and isnulL(b.quantity,0)=0) then psh1.material_cum else psh2.material_cum end) as material_cum2,
			(case when (ISNULL(psh2.material_cum,0)=0 and isnulL(b.quantity,0)=0) then psh1.material_cum else psh2.material_cum end)-ISNULL(psh1.material_cum,0) as material_cum_change,			
			
			(ISNULL(a.quantity,0)*ISNULL(psh1.material_cum,0)) as ext_material_cum1,
			(ISNULL(b.quantity,0)*ISNULL(psh2.material_cum,0)) as ext_material_cum2,
			((ISNULL(b.quantity,0)*ISNULL(psh2.material_cum,0))-(ISNULL(a.quantity,0)*ISNULL(psh1.material_cum,0))) as ext_material_cum_change,
			
			(case when (ISNULL(eeh_material_cum1,0)=0 and isnull(a.quantity,0)=0) then eeh_material_cum2 else eeh_material_cum1 end) as eeh_material_cum1,
			(case when (ISNULL(eeh_material_cum2,0)=0 and isnull(b.quantity,0)=0) then eeh_material_cum1 else eeh_material_cum2 end) as eeh_material_cum2,
			(case when (ISNULL(eeh_material_cum2,0)=0 and isnull(b.quantity,0)=0) then eeh_material_cum1 else eeh_material_cum2 end)-(case when (ISNULL(eeh_material_cum1,0)=0 and isnull(a.quantity,0)=0) then eeh_material_cum2 else eeh_material_cum1 end) as eeh_material_cum_change,
			ISNULL(b.quantity,0)*((case when (ISNULL(eeh_material_cum2,0)=0 and isnull(b.quantity,0)=0) then eeh_material_cum1 else eeh_material_cum2 end)-(case when (ISNULL(eeh_material_cum1,0)=0 and isnull(a.quantity,0)=0) then eeh_material_cum2 else eeh_material_cum1 end)) AS material_impact,
			
			(ISNULL(a.quantity,0)*ISNULL(eeh_material_cum1,0)) as ext_eeh_material_cum1,
			(ISNULL(b.quantity,0)*ISNULL(eeh_material_cum2,0)) as ext_eeh_material_cum2,
			((ISNULL(b.quantity,0)*ISNULL(eeh_material_cum2,0))-(ISNULL(a.quantity,0)*ISNULL(eeh_material_cum1,0))) as ext_eeh_material_cum_change,
			
			ISNULL(sh1.std_hours,0) as std_hours1,
			ISNULL(sh2.std_hours,0) as std_hours2,
			ISNULL(sh2.std_hours,0)-ISNULL(sh1.std_hours,0) as std_hours_change,
			
			(ISNULL(sh1.std_hours,0)*@labor_rate) as absorbed_labor_cum1,
			(ISNULL(sh2.std_hours,0)*@labor_rate) as absorbed_labor_cum2,
			(ISNULL(sh2.std_hours,0)*@labor_rate)-(ISNULL(sh1.std_hours,0)*@labor_rate) as absorbed_labor_cum_change,
			
			(ISNULL(a.quantity,0)*ISNULL(sh1.std_hours,0)*@labor_rate) as ext_absorbed_labor_cum1,
			(ISNULL(b.quantity,0)*ISNULL(sh2.std_hours,0)*@labor_rate) as ext_absorbed_labor_cum2,
			(ISNULL(b.quantity,0)*ISNULL(sh2.std_hours,0)*@labor_rate)-(ISNULL(a.quantity,0)*ISNULL(sh1.std_hours,0)*@labor_rate) as ext_absorbed_labor_cum_change,
			
			(ISNULL(a.quantity,0)*ISNULL(sh1.std_hours,0)*@labor_rate*@burden_rate) as ext_absorbed_burden_cum1,
			(ISNULL(b.quantity,0)*ISNULL(sh1.std_hours,0)*@labor_rate*@burden_rate) as ext_absorbed_burden_cum2,
			(ISNULL(b.quantity,0)*ISNULL(sh2.std_hours,0)*@labor_rate*@burden_rate)-(ISNULL(a.quantity,0)*ISNULL(sh1.std_hours,0)*@labor_rate*@burden_rate) as ext_absorbed_burden_cum_change,
			
			ISNULL(a.ExtendedSales,0) as Period1ShipperDetailExtended,
			isNULL(b.ExtendedSales,0) as Period2ShipperDetailExtended,
			
			(ISNULL(sh1.std_hours,0)*@labor_rate*@burden_rate) as absorbed_burden_cum1,
			(ISNULL(sh2.std_hours,0)*@labor_rate*@burden_rate) as absorbed_burden_cum2,
			(ISNULL(sh2.std_hours,0)*@labor_rate*@burden_rate) - (ISNULL(sh1.std_hours,0)*@labor_rate*@burden_rate) as absorbed_burden_cum_diff
			,@Period1BeginDT
			,@period1EndDT


from		#partList PartList
left join	
			(	Select	part_original,
						SUM(qty_packed) as quantity,
						SUM(qty_packed*alternate_price) as ExtendedSales
				from		shipper_detail
				join		shipper  on shipper_detail.shipper = shipper.id
				where	isNULL (shipper.type, 'Y') <> 'V' and isNULL (shipper.type, 'Y') <> 'T' and
						shipper_detail.qty_packed is not null and
						shipper.date_shipped >= @Period1BeginDT and
						shipper.date_shipped< @Period1EndDT
				group by	part_original
				) a on PartList.part = a.part_original

left join
				(	Select	part_original,
							sum(qty_packed) as quantity,
							sum(qty_packed*alternate_price) as ExtendedSales
					from		shipper_detail 
					join		shipper  on shipper_detail.shipper = shipper.id
					where	isNULL (shipper.type, 'Y') <> 'V' and isNULL (shipper.type, 'Y') <> 'T' and
							shipper_detail.qty_packed is not null and
							shipper.date_shipped >= @Period2BeginDT and
							shipper.date_shipped< @Period2EndDT
					group by	part_original) b on PartList.part = b.part_original

left join historicaldata.dbo.part_historical_daily ph1 on PartList.part  = ph1.part and ph1.time_stamp = @ph_time1
left join historicaldata.dbo.part_historical_daily ph2 on PartList.part  = ph2.part and ph2.time_stamp = @ph_time2
left join historicaldata.dbo.part_standard_historical_daily psh1 on PartList.part  = psh1.part and psh1.time_stamp = @psh_time1
left join historicaldata.dbo.part_standard_historical_daily psh2 on PartList.part = psh2.part and psh2.time_stamp = @psh_time2

left join (Select  part,
						std_hours 
			from	eeiuser.acctg_inv_std_hours
			where fiscal_year = @fiscal_year1 and period = @period1 	) sh1 on PartList.part = sh1.part

left join (Select  part,
			std_hours 
			from	eeiuser.acctg_inv_std_hours
			where fiscal_year = @fiscal_year2 and period = @period2 	) sh2 on PartList.part = sh2.part

left join #EEHMC1 eehps on PartList.part = eehps.eeh_part1
left join #EEHMC2 eehps2 on PartList.part = eehps2.eeh_part2

where	(isnull(a.quantity,0)+isnull(b.quantity,0))>0
order by	PartList.part 

--option(recompile)

end

GO
