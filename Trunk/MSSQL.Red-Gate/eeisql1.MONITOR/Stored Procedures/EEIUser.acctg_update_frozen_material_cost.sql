SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_update_frozen_material_cost] @fiscalyear int, @month int
as


--1. For testing the procedure 

-- exec eeiuser.acctg_update_frozen_material_cost 2018, 9

--declare @fiscalyear int
--select @fiscalyear = 2018

--declare @month int
--select @month = 9


--2. Get all of our dates for use in procedure

declare @adj_year int = (case when @month = 1 then @fiscalyear-1 else @fiscalyear end)
--select @adj_year

declare @first_day_of_next_month date = dateadd(m, 1, (convert(varchar(4),@fiscalyear)+'-'+convert(varchar(2),@month)+'-01'))
--select @first_day_of_next_month

declare @last_day_of_selected_month date = dateadd(d,-1, @first_day_of_next_month)
--select @last_day_of_selected_month

declare @first_day_of_selected_month date = dateadd(m, -1, @first_day_of_next_month)
--select @first_day_of_selected_month 


--3. Get the material_cum from EEH

declare @temp table (part varchar(25), material_cum decimal(18,6))
insert into @temp
select part, material_cum from [eehsql1].[HistoricalData].dbo.part_standard_historical 
where time_stamp >= @last_day_of_selected_month and time_stamp < @first_day_of_next_month and reason = 'MONTH END'


--4. Update missing frozen_material_cums in EEI

update 	eeips 
set	eeips.frozen_material_cum = eehpsh.material_cum 
from	part_standard eeips
left join @temp eehpsh
	on eeips.part = eehpsh.part 
where	ISNULL(eeips.frozen_material_cum,0)=0

update	eeipsh 
set	eeipsh.frozen_material_cum = eehpsh.material_cum 
from	HistoricalData.dbo.part_standard_historical eeipsh 
left join @temp eehpsh 
	on eeipsh.part = eehpsh.part 
where	eeipsh.time_stamp >= @first_day_of_selected_month
	and ISNULL(eeipsh.frozen_material_cum,0)=0

update	eeipshd 
set	eeipshd.frozen_material_cum = eehpsh.material_cum 
from	HistoricalData.dbo.part_standard_historical_daily eeipshd
left join @temp eehpsh
	on eeipshd.part = eehpsh.part 
where	eeipshd.time_stamp >= @first_day_of_selected_month
	and ISNULL(eeipshd.frozen_material_cum,0)=0


select 'Frozen Material Cost has been updated'


GO
