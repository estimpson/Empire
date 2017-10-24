SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--select * from edi.NAL_862_Releases where RowCreateDT = '2013-02-25 10:38:54.520'

CREATE procedure [EEIUser].[DEV.scheduling_view_full_862_dynamicsql] @rowcreatedt datetime

-- exec eeiuser.scheduling_view_862 '2013-02-25 10:38:54.520'

as

--declare @rowcreatedt datetime
--select @rowcreatedt = '2013-02-25 10:38:54.520'
--select convert(varchar(30),@rowcreatedt,113)

DECLARE @PivotColumnHeaders varchar(MAX)
SELECT @PivotColumnHeaders = 
	COALESCE(
		@pivotColumnHeaders + ',[' + cast(ReleaseDT as varchar) +']',
		'[' + cast(ReleaseDT as varchar) + ']'
		)
FROM (select distinct(case when releaseDT < rowcreatedt then 'Past Due' else convert(varchar,releaseDT,101) end) as releaseDT from edi.NAL_862_Releases WHERE RowCreateDT = @rowcreatedt )a

--select @pivotcolumnheaders

declare @PivotTableSQL NVARCHAR(MAX)
Set @PivotTableSQL = N'

Select * 
from (
	SELECT
		ShipToCode,
		CustomerPart,
		(case when releaseDT < rowcreatedt then ''Past Due'' else convert(varchar,releaseDT,101) end) as releaseDT,
		ReleaseQty
	FROM edi.NAL_862_Releases where rowcreateDT = '''+ convert(varchar(30),@rowcreatedt,113)+''') as PivotData
	PIVOT (
	Sum(ReleaseQty)
	For ReleaseDT in (
		' + @PivotColumnHeaders + '
		  )
	) AS PivotTable
'

Execute(@PivotTableSQL)









GO
