SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[eeisp_rpt_DSA_EEIMaterialCum_EEHMaterialCum] (@FromDate Datetime, @ThroughDate Datetime)
--eeisp_rpt_DSA_EEIMaterialCum_EEHMaterialCum  '2008-07-01', '2008-07-31'
as
begin

declare	@FirstDT datetime,
		@EndDT datetime,
		@TimeSpan int

set @FirstDT = FT.fn_TruncDate ('dd', @FromDate) 
--Select	@FirstDT
Set @EndDT = FT.fn_TruncDate ('dd', @ThroughDate)+1 
--Select @EndDT
set	@TimeSpan = (Select datediff(dd, @FirstDT, @EndDT))

Declare	@EEHShipments Table(
		part			varchar(25),
		QtyShipped	Numeric(20,6),
		DateShipped	Datetime) 

Insert	@EEHShipments	
		
Select			part_original,
				sum(qty_packed) QTYShipped,
				FT.fn_TruncDate ('dd', date_shipped)
		from		[EEHSQL1].[EEH].[dbo].shipper_detail
		where	date_shipped >= @FirstDT and
				date_shipped < @EndDT and
				part_original like '%DSA%'
		group by	part_original,
				FT.fn_TruncDate ('dd', date_shipped)

Declare	@EEHPartStandard Table(
		part			varchar(25),
		EEHMaterialCum	Numeric(20,6),
		EEHTimeStamp	Datetime) 

Insert	@EEHPartStandard

Select			part,
				isNULL(max(material_cum),0) EEHmaterialCUM,
				FT.fn_TruncDate ('dd', time_stamp) EEHtimeStamp
		from		[EEHSQL1].[EEH].[dbo].part_standard_historical_daily
		where	time_stamp >= @FirstDT and
				time_stamp < @EndDT and
				part like '%DSA%'
		group by	part,
				FT.fn_TruncDate ('dd', time_stamp)

Declare	@EEIPartStandard Table(
		part			varchar(25),
		EEIMaterialCum	Numeric(20,6),
		EEITimeStamp	Datetime) 

Insert	@EEIPartStandard

Select			part,
				isNULL(max(material_cum),0) EEImaterialCUM,
				FT.fn_TruncDate ('dd', time_stamp) EEItimeStamp
		from		part_standard_historical_daily
		where	time_stamp >= @FirstDT and
				time_stamp < @EndDT and
				part like '%DSA%'
		group by	part,
				FT.fn_TruncDate ('dd', time_stamp)

Select	EEHShipments.Part,
		DateShipped,
		EEIMaterialCum,
		EEHMaterialCum,
		QtyShipped
		 from 		
	(	Select	part 
		from		part
		where	part like '%DSA%'
	) Part cross Join
	(	select	BeginDT = EntryDT,
				EndDT = EntryDT + 1
		from		[FT].[fn_Calendar] (@FirstDT, null, 'dd', 1, @TimeSpan)
	) Calendar left join	@EEIPartStandard 	EEIPartStandard on Part.Part = EEIPartStandard.Part and EEITimeStamp >= BeginDT and EEITimeStamp < EndDT
			left join	@EEHPartStandard 	EEHPartStandard on Part.Part = EEHPartStandard.Part and EEHTimeStamp >= BeginDT and EEHTimeStamp < EndDT
			left join		@EEHShipments		EEHShipments on Part.Part = EEHShipments.Part and DateShipped >= BeginDT and DateShipped < EndDT
Where	EEHShipments.Part is not NULL
order by 1,2

End

GO
