SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--exec eeiuser.acctg_csm_flatten_programs


CREATE procedure [EEIUser].[acctg_csm_new_vehicle_launches_tail_lamp] (@year varchar(4))
as
begin

-- exec eeiuser.acctg_csm_new_vehicle_launches_tail_lamp '2019'

--1. Get Data 
--declare @year varchar(4) = '2019'

declare  @temp1 table
([program_mnemonic] varchar(1000), [program] varchar(50), [vehicle] varchar(100), [supplier_group] varchar(100), [supplier] varchar(100))

insert into @temp1
	select  ([VP: Program]+' '+[VP: Production Brand]+ ' '+[VP: Production Nameplate]) as program_mnemonic,
			[VP: Program], 
			([VP: Production Brand]+' '+[VP: Production Nameplate]) as vehicle, 
			[Tail Lamp Supplier Group], 
			[Tail Lamp Supplier]
	from eeiuser.acctg_csm_study_tail_lamp
	where release_id = (select [dbo].[fn_ReturnLatestCSMTailLampRelease] () )

--2. 
declare	@program_mnemonic varchar(1000),
		@program varchar(1000),
		@vehicle varchar(1000),
		@supplier_group varchar(1000),
		@supplier varchar(1000)

declare @FlatSupplier table (
		
	program_mnemonic varchar(1000),
	program varchar(1000),
	vehicle	varchar(1000),
	supplier_group varchar(1000),
	supplier varchar(1000))

declare	program_mnemonic_list cursor local for
select distinct program_mnemonic from @temp1
open	program_mnemonic_list 
fetch	program_mnemonic_list into @program_mnemonic


While	@@fetch_status = 0
Begin	
Select  @program = ''
Select	@vehicle = ''
Select	@supplier_group = ''
Select  @supplier = ''

Select	@program= @program + program+', '
from		@temp1 where program_mnemonic = @program_mnemonic
group by	program

Select	@vehicle= @vehicle + vehicle+', '
from		@temp1 where program_mnemonic = @program_mnemonic
group by	vehicle

Select	@supplier_group = @supplier_group + supplier_group+', '
from		@temp1 where program_mnemonic = @program_mnemonic
group by	supplier_group

Select	@supplier = @supplier + supplier +', '
from		@temp1 where program_mnemonic = @program_mnemonic
group by	supplier


insert	@FlatSupplier
Select	@program_mnemonic,
		@program,
		@vehicle,
		@supplier_group,
		@Supplier
		
fetch	program_mnemonic_list into	@program_mnemonic

end


create table #flatsuppliers2
(program_mnemonic varchar(1000), program varchar(1000), vehicle varchar(1000), supplier_group varchar(1000), supplier varchar(1000))

insert	#FlatSuppliers2
Select	program_mnemonic,
		left(program,datalength(program)-2) program,
		left(vehicle,datalength(vehicle)-2) vehicle,
		left(supplier_group,datalength(supplier_group)-2) supplier_group,
		left(supplier,datalength(supplier)-2) supplier
	
from		@FlatSupplier

--declare @year varchar(4)
declare @column_name varchar(50)

--select @year = '2019'
select @column_name = '['+(@year)+' Vehicle EAU]'



declare @sql nvarchar(max)
set @sql = '
select	a.manufacturer,
		a.program,
		a.vehicle,
		a.sop,
		a.[2019 Vehicle EAU],
		a.[2020 Vehicle EAU],	
		a.[2021 Vehicle EAU],
		a.[2022 Vehicle EAU],
		a.[2023 Vehicle EAU],
		a.[2024 Vehicle EAU],		
		a.[2025 Vehicle EAU],
		a.[2026 Vehicle EAU],
		a.[2019 Vehicle EAU]*2 as [2019 Tail Lamp EAU],
		a.[2020 Vehicle EAU]*2 as [2020 Tail Lamp EAU],
		a.[2021 Vehicle EAU]*2 as [2021 Tail Lamp EAU],
		a.[2022 Vehicle EAU]*2 as [2022 Tail Lamp EAU],
		a.[2023 Vehicle EAU]*2 as [2023 Tail Lamp EAU],
		a.[2024 Vehicle EAU]*2 as [2024 Tail Lamp EAU],
		a.[2025 Vehicle EAU]*2 as [2025 Tail Lamp EAU],
		a.[2026 Vehicle EAU]*2 as [2026 Tail Lamp EAU],
		d.[empire_volume_2019] as [2019 Empire Volume],
		d.[empire_volume_2020] as [2020 Empire Volume],
		d.[empire_volume_2021] as [2021 Empire Volume],
		d.[empire_volume_2022] as [2022 Empire Volume],
		d.[empire_volume_2023] as [2023 Empire Volume],
		d.[empire_volume_2024] as [2024 Empire Volume],
		d.[empire_volume_2025] as [2025 Empire Volume],
		d.[empire_volume_2026] as [2026 Empire Volume],
		d.[empire_sales_2019] as [2019 Empire Sales],
		d.[empire_sales_2020] as [2020 Empire Sales],
		d.[empire_sales_2021] as [2021 Empire Sales],
		d.[empire_sales_2022] as [2022 Empire Sales],
		d.[empire_sales_2023] as [2023 Empire Sales],
		d.[empire_sales_2024] as [2024 Empire Sales],
		d.[empire_sales_2025] as [2025 Empire Sales],
		d.[empire_sales_2026] as [2026 Empire Sales]
from
(	select 
	manufacturer,
	(brand+'' ''+nameplate) as vehicle, 
	program, 
	min(sop) as sop, 
	sum([CY 2019]) as [2019 Vehicle EAU],
	sum([CY 2020]) as [2020 Vehicle EAU],
	sum([CY 2021]) as [2021 Vehicle EAU],
	sum([CY 2022]) as [2022 Vehicle EAU],
	sum([CY 2023]) as [2023 Vehicle EAU],
	sum([CY 2024]) as [2024 Vehicle EAU],
	sum([CY 2025]) as [2025 Vehicle EAU],
	sum([CY 2026]) as [2026 Vehicle EAU]
	from eeiuser.acctg_csm_naihs a 
	where release_id = (select [dbo].[fn_ReturnLatestCSMRelease] (''CSM''))  and region = ''North America'' and version = ''CSM'' 
	group by manufacturer, program, brand+'' ''+nameplate) a
left join
(	select program, vehicle, supplier_group, supplier from  #flatsuppliers2  ) b
 on a.vehicle = b.vehicle and a.program = b.program
left join 
(	select	program
			,vehicle
			,round(sum(cal_19_sales),0) as [empire_sales_2019]
			,round(sum(cal_20_sales),0) as [empire_sales_2020]
			,round(sum(cal_21_sales),0) as [empire_sales_2021]
			,round(sum(cal_22_sales),0) as [empire_sales_2022]
			,round(sum(cal_23_sales),0) as [empire_sales_2023]
			,round(sum(cal_24_sales),0) as [empire_sales_2024]
			,round(sum(cal_25_sales),0) as [empire_sales_2025]
			,round(sum(cal_26_sales),0) as [empire_sales_2026]
			,round(sum(cal_19_Totaldemand),0) as [empire_volume_2019]
			,round(sum(cal_20_Totaldemand),0) as [empire_volume_2020]
			,round(sum(cal_21_Totaldemand),0) as [empire_volume_2021]
			,round(sum(Cal_22_Totaldemand),0) as [empire_volume_2022]
			,round(sum(Cal_23_Totaldemand),0) as [empire_volume_2023]
			,round(sum(Cal_24_Totaldemand),0) as [empire_volume_2024]
			,round(sum(Cal_25_Totaldemand),0) as [empire_volume_2025]
			,round(sum(Cal_26_Totaldemand),0) as [empire_volume_2026]
	 from	eeiuser.acctg_csm_vw_select_sales_forecast
	 where	empire_market_subsegment = ''Tail Lamp''
	 group by program, vehicle
) d on a.vehicle = d.vehicle and a.program = d.program

where '+ @column_name +' > 0 
	and datepart(yyyy,[SOP]) = '+@year+'
order by a.SOP, a.[2022 Vehicle EAU] desc'


exec (@sql)


end
GO
