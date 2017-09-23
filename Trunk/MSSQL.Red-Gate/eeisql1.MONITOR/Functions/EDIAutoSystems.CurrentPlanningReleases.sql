SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [EDIAutoSystems].[CurrentPlanningReleases]
()
returns @CurrentPlanningReleases table
(	RawDocumentGUID uniqueidentifier
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ConsigneeCode varchar(15)
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
	,	ShipToCode = pr.ShipToCode
	,	ShipFromCode = coalesce(pr.ShipFromCode,'')
	,	ConsigneeCode = coalesce(pr.ConsigneeCode,'')
	,	CustomerPart = pr.CustomerPart
	,	CustomerPO = coalesce(pr.CustomerPO,'')
	,	NewDocument =
			case
				when ph.Status = 0 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'New'))
					then 1
				else 0
			end
	from
		(	select
				ShipToCode = pr.ShipToCode
			,	ShipFromCode = coalesce(pr.ShipFromCode,'')
			,	ConsigneeCode = coalesce(pr.ConsigneeCode,'')
			,	CustomerPart = pr.CustomerPart
			,	CustomerPO = coalesce(pr.CustomerPO,'')
			,	CheckLast = max
				(	convert(char(10), pr.ReleaseNo)
					+ convert(char(20), ph.DocumentDT, 120)
					+ convert(char(10), ph.DocNumber)
					+ convert(char(10), ph.ControlNumber)
					+ convert(char(20), ph.DocumentImportDT, 120)
				)
			from
				EDIAutosystems.PlanningHeaders ph
				join EDIAutosystems.PlanningReleases pr
					on pr.RawDocumentGUID = ph.RawDocumentGUID
			where
				ph.Status in
				(	0 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'New'))
				,	1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'Active'))
				)
			group by
				pr.ShipToCode
			,	coalesce(pr.ShipFromCode,'')
			,	coalesce(pr.ConsigneeCode,'')
			,	pr.CustomerPart
			,	coalesce(pr.CustomerPO,'')
		) cl
		join EDIAutosystems.PlanningHeaders ph
			join EDIAutosystems.PlanningReleases pr
				on pr.RawDocumentGUID = ph.RawDocumentGUID
			on pr.ShipToCode = cl.ShipToCode
			and coalesce(pr.ShipFromCode, '') = cl.ShipFromCode
			and coalesce(pr.ConsigneeCode, '') = cl.ConsigneeCode
			and pr.CustomerPart = cl.CustomerPart
			and coalesce(pr.CustomerPO, '') = cl.CustomerPO
			and	(	convert(char(10), pr.ReleaseNo)
					+ convert(char(20), ph.DocumentDT, 120)
					+ convert(char(10), ph.DocNumber)
					+ convert(char(10), ph.ControlNumber)
					+ convert(char(20), ph.DocumentImportDT, 120)
				) = cl.CheckLast
--- </Body>

---	<Return>
	return
end





GO
