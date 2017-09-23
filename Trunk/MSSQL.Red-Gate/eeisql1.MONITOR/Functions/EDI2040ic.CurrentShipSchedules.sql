SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE FUNCTION [EDI2040ic].[CurrentShipSchedules]
()
RETURNS @CurrentSS TABLE
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
		@CurrentSS
	SELECT DISTINCT
		RawDocumentGUID = ssh.RawDocumentGUID
	,	ReleaseNo =  COALESCE(ss.ReleaseNo,'')
	,	ShipToCode = ss.ShipToCode
	,	ShipFromCode = LEFT(COALESCE(ss.ShipFromCode,''),15)
	,	ConsigneeCode = COALESCE(ss.ConsigneeCode,'')
	,	CustomerPart = ss.CustomerPart
	,	CustomerPO = COALESCE(ss.CustomerPO,'')
	,	CustomerModelYear = COALESCE(ss.CustomerModelYear,'')
	,	NewDocument =
			CASE
				WHEN ssh.Status = 0 --(select dbo.udf_StatusValue('EDI2040ic.ShipScheduleHeaders', 'Status', 'New'))
					THEN 1
				ELSE 0
			END
	FROM
		(	SELECT
				ShipToCode = ss.ShipToCode
			,	ShipFromCode = LEFT(COALESCE(ss.ShipFromCode,''),15)
			,	ConsigneeCode = ''
			,	CustomerPart = ss.CustomerPart
			,	CustomerPO = ''
			,	CustomerModelYear = COALESCE(ss.CustomerModelYear,'')
			,	CheckLast = MAX
				(	  CONVERT(CHAR(20), ssh.DocumentImportDT, 120)
					
				)
			FROM
				EDI2040ic.ShipScheduleHeaders ssh
				JOIN EDI2040ic.ShipSchedules ss
					ON ss.RawDocumentGUID = ssh.RawDocumentGUID
			WHERE
				ssh.Status IN
				(	0 --(select dbo.udf_StatusValue('EDI2040ic.ShipScheduleHeaders', 'Status', 'New'))
				,	1 --(select dbo.udf_StatusValue('EDI2040ic.ShipScheduleHeaders', 'Status', 'Active'))
				)
			GROUP BY
				ss.ShipToCode
			,	LEFT(COALESCE(ss.ShipFromCode,''),15)
			,	ss.CustomerPart
			,	COALESCE(ss.CustomerModelYear,'')
		) cl
		JOIN EDI2040ic.ShipScheduleHeaders ssh
			JOIN EDI2040ic.ShipSchedules ss
			ON ss.RawDocumentGUID = ssh.RawDocumentGUID
			ON ss.ShipToCode = cl.ShipToCode
			AND COALESCE(ss.ShipFromCode, '') = cl.ShipFromCode
			AND ss.CustomerPart = cl.CustomerPart
			AND COALESCE(ss.CustomerModelYear,'') = cl.CustomerModelYear
			AND	(	CONVERT(CHAR(20), ssh.DocumentImportDT, 120)
					
				) = cl.CheckLast
			LEFT JOIN
				EDI2040ic.BlanketOrders bo ON bo.EDIShipToCode = ss.ShipToCode
			WHERE ss.RowCreateDT>= DATEADD(dd, COALESCE(bo.ShipScheduleHorizonDaysBack,-30), GETDATE())
			AND COALESCE(bo.ProcessShipSchedule,1) = 1
--- </Body>

---	<Return>
	RETURN
END























GO
