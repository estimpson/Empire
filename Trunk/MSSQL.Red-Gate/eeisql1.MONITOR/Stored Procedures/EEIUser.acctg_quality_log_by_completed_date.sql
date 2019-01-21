SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE proc [EEIUser].[acctg_quality_log_by_completed_date] (@beg_date date, @end_date date) 
as 

--For Testing:

-- exec eeiuser.acctg_quality_log_by_reported_date '2019-01-07', '2019-01-14'
-- exec eeiuser.acctg_quality_log_by_completed_date '2019-01-01', '2019-01-14'


--declare @base_part varchar(20)
--declare @release_id varchar(8)
--select @base_part = 'TRW1152' 
--select @release_id = '2018-10'
select 
[CDR]
,datepart(ww,date_reported_customer) as [Year]
,datepart(ww,date_reported_customer) as [Week No]
,[Date_Reported_Customer] as [Reported Date]
,[Part_number_EEH] as [Part]
,[Customer_Part] as [Customer Part]
,[Problem_Description] as [Problem Description]
,[Where_Found] as [Where Found]
,[Where_discovered] as [Where Discovered]
,[Affected] as [Affected Customer]
,[How_Detected] as [How Detected]
,[Qty_Reported] as [Qty Reported]
,[DefectDescription] as [Defect Description]
,[Quality_source] as [Quality Source]
,[Quality_Source_detection] as [Quality Source Detection]
,(case when [Complete_analysis]= 1 then 'Yes' else 'No' end) as [Analysis Complete]
,[Complete_analysis_date] as [Date Analysis Completed]
,[Sent8D_Date] as [Sent 8D Date]
,(case when [Sort]=1 then 'Yes' else 'No' end) as [Sorting Required]

from eehsql1.sistema.[dbo].[SQC_Log_Header] a
left join eehsql1.sistema.[dbo].SQC_defects b on a.defectid = b.id 
--left join eehsql1.sistema.dbo.sqc_8d_root_cause c on a.CDR = c.CDR

where	[Complete_analysis_date] >= @beg_date and [Complete_analysis_date] < @end_date
order by 3


GO
