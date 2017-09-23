SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create function [GMSPOEDI].[CurrentPlanningReleases]
()
returns @CurrentPlanningReleases table
(	RawDocumentGUID uniqueidentifier
,	ReleaseNo varchar(50)
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	NewDocument int
)
as
begin
--- <Body>
	insert
		@CurrentPlanningReleases
	select distinct
		RawDocumentGUID = ph.RawDocumentGUID
	,	ReleaseNo = coalesce(pr.ReleaseNo,'')
	,	ShipToCode = pr.ShipToCode
	,	ShipFromCode = coalesce(pr.ShipFromCode,'')
	,	CustomerPart = pr.CustomerPart
	,	CustomerPO = coalesce(pr.CustomerPO,'')
	,	NewDocument =
			case
				when ph.Status = 0 --(select dbo.udf_StatusValue('EDIEDIFACT97A.PlanningHeaders', 'Status', 'New'))
					then 1
				else 0
			end
	from
		(	select
				ShipToCode = pr.ShipToCode
			,	ShipFromCode = coalesce(pr.ShipFromCode,'')
			,	CustomerPart = pr.CustomerPart
			,	CustomerPO = coalesce(pr.CustomerPO,'')
			,	CheckLast = max
				(	  convert(char(20), ph.DocumentImportDT, 120)
					+ convert(char(20), ph.DocumentDT, 120)					
					+ convert(char(10), ph.DocNumber)
					+ convert(char(10), ph.ControlNumber)
					
				)
			from
				EDI.GMSPO_DELFOR_Headers ph
				join EDI.GMSPO_DELFOR_Releases pr
					on pr.RawDocumentGUID = ph.RawDocumentGUID
			where
				ph.Status in
				(	0 --(select dbo.udf_StatusValue('EDIEDIFACT97A.PlanningHeaders', 'Status', 'New'))
				,	1 --(select dbo.udf_StatusValue('EDIEDIFACT97A.PlanningHeaders', 'Status', 'Active'))
				)
			group by
				pr.ShipToCode
			,	coalesce(pr.ShipFromCode,'')
			,	pr.CustomerPart
			,	coalesce(pr.CustomerPO,'')
		) cl
		join EDI.GMSPO_DELFOR_Headers ph
			join EDI.GMSPO_DELFOR_Releases pr
				on pr.RawDocumentGUID = ph.RawDocumentGUID
			on 
						pr.ShipToCode = cl.ShipToCode
			and coalesce(pr.ShipFromCode, '') = cl.ShipFromCode
			and pr.CustomerPart = cl.CustomerPart
			and coalesce(pr.CustomerPO, '') = cl.CustomerPO
			and	(	convert(char(20), ph.DocumentImportDT, 120) 
						+ convert(char(20), ph.DocumentDT, 120)
						+ convert(char(10), ph.DocNumber)
					  + convert(char(10), ph.ControlNumber)
					
				) = cl.CheckLast
--- </Body>

---	<Return>
	return
end
























GO
