SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_inv_comparison2]	(
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
			@psh_time2 datetime

--select @fiscal_year2 = (case when @period1 = 1 then @fiscal_year1-1 else @fiscal_year1 end);
--select @period2 = (case when @period1 = 1 then 12 else @period1-1 end);
select		@oh_time1 = (select max(time_stamp) from object_historical where fiscal_year = @fiscal_year1 and period = @period1 and reason = 'MONTH END');
select		@ph_time1 = (select max(time_stamp) from part_historical where fiscal_year = @fiscal_year1 and period = @period1);
select		@psh_time1 = (select max(time_stamp) from part_standard_historical where fiscal_year = @fiscal_year1 and period = @period1);
select		@oh_time2 = (select max(time_stamp) from object_historical where fiscal_year = @fiscal_year2 and period = @period2 and reason = 'MONTH END');
select		@ph_time2 = (select max(time_stamp) from part_historical where fiscal_year = @fiscal_year2 and period = @period2);
select		@psh_time2 = (select max(time_stamp) from part_standard_historical where fiscal_year = @fiscal_year2 and period = @period2)

select isnull(a.part,b.part)as part_number,* from
(select oh.part, sum(oh.quantity) as quantity, avg(psh.frozen_material_cum) as material_cum, sum(oh.quantity*psh.frozen_material_cum)as ext_material_cum, avg(sh.std_hours) as std_hours, avg(sh.std_hours*1.0) as absorbed_labor_cum, sum(oh.quantity*sh.std_hours*1.0) as ext_absorbed_labor_cum, avg(sh.std_hours*1.47*1.0) as absorbed_burden_cum, sum(oh.quantity*sh.std_hours*1.47*1.0) as ext_absorbed_burden_cum from object_historical oh left join part_historical ph on oh.part = ph.part left join part_standard_historical psh on oh.part = psh.part left join eeiuser.acctg_inv_std_hours sh on oh.part = sh.part where oh.time_stamp = @oh_time1 and ph.time_stamp = @ph_time1 and psh.time_stamp = @psh_time1 group by oh.part) a
full outer join
(select oh.part, sum(oh.quantity) as quantity, avg(psh.frozen_material_cum) as material_cum, sum(oh.quantity*psh.frozen_material_cum) as ext_material_cum, avg(sh.std_hours) as std_hours, avg(sh.std_hours*1.0) as absorbed_labor_cum, sum(oh.quantity*sh.std_hours*1.0) as ext_absorbed_labor_cum, avg(sh.std_hours*1.47*1.0) as absorbed_burden_cum, sum(oh.quantity*sh.std_hours*1.47*1.0) as ext_absorbed_burden_cum from object_historical oh left join part_historical ph on oh.part = ph.part left join part_standard_historical psh on oh.part = psh.part left join eeiuser.acctg_inv_std_hours sh on oh.part = sh.part where oh.time_stamp = @oh_time2 and ph.time_stamp = @ph_time2 and psh.time_stamp = @psh_time2 group by oh.part) b
on a.part = b.part
order by isnull(a.part,b.part)

end


GO
