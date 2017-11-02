SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [EDIStanley].[CurrentPlanningReleases_ManualImport]
()
RETURNS @CurrentPlanningReleases TABLE
(	RawDocumentGUID UNIQUEIDENTIFIER
,	ReleaseNo VARCHAR(50)
,	ShipToCode VARCHAR(15)
,	ShipFromCode VARCHAR(15)
,	ConsigneeCode VARCHAR(15)
,	CustomerPart VARCHAR(50)
,	CustomerPO VARCHAR(50)
,	CustomerModelYear VARCHAR(50)
,	NewDocument INT
)
AS
BEGIN
--- <Body>
	INSERT
		@CurrentPlanningReleases
	SELECT DISTINCT
		RawDocumentGUID = ph.RawDocumentGUID
	,	ReleaseNo = COALESCE(pr.ReleaseNo,'')
	,	ShipToCode = pr.ShipToCode
	,	ShipFromCode = COALESCE(pr.ShipFromCode,'')
	,	ConsigneeCode = COALESCE(pr.ConsigneeCode,'')
	,	CustomerPart = pr.CustomerPart
	,	CustomerPO = COALESCE(pr.CustomerPO,'')
	,	CustomerModelYear =  COALESCE(pr.CustomerModelYear,'')
	,	NewDocument =
			CASE
				WHEN ph.Status = 0 --(select dbo.udf_StatusValue('EDIStanley.PlanningHeaders', 'Status', 'New'))
					THEN 1
				ELSE 0
			END
	FROM
		(	SELECT
				ShipToCode = pr.ShipToCode
			,	ShipFromCode = COALESCE(pr.ShipFromCode,'')
			,	ConsigneeCode = ''
			,	CustomerPart = pr.CustomerPart
			,	CustomerPO = ''
			,	CustomerModelYear =  COALESCE(pr.CustomerModelYear,'')
			,	CheckLast = MAX
				(	  CONVERT(CHAR(20), ph.RowCreateDT, 120)										
				)
			FROM
				EDIStanley.PlanningHeaders_ManualImport ph
				JOIN EDIStanley.PlanningReleases_ManualImport pr
					ON pr.RawDocumentGUID = ph.RawDocumentGUID
			WHERE
				ph.Status IN
				(	0 --(select dbo.udf_StatusValue('EDIStanley.PlanningHeaders_ManualImport', 'Status', 'New'))
				,	1 --(select dbo.udf_StatusValue('EDIStanley.PlanningHeaders_ManualImport', 'Status', 'Active'))
				)
			GROUP BY
				pr.ShipToCode
			,	COALESCE(pr.ShipFromCode,'')
			,	pr.CustomerPart
			,	COALESCE(pr.CustomerModelYear,'')
		) cl
		JOIN EDIStanley.PlanningHeaders_ManualImport ph
			JOIN EDIStanley.PlanningReleases_ManualImport pr
				ON pr.RawDocumentGUID = ph.RawDocumentGUID
			ON 
						pr.ShipToCode = cl.ShipToCode
			AND COALESCE(pr.ShipFromCode, '') = cl.ShipFromCode
			AND pr.CustomerPart = cl.CustomerPart
			AND COALESCE(pr.CustomerModelYear,'') = cl.CustomerModelYear
			AND	(	CONVERT(CHAR(20), ph.RowCreateDT, 120) 
											
				) = cl.CheckLast
			--LEFT JOIN
			--EDIStanley.BlanketOrders bo ON bo.EDIShipToCode = pr.ShipToCode
			--WHERE ph.RowCreateDT>= DATEADD(dd, COALESCE(bo.PlanningReleaseHorizonDaysBack,-30), GETDATE())
			--AND COALESCE(bo.ProcessPlanningRelease,1) = 1
--- </Body>

---	<Return>
	RETURN
END

GO