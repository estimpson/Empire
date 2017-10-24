SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[eeisp_rpt_COST_changes_ALABAMA] (@StartDate datetime, @EndDate datetime)
as
Begin

declare	@beginDT datetime,
		@endDT datetime,
		@datespan int

set		@endDT = FT.fn_TruncDate ('dd', @EndDate)+1




set	@beginDT = (Select dateadd(dd, 0, @StartDate))
set	@beginDT = FT.fn_TruncDate ('dd', @beginDT)

set	@datespan =  datediff(dd, @beginDT, @endDT)

select			EntryDT as DT1,
				(EntryDT + 1) as DT2,
				part,
				isNULL((Select max(material_cum) from part_standard_historical_daily where reason = 'Daily' and part = part.part and time_stamp between EntryDT and EntryDT + 1 and part.class = 'P'),0) as MaterialCum,
				isNULL((Select max(material_cum) from part_standard_historical_daily where reason = 'Daily' and part = part.part and time_stamp between EntryDT and EntryDT + 1 and part.class in( 'M','I')),0) as CostCum,
				isNULL((Select sum(std_quantity) from audit_trail where part = part.part and date_stamp between EntryDT and EntryDT + 1 and type = 'J'),0) JobComplete,
				isNULL((Select sum(std_quantity) from audit_trail where part = part.part and date_stamp between EntryDT and EntryDT + 1 and type = 'M'),0) MaterialIssues,
				isNULL((Select sum(std_quantity) from audit_trail where part = part.part and date_stamp between EntryDT and EntryDT + 1 and type = 'D'),0) Deletes,
				isNULL((Select sum(std_quantity) from audit_trail where part = part.part and date_stamp between EntryDT and EntryDT + 1 and type = 'S'),0) ShipOuts,
				isNULL((Select sum(std_quantity) from audit_trail where part = part.part and date_stamp between EntryDT and EntryDT + 1 and type = 'R'),0)Receipts,
				isNULL((Select sum(std_quantity) from audit_trail where part = part.part and date_stamp between EntryDT and EntryDT + 1 and type = 'Q' and to_loc= 'S'),0) QualityScrap
				
				
				
from				[FT].[fn_Calendar] (@beginDT, null, 'dd', 1, @datespan)
cross join			part
where			part like 'NAL0040%' or part in ( '3157A', 'G930 201-02')
eND
GO
