SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [EDIPLEX].[CurrentShipSchedules]
()
RETURNS @CurrentSS TABLE
(	RawDocumentGUID UNIQUEIDENTIFIER
,	ReleaseNo VARCHAR(50)
,	ShipToCode VARCHAR(15)
,	ShipFromCode VARCHAR(50)
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
	,	ShipFromCode = COALESCE(ss.ShipFromCode,'')
	,	ConsigneeCode = COALESCE(ss.ConsigneeCode,'')
	,	CustomerPart = ss.CustomerPart
	,	CustomerPO = COALESCE(ss.CustomerPO,'')
	,	CustomerModelYear = COALESCE(ss.CustomerModelYear,'')
	,	NewDocument =
			CASE
				WHEN ssh.Status = 0 --(select dbo.udf_StatusValue('EDIPLEX.ShipScheduleHeaders', 'Status', 'New'))
					THEN 1
				ELSE 0
			END
	FROM
		(	SELECT
				ShipToCode = ss.ShipToCode
			,	ShipFromCode = COALESCE(ss.ShipFromCode,'')
			,	ConsigneeCode = ''
			,	CustomerPart = ss.CustomerPart
			,	CustomerPO = ''
			,	CustomerModelYear = COALESCE(ss.CustomerModelYear,'')
			,	CheckLast = MAX
				(	  CONVERT(CHAR(20), ssh.DocumentImportDT, 120)
					+ CONVERT(CHAR(20), ssh.DocumentDT, 120)
					+ CONVERT(CHAR(10), ssh.DocNumber)
					+ CONVERT(CHAR(10), ssh.ControlNumber)
					
				)
			FROM
				EDIPLEX.ShipScheduleHeaders ssh
				JOIN EDIPLEX.ShipSchedules ss
					ON ss.RawDocumentGUID = ssh.RawDocumentGUID
			WHERE
				ssh.Status IN
				(	0 --(select dbo.udf_StatusValue('EDIPLEX.ShipScheduleHeaders', 'Status', 'New'))
				,	1 --(select dbo.udf_StatusValue('EDIPLEX.ShipScheduleHeaders', 'Status', 'Active'))
				)
			GROUP BY
				ss.ShipToCode
			,	COALESCE(ss.ShipFromCode,'')
			,	ss.CustomerPart
			,	COALESCE(ss.CustomerModelYear,'')
		) cl
		JOIN EDIPLEX.ShipScheduleHeaders ssh
			JOIN EDIPLEX.ShipSchedules ss
			ON ss.RawDocumentGUID = ssh.RawDocumentGUID
			ON ss.ShipToCode = cl.ShipToCode
			AND COALESCE(ss.ShipFromCode, '') = cl.ShipFromCode
			AND ss.CustomerPart = cl.CustomerPart
			AND COALESCE(ss.CustomerModelYear,'') = cl.CustomerModelYear
			AND	(	CONVERT(CHAR(20), ssh.DocumentImportDT, 120)
					+ CONVERT(CHAR(20), ssh.DocumentDT, 120)
					+ CONVERT(CHAR(10), ssh.DocNumber)
					+ CONVERT(CHAR(10), ssh.ControlNumber)
					
				) = cl.CheckLast
			LEFT JOIN
				EDIPLEX.BlanketOrders bo ON bo.EDIShipToCode = ss.ShipToCode
			WHERE ss.RowCreateDT>= DATEADD(dd, COALESCE(bo.ShipScheduleHorizonDaysBack,-30), GETDATE())
			AND COALESCE(bo.ProcessShipSchedule,1) = 1
--- </Body>

---	<Return>
	RETURN
END

GO
