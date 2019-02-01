SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE proc [EEIUser].[acctg_csm_sp_select_base_part_quality] (@base_part varchar(30)) 
as 

--For Testing:

-- exec eeiuser.acctg_csm_sp_select_base_part_quality @base_part = 'AUT0290' 


--declare @base_part varchar(20)
--declare @release_id varchar(8)
--select @base_part = 'TRW1152' 
--select @release_id = '2018-10'
select 
[CDR]
,[Date_Reported_Customer] as [ReportedDate]
,[Part_number_EEH] as [Part]
,[Customer_Part] as [CustomerPart]
,[Problem_Description] as [ProblemDescription]
,[Where_Found] as [WhereFound]
,[Where_discovered] as [WhereDiscovered]
,[Affected] as [AffectedCustomer]
,[How_Detected] as [HowDetected]
,[Qty_Reported] as [QtyReported]
,[DefectDescription] as [DefectDescription]
,[Quality_source] as [QualitySource]
,[Quality_Source_detection] as [QualitySourceDetection]
,(case when [Complete_analysis]= 1 then 'Yes' else 'No' end) as [AnalysisComplete]
,[Complete_analysis_date] as [DateAnalysisCompleted]
,[Sent8D_Date] as [Sent8DDate]
,(case when [Sort]=1 then 'Yes' else 'No' end) as [SortingRequired]

from eehsql1.sistema.[dbo].[SQC_Log_Header] a
left join eehsql1.sistema.[dbo].SQC_defects b on a.defectid = b.id 
--left join eehsql1.sistema.dbo.sqc_8d_root_cause c on a.CDR = c.CDR

where	left(part_number_eeh,7) like  '%'+@base_part+'%' 
order by 2

GO
