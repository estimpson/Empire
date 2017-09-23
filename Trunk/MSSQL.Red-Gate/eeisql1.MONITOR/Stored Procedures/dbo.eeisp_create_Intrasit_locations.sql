SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure	[dbo].[eeisp_create_Intrasit_locations]
as begin
Declare	@weekNo integer,
		@plant	varchar(3)

declare @LocationWeeks table
(	Location	varchar(50) not null,
	Plant	varchar(10) not null
primary key nonclustered (Location))

Select @WeekNo=1

DECLARE Plant CURSOR FOR 
SELECT substring(destination,1,3)
FROM destination
WHERE isnull(nullif(region_code,''), 'XXX') = 'INTERNAL'
ORDER BY destination

OPEN Plant

FETCH NEXT FROM Plant
INTO @plant

WHILE @@FETCH_STATUS = 0
BEGIN

Select @weekNo=1

while @WeekNo <= 52
Begin
Insert	@LocationWeeks
Select	'T1'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'SU', 'TRAN-'+@plant
union
Select	'T1'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'MO', 'TRAN-'+@plant
union
Select	'T1'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'TU', 'TRAN-'+@plant
union
Select	'T1'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'WD', 'TRAN-'+@plant
union
Select	'T1'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'TH', 'TRAN-'+@plant
union
Select	'T1'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'FR', 'TRAN-'+@plant
union
Select	'T1'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'SA', 'TRAN-'+@plant
union
Select	'T2'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'SU', 'TRAN-'+@plant
union
Select	'T2'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'MO', 'TRAN-'+@plant
union
Select	'T2'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'TU', 'TRAN-'+@plant
union
Select	'T2'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'WD', 'TRAN-'+@plant
union
Select	'T2'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'TH', 'TRAN-'+@plant
union
Select	'T2'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'FR', 'TRAN-'+@plant
union
Select	'T2'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'SA', 'TRAN-'+@plant
union
Select	'T3'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'SU', 'TRAN-'+@plant
union
Select	'T3'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'MO', 'TRAN-'+@plant
union
Select	'T3'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'TU', 'TRAN-'+@plant
union
Select	'T3'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'WD', 'TRAN-'+@plant
union
Select	'T3'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'TH', 'TRAN-'+@plant
union
Select	'T3'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'FR', 'TRAN-'+@plant
union
Select	'T3'+ @plant + (CASE WHEN @WeekNo<10 THEN ('0'+ convert(varchar(2), @weekNo)) ELSE convert(varchar(2), @weekNo) END)+'SA', 'TRAN-'+@plant
Select	@WeekNo=@WeekNo+1
End

FETCH NEXT FROM Plant INTO @plant
End

CLOSE Plant
DEALLOCATE Plant

Insert	location (
		code,
		name,
		type,
		plant,
		secured_location
		)
Select	Location,
		'Intransit to ' + Plant ,
		'ST',
		Plant,
		'N' 
from		@LocationWeeks
Where	location not in (Select code from location)

Insert	destination  (
		destination,
		name,
		plant
		)
Select	distinct
		Plant,
		'Intransit to ' + Plant,
		Plant
from		@LocationWeeks
Where	Plant not in (Select destination from destination)
		
End



		
GO
