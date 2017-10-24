SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE function [EDIEDIFACT97A].[CurrentPlanningReleases]
()
returns @CurrentPlanningReleases table
(	RawDocumentGUID uniqueidentifier
,	ReleaseNo varchar(50)
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ConsigneeCode varchar(15)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	CustomerModelYear varchar(50)
,	NewDocument int
)
as
begin
--- <Body>
	insert
		@CurrentPlanningReleases
	select distinct
		RawDocumentGUID = ph.RawDocumentGUID
	,	ReleaseNo = CASE WHEN coalesce(pr.ReleaseNo,'') like '%:%' 
					THEN SUBSTRING(pr.ReleaseNo, 1,  (PatINDEX('%:%', pr.ReleaseNo))-1) ELSE pr.ReleaseNo END 
	,	ShipToCode = pr.ShipToCode
	,	ShipFromCode = coalesce(pr.ShipFromCode,'')
	,	ConsigneeCode = coalesce(pr.ConsigneeCode,'')
	,	CustomerPart = pr.CustomerPart
	,	CustomerPO = coalesce(pr.CustomerPO,'')
	,	CustomerModelYear =  coalesce(pr.CustomerModelYear,'')
	,	NewDocument =
			case
				when ph.Status = 0 --(select dbo.udf_StatusValue('EDIEDIFACT97A.PlanningHeaders', 'Status', 'New'))
					then 1
				else 0
			end
	from
		(	select
				ShipToCode = pr.ShipToCode
			,	ShipFromCode = ''
			,	ConsigneeCode = ''
			,	CustomerPart = pr.CustomerPart
			,	CustomerPO = ''
			,	CustomerModelYear =  ''
			,	CheckLast = max
				(	  convert(char(20), ph.DocumentImportDT, 120)
					
					
				)
			from
				EDIEDIFACT97A.PlanningHeaders ph
				join EDIEDIFACT97A.PlanningReleases pr
					on pr.RawDocumentGUID = ph.RawDocumentGUID
			where
				ph.Status in
				(	0 --(select dbo.udf_StatusValue('EDIEDIFACT97A.PlanningHeaders', 'Status', 'New'))
				,	1 --(select dbo.udf_StatusValue('EDIEDIFACT97A.PlanningHeaders', 'Status', 'Active'))
				)
			group by
				pr.ShipToCode
			,	pr.CustomerPart
		) cl
		join EDIEDIFACT97A.PlanningHeaders ph
			join EDIEDIFACT97A.PlanningReleases pr
				on pr.RawDocumentGUID = ph.RawDocumentGUID
			on 
						pr.ShipToCode = cl.ShipToCode
			and pr.CustomerPart = cl.CustomerPart
			and	(	convert(char(20), ph.DocumentImportDT, 120) 
						
					
				) = cl.CheckLast
--- </Body>

---	<Return>
	return
end




























GO
