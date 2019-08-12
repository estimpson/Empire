SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--exec [EEIUser].[acctg_csm_vw_Select_Flat_Sales_Forecast]


CREATE procedure [EEIUser].[acctg_csm_vw_Select_Flat_Sales_Forecast]
as
begin



declare  @temp1 table
([base_part] varchar(1000), [empire_application] varchar(500), [program] varchar(50), [vehicle] varchar(100), [sop] date, [eop] date, [cal_19_totaldemand] decimal(18,6), [cal_20_totaldemand] decimal(18,6), [cal_21_totaldemand] decimal(18,6))


insert into @temp1
	select base_part, empire_application, program, vehicle, sop, eop, cal_19_totaldemand, cal_20_totaldemand, cal_21_totaldemand
	from eeiuser.acctg_csm_vw_select_sales_forecast


--	select * from @temp1

--2. 
declare	@base_part varchar(1000),
		@program varchar(1000),
		@vehicle varchar(1000)

declare @FlatMSF table (
		
	base_part varchar(1000),
	program varchar(1000),
	vehicle	varchar(1000)
					)

declare	base_part_list cursor local for
select distinct base_part from @temp1
open	base_part_list 
fetch	base_part_list into @base_part


While	@@fetch_status = 0
Begin	
Select  @program = ''
Select	@vehicle = ''

Select	@program= @program + program +', '
from		@temp1 where base_part = @base_part
group by	program

Select	@vehicle= @vehicle + vehicle +', '
from		@temp1 where base_part = @base_part
group by	vehicle


insert	@FlatMSF
Select	@base_part,
		@program,
		@vehicle
		
fetch	base_part_list into	@base_part

end


select a.base_part, b.empire_application,	(case when a.program is null then '' else left(a.program, len(a.program)-1) end) as program, 
											(case when a.vehicle is null then '' else left(a.vehicle, len(a.vehicle)-1) end) as vehicle, 
											b.sop, b.eop, b.eau_2019, b.eau_2020, b.eau_2021
from @FLATMSF a 
left join (	select base_part, empire_application, min (sop) as sop, min (eop) as eop, sum(cal_19_totaldemand) as EAU_2019, sum(cal_20_totaldemand) as EAU_2020, sum(cal_21_totaldemand) as EAU_2021
			from @temp1 
			group by base_part, empire_application
		  ) b on a.base_part = b.base_part



end
GO
