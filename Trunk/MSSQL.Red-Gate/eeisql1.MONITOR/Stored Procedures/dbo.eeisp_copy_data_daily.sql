SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure
[dbo].[eeisp_copy_data_daily]

as
begin

-- Set the RUNDATE
declare @rundate datetime;
select @rundate = dateadd (second, datediff (second, '2008-01-01', getdate()), '2008-01-01')

-- Calculate if the RUNDATE is the last day of the month
declare @endofmonthdate datetime
select @endofmonthdate = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@runDate)+1,0))

-- Set appropriate values for reason and isendofmonth
declare @reason varchar(25)
select @reason = (case when datediff(d,@rundate,@endofmonthdate) = 0 then 'MONTH END' else 'DAILY' end)

declare @isendofmonth varchar(1)
select @isendofmonth = (case when datediff(d,@rundate,@endofmonthdate) = 0 then 'Y' else 'N' end)

-- ENSURE transfer price is rounded to 2 decimals
update ps set material = round(material,2), material_cum = round(material_cum,2), cost = round(material,2)+labor+burden+other, cost_cum = round(material_cum,2)+labor_cum+burden_cum+other_cum from part_standard ps join part p on ps.part = p.part where material_cum-round(material_cum,2) <> 0 and p.type = 'F' and p.product_line not in ('BULBED ES3 COMPONENTS','OUTSOURCED ES3 COMPONENTS','BULBED WIRE HARN - EEH','WIRE HARN - EEI') and material_cum > .01 


-- Fix the audit_trail for RMAs.  Their posted flag is written as 'Y' and we need to update it to 'N' in order for RMAs to import into Empower
update audit_trail set posted = 'N' where type = 'U' and date_stamp >= convert(varchar(50),datepart(mm,@rundate))+'-'+convert(varchar(50),datepart(dd,@rundate))+'-'+convert(varchar(50),datepart(yyyy,@rundate))

-- Copy the part table
insert into [HistoricalData].dbo.part_historical_daily
(
	   [time_stamp]
	  ,[fiscal_year]
	  ,[period]
	  ,[reason]
	  ,[part]
      ,[name]
      ,[cross_ref]
      ,[class]
      ,[type]
      ,[commodity]
      ,[group_technology]
      ,[quality_alert]
      ,[description_short]
      ,[description_long]
      ,[serial_type]
      ,[product_line]
      ,[configuration]
      ,[standard_cost]
      ,[user_defined_1]
      ,[user_defined_2]
      ,[flag]
      ,[engineering_level]
      ,[drawing_number]
      ,[gl_account_code]
      ,[eng_effective_date]
      ,[low_level_code]
	  ,[MonthEnd] 
)
    select 
	   @rundate
	  ,convert(varchar(5),datepart(YYYY, @rundate))
	  ,convert(smallint,datepart(MM, @rundate))
	  ,@reason
	  ,[part]
      ,[name]
      ,[cross_ref]
      ,[class]
      ,[type]
      ,[commodity]
      ,[group_technology]
      ,[quality_alert]
      ,[description_short]
      ,[description_long]
      ,[serial_type]
      ,[product_line]
      ,[configuration]
      ,[standard_cost]
      ,[user_defined_1]
      ,[user_defined_2]
      ,[flag]
      ,[engineering_level]
      ,[drawing_number]
      ,[gl_account_code]
      ,[eng_effective_date]
      ,[low_level_code]
	  ,@IsEndofMonth
	from part

-- copy the part_standard table
insert into [HistoricalData].dbo.part_standard_historical_daily
(	   
	   [time_stamp]
	  ,[fiscal_year]
	  ,[period]
      ,[reason]
      ,[part]
      ,[price]
      ,[cost]
      ,[account_number]
      ,[material]
      ,[labor]
      ,[burden]
      ,[other]
      ,[cost_cum]
      ,[material_cum]
      ,[burden_cum]
      ,[other_cum]
      ,[labor_cum]
      ,[flag]
      ,[premium]
      ,[qtd_cost]
      ,[qtd_material]
      ,[qtd_labor]
      ,[qtd_burden]
      ,[qtd_other]
      ,[qtd_cost_cum]
      ,[qtd_material_cum]
      ,[qtd_labor_cum]
      ,[qtd_burden_cum]
      ,[qtd_other_cum]
      ,[planned_cost]
      ,[planned_material]
      ,[planned_labor]
      ,[planned_burden]
      ,[planned_other]
      ,[planned_cost_cum]
      ,[planned_material_cum]
      ,[planned_labor_cum]
      ,[planned_burden_cum]
      ,[planned_other_cum]
      ,[frozen_cost]
      ,[frozen_material]
      ,[frozen_burden]
      ,[frozen_labor]
      ,[frozen_other]
      ,[frozen_cost_cum]
      ,[frozen_material_cum]
      ,[frozen_burden_cum]
      ,[frozen_labor_cum]
      ,[frozen_other_cum]
      ,[cost_changed_date]
      ,[qtd_changed_date]
      ,[planned_changed_date]
      ,[frozen_changed_date]
	  ,[MonthEnd]
)

    select
	   @rundate
	  ,convert(varchar(5),datepart(YYYY, @rundate))
	  ,convert(smallint,datepart(MM, @rundate))
      ,@reason
      ,[part]
      ,[price]
      ,[cost]
      ,[account_number]
      ,[material]
      ,[labor]
      ,[burden]
      ,[other]
      ,[cost_cum]
      ,[material_cum]
      ,[burden_cum]
      ,[other_cum]
      ,[labor_cum]
      ,[flag]
      ,[premium]
      ,[qtd_cost]
      ,[qtd_material]
      ,[qtd_labor]
      ,[qtd_burden]
      ,[qtd_other]
      ,[qtd_cost_cum]
      ,[qtd_material_cum]
      ,[qtd_labor_cum]
      ,[qtd_burden_cum]
      ,[qtd_other_cum]
      ,[planned_cost]
      ,[planned_material]
      ,[planned_labor]
      ,[planned_burden]
      ,[planned_other]
      ,[planned_cost_cum]
      ,[planned_material_cum]
      ,[planned_labor_cum]
      ,[planned_burden_cum]
      ,[planned_other_cum]
      ,[frozen_cost]
      ,[frozen_material]
      ,[frozen_burden]
      ,[frozen_labor]
      ,[frozen_other]
      ,[frozen_cost_cum]
      ,[frozen_material_cum]
      ,[frozen_burden_cum]
      ,[frozen_labor_cum]
      ,[frozen_other_cum]
      ,[cost_changed_date]
      ,[qtd_changed_date]
      ,[planned_changed_date]
      ,[frozen_changed_date]
	  ,@IsEndofMonth
	from part_standard

-- copy the object table
insert [HistoricalData].dbo.object_historical_daily
(
	   [time_stamp]
      ,[fiscal_year]
	  ,[period]
      ,[reason]
      ,[serial]
      ,[part]
      ,[location]
      ,[last_date]
      ,[unit_measure]
      ,[operator]
      ,[status]
      ,[destination]
      ,[station]
      ,[origin]
      ,[cost]
      ,[weight]
      ,[parent_serial]
      ,[note]
      ,[quantity]
      ,[last_time]
      ,[date_due]
      ,[customer]
      ,[sequence]
      ,[shipper]
      ,[lot]
      ,[type]
      ,[po_number]
      ,[name]
      ,[plant]
      ,[start_date]
      ,[std_quantity]
      ,[package_type]
      ,[field1]
      ,[field2]
      ,[custom1]
      ,[custom2]
      ,[custom3]
      ,[custom4]
      ,[custom5]
      ,[show_on_shipper]
      ,[tare_weight]
      ,[suffix]
      ,[std_cost]
      ,[user_defined_status]
      ,[workorder]
      ,[engineering_level]
      ,[kanban_number]
      ,[dimension_qty_string]
      ,[dim_qty_string_other]
      ,[varying_dimension_code]
      ,[posted]
      ,[Monthend]
	  ,ObjectBirthday
)
	select
	   @rundate
      ,convert(varchar(5),datepart(YYYY, @rundate))
	  ,convert(smallint,datepart(MM, @rundate))
      ,@reason
      ,[serial]
      ,[part]
      ,[location]
      ,[last_date]
      ,[unit_measure]
      ,[operator]
      ,[status]
      ,[destination]
      ,[station]
      ,[origin]
      ,[cost]
      ,[weight]
      ,[parent_serial]
      ,[note]
      ,[quantity]
      ,[last_time]
      ,[date_due]
      ,[customer]
      ,[sequence]
      ,[shipper]
      ,[lot]
      ,[type]
      ,[po_number]
      ,[name]
      ,[plant]
      ,[start_date]
      ,[std_quantity]
      ,[package_type]
      ,[field1]
      ,[field2]
      ,[custom1]
      ,[custom2]
      ,[custom3]
      ,[custom4]
      ,[custom5]
      ,[show_on_shipper]
      ,[tare_weight]
      ,[suffix]
      ,[std_cost]
      ,[user_defined_status]
      ,[workorder]
      ,[engineering_level]
      ,[kanban_number]
      ,[dimension_qty_string]
      ,[dim_qty_string_other]
      ,[varying_dimension_code]
      ,[posted]
      ,@IsEndofMonth
	  ,ObjectBirthday
	from object





-- copy the eeh part_standard table
exec ftsp_get_EEHPartStandard






end



GO
