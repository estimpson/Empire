SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--exec eeiuser.acctg_inv_comparison 2008,7,2008,8

CREATE procedure [EEIUser].[acctg_inv_comparison]	(
											@fiscal_year1 int,					
											@period1 int,
											@fiscal_year2 int,
											@period2 int
										)
as
begin
declare		@PartList  table (
			Part varchar(25), 
			primary key (Part))


declare		@oh_time1 datetime,
			@ph_time1 datetime,
			@psh_time1 datetime, 
			@oh_time2 datetime, 
			@ph_time2 datetime, 
			@psh_time2 datetime,
			@labor_rate decimal(20,6),
			@burden_rate decimal(20,6)

--select @fiscal_year2 = (case when @period1 = 1 then @fiscal_year1-1 else @fiscal_year1 end);
--select @period2 = (case when @period1 = 1 then 12 else @period1-1 end);

Insert		@partList
Select		part
from			historicaldata.dbo.part_historical 
where		fiscal_year = @fiscal_year1 and period = @period1
UNION
Select		part
from			historicaldata.dbo.part_historical 
where		fiscal_year = @fiscal_year2 and period = @period2

--select		@oh_time1 = (select max(time_stamp) from object_historical where fiscal_year = '2011' and period = 9 and reason = 'MONTH END');

select		@oh_time1 = (select max(time_stamp) from historicaldata.dbo.object_historical where fiscal_year = @fiscal_year1 and period = @period1 and reason = 'MONTH END');
select		@ph_time1 = (select max(time_stamp) from historicaldata.dbo.part_historical where fiscal_year = @fiscal_year1 and period = @period1);
select		@psh_time1 = (select max(time_stamp) from historicaldata.dbo.part_standard_historical where fiscal_year = @fiscal_year1 and period = @period1);
select		@oh_time2 = (select max(time_stamp) from historicaldata.dbo.object_historical where fiscal_year = @fiscal_year2 and period = @period2 and reason = 'MONTH END');
select		@ph_time2 = (select max(time_stamp) from historicaldata.dbo.part_historical where fiscal_year = @fiscal_year2 and period = @period2);
select		@psh_time2 = (select max(time_stamp) from historicaldata.dbo.part_standard_historical where fiscal_year = @fiscal_year2 and period = @period2);
select		@labor_rate = 2.11795
select		@burden_rate = 1.475

select		PartList.Part as part_number, 
			coalesce(nullif(ph1.product_line,''), nullif(ph2.product_line,''), 'No Product Line') as product_line,
			coalesce(nullif(ph1.type,''), nullif(ph2.type,''), 'No Type') as type,
			isnull(a.quantity,0) as quantity1, 
			isnull(b.quantity,0) as quantity2,	
			isnull(a.quantity,0)-isnull(b.quantity,0) as quantity_change,
			ph1.product_line as product_line1,
			ph2.product_line as product_line2,
			(case when ph1.product_line = ph2.product_line then 'false' else 'true' end) as product_line_change,
			ph1.type as type1,
			ph2.type as type2,
			(case when ph1.type = ph2.type then 'false' else 'true' end) as type_change,
			ISNULL(psh1.price,0) as price1,
			ISNULL(psh2.price,0) as price2,
			ISNULL(psh1.price,0)-ISNULL(psh2.price,0) as price_change,			
			(ISNULL(a.quantity,0)*ISNULL(psh1.price,0)) as ext_price1,
			(ISNULL(b.quantity,0)*ISNULL(psh2.price,0)) as ext_price2,
			((ISNULL(a.quantity,0)*ISNULL(psh1.price,0))-(ISNULL(b.quantity,0)*ISNULL(psh2.price,0))) as ext_price_change,
			ISNULL(psh1.material_cum,0) as material_cum1,
			(case when (ISNULL(psh2.material_cum,0)=0 and isnulL(b.quantity,0)=0) then psh1.material_cum else psh2.material_cum end) as material_cum2,
			ISNULL(psh1.material_cum,0)-ISNULL(psh2.material_cum,0) as material_cum_change,			
			(ISNULL(a.quantity,0)*ISNULL(psh1.material_cum,0)) as ext_material_cum1,
			(ISNULL(b.quantity,0)*ISNULL(psh2.material_cum,0)) as ext_material_cum2,
			((ISNULL(a.quantity,0)*ISNULL(psh1.material_cum,0))-(ISNULL(b.quantity,0)*ISNULL(psh2.material_cum,0))) as ext_material_cum_change,
			ISNULL(psh1.frozen_material_cum,0) as frozen_material_cum1,
			(case when (ISNULL(psh2.frozen_material_cum,0)=0 and isnull(b.quantity,0)=0) then psh1.frozen_material_cum else psh2.frozen_material_cum end) as frozen_material_cum2,
			(case when (isnull(psh2.frozen_material_cum,0)=0 and isnull(b.quantity,0)=0) then 0 else ISNULL(psh1.frozen_material_cum,0)-ISNULL(psh2.frozen_material_cum,0) end) as frozen_material_cum_change,
			(ISNULL(a.quantity,0)*ISNULL(psh1.frozen_material_cum,0)) as ext_frozen_material_cum1,
			(ISNULL(b.quantity,0)*ISNULL(psh2.frozen_material_cum,0)) as ext_frozen_material_cum2,
			((ISNULL(a.quantity,0)*ISNULL(psh1.frozen_material_cum,0))-(ISNULL(b.quantity,0)*ISNULL(psh2.frozen_material_cum,0))) as ext_frozen_material_cum_change,
			ISNULL(sh1.std_hours,0) as std_hours1,
			ISNULL(sh2.std_hours,0) as std_hours2,
			ISNULL(sh2.std_hours,0)-ISNULL(sh1.std_hours,0) as std_hours_change,
			(ISNULL(sh1.std_hours,0)*@labor_rate) as absorbed_labor_cum1,
			(ISNULL(sh2.std_hours,0)*@labor_rate) as absorbed_labor_cum2,
			(ISNULL(sh2.std_hours,0)*@labor_rate)-(ISNULL(sh1.std_hours,0)*@labor_rate) as absorbed_labor_cum_change,
			(ISNULL(a.quantity,0)*ISNULL(sh1.std_hours,0)*@labor_rate) as ext_absorbed_labor_cum1,
			(ISNULL(b.quantity,0)*ISNULL(sh2.std_hours,0)*@labor_rate) as ext_absorbed_labor_cum2,
			(ISNULL(a.quantity,0)*ISNULL(sh2.std_hours,0)*@labor_rate)-(ISNULL(b.quantity,0)*ISNULL(sh1.std_hours,0)*@labor_rate) as ext_absorbed_labor_cum_change,
			(ISNULL(a.quantity,0)*ISNULL(sh1.std_hours,0)*@labor_rate*@burden_rate) as ext_absorbed_burden_cum1,
			(ISNULL(b.quantity,0)*ISNULL(sh1.std_hours,0)*@labor_rate*@burden_rate) as ext_absorbed_burden_cum2,
			(ISNULL(a.quantity,0)*ISNULL(sh2.std_hours,0)*@labor_rate*@burden_rate)-(ISNULL(b.quantity,0)*ISNULL(sh1.std_hours,0)*@labor_rate*@burden_rate) as ext_absorbed_burden_cum_change



from			@partList PartList
left join	
(	select	oh1.part, 
			sum(oh1.quantity) as quantity 
	from		historicaldata.dbo.object_historical oh1 
	where	oh1.time_stamp = @oh_time1 
		and oh1.user_defined_status <> 'PRESTOCK'
	group by oh1.part) a on PartList.part = a.part
left join
(	select 	oh2.part, 
			sum(oh2.quantity) as quantity 
	from		historicaldata.dbo.object_historical oh2 
	where	oh2.time_stamp = @oh_time2 
		and oh2.user_defined_status <> 'PRESTOCK'
	group by oh2.part) b on PartList.part = b.part
left join historicaldata.dbo.part_historical ph1 on PartList.part  = ph1.part and ph1.time_stamp = @ph_time1
left join historicaldata.dbo.part_historical ph2 on PartList.part  = ph2.part and ph2.time_stamp = @ph_time2
left join historicaldata.dbo.part_standard_historical psh1 on PartList.part  = psh1.part and psh1.time_stamp = @psh_time1
left join historicaldata.dbo.part_standard_historical psh2 on PartList.part = psh2.part and psh2.time_stamp = @psh_time2
left join (Select  part,
			std_hours 
		from	eeiuser.acctg_inv_std_hours
		where fiscal_year = @fiscal_year1 and period = @period1 	) sh1 on PartList.part = sh1.part
left join (Select  part,
			std_hours 
		from	eeiuser.acctg_inv_std_hours
		where fiscal_year = @fiscal_year2 and period = @period2 	) sh2 on PartList.part = sh2.part
where	isnull(a.quantity,0)+isnull(b.quantity,0)>0
order by	PartList.part 


end


GO
