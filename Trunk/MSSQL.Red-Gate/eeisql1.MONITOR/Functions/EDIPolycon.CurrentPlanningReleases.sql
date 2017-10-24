SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE function [EDIPolycon].[CurrentPlanningReleases]
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
	,	ReleaseNo = coalesce(pr.ReleaseNo,'')
	,	ShipToCode = pr.ShipToCode
	,	ShipFromCode = coalesce(pr.ShipFromCode,'')
	,	ConsigneeCode = coalesce(pr.ConsigneeCode,'')
	,	CustomerPart = pr.CustomerPart
	,	CustomerPO = coalesce(pr.CustomerPO,'')
	,	CustomerModelYear =  coalesce(pr.CustomerModelYear,'')
	,	NewDocument =
			case
				when ph.Status = 0 --(select dbo.udf_StatusValue('EDIPolycon.PlanningHeaders', 'Status', 'New'))
					then 1
				else 0
			end
	from
		(	select
				ReleaseNo = coalesce(max(pr.ReleaseNo),'')
			,	ShipToCode = pr.ShipToCode
			,	ShipFromCode = coalesce(pr.ShipFromCode,'')
			,	ConsigneeCode = coalesce(pr.ConsigneeCode,'')
			,	CustomerPart = pr.CustomerPart
			,	CustomerPO = coalesce(min(pr.CustomerPO),'')
			,	CustomerModelYear =  coalesce(min(pr.CustomerModelYear),'')
			,	CheckLast = max
				(	 convert(char(20), ph.DocumentDT, 120)
					+ convert(char(20), ph.DocumentImportDT, 120)
					+ convert(char(10), ph.DocNumber)
					+ convert(char(10), ph.ControlNumber)
					
				)
			from
				EDIPolycon.PlanningHeaders ph
				join EDIPolycon.PlanningReleases pr
					on pr.RawDocumentGUID = ph.RawDocumentGUID
			where
				ph.Status in
				(	0 --(select dbo.udf_StatusValue('EDIPolycon.PlanningHeaders', 'Status', 'New'))
				,	1 --(select dbo.udf_StatusValue('EDIPolycon.PlanningHeaders', 'Status', 'Active'))
				)
			group by
				pr.ShipToCode
			,	coalesce(pr.ShipFromCode,'')
			,	coalesce(pr.ConsigneeCode,'')
			,	pr.CustomerPart
			
			
		) cl
		join EDIPolycon.PlanningHeaders ph
			join EDIPolycon.PlanningReleases pr
				on pr.RawDocumentGUID = ph.RawDocumentGUID
			on pr.ShipToCode = cl.ShipToCode
			and coalesce(pr.ReleaseNo,'') = cl.ReleaseNo
			and coalesce(pr.ShipFromCode, '') = cl.ShipFromCode
			and coalesce(pr.ConsigneeCode, '') = cl.ConsigneeCode
			and pr.CustomerPart = cl.CustomerPart
			and	(	  convert(char(20), ph.DocumentDT, 120)
					+ convert(char(20), ph.DocumentImportDT, 120)
					+ convert(char(10), ph.DocNumber)
					+ convert(char(10), ph.ControlNumber)
					
				) = cl.CheckLast
--- </Body>

---	<Return>
	return
end





















GO
