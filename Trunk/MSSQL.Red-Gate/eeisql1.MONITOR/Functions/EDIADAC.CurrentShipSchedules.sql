SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--select * from [EDIADAC].[CurrentShipSchedules]()

CREATE FUNCTION [EDIADAC].[CurrentShipSchedules]
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
,	OpenReleaseQty INT
,	ReleaseDate DATETIME
,	RowCreateDT DATETIME
,	NewDocument INT
)
AS
BEGIN
--- <Body>
--Getting List of EDI Documents that need to be processed based on RANs that have already shipped

DECLARE @RANsShipped TABLE
(		RAN VARCHAR(50),
		CustomerPart		VARCHAR(50),
		ShipToID						VARCHAR(50),
		QtyShipped					INT
)

INSERT
		@RANsShipped

SELECT 
		RANNumber,
		sd.Customer_part,
		COALESCE(es.edishiptoID, es.parent_destination),
		SUM(qty)
 FROM 
		ADACRanNumbersShipped RANs
JOIN
		shipper S ON RANs.Shipper = s.id
JOIN
		shipper_detail sd ON sd.Shipper =  s.id
JOIN
		edi_setups es ON es.destination = s.destination
WHERE
		 s.destination IS NOT NULL
		AND customer_part IS NOT NULL
GROUP BY
		RANNumber,
		Customer_part,
		COALESCE(es.edishiptoID, es.parent_destination)
ORDER BY 2,1

--Compare RANs Shipped Qty to Original RAN Demand and obtain open RANQty

DECLARE @RANDemand TABLE
(		ID INT IDENTITY(1,1),
		RawDocumentGUID UNIQUEIDENTIFIER,
		RAN VARCHAR(50),
		CustomerPart VARCHAR(50),
		ShipToID VARCHAR(50),
		QtyRequired INT,
		DueDate DATETIME
)

INSERT @RanDemand

(		RawDocumentGUID,
		RAN,
		CustomerPart,
		ShipToID,
		QtyRequired,
		DueDate
)


SELECT 
		alss.RawDocumentGUID,
		alss.UserDefined5,
		alss.CustomerPart,
		alss.ShipToCode,
		alss.ReleaseQty,
		alss.ReleaseDT 
	FROM
(SELECT
		UserDefined5,
		CustomerPart,
		ShipToCode,
		MIN(RowCreateDT) FirstReleaseDT
FROM
		EDIADAC.ShipSchedules
WHERE
		status != -1
GROUP	BY
		UserDefined5,		
		CustomerPart,
		ShipToCode
) CheckFirst
JOIN
		EDIADAC.ShipSchedules Alss ON ALss.CustomerPart = CheckFirst.CustomerPart
		AND Alss.ShipToCode = CheckFirst.ShipToCode
		AND Alss.UserDefined5 = CheckFirst.UserDefined5
		AND Alss.RowCreateDT = CheckFirst.FirstReleaseDT
		AND Alss.rowCreateDT>= DATEADD(DAY, -60, GETDATE())
WHERE
		alss.Status != -1 
ORDER BY 4,3,2,5

DECLARE @OpenRANs TABLE
(
				RawDocumentGUID  UNIQUEIDENTIFIER,
				RANNumber VARCHAR(50),
				ShipToCode VARCHAR(50),
				CustomerPart VARCHAR(50),
				ReleaseQty INT,
				ShippedQty INT,
				DueDate DATETIME,
				OpenRANQty AS (ReleaseQty-ShippedQty)
)

INSERT
		@OpenRANs 
(		RawDocumentGUID,
		RANNumber,
		ShipToCode,
		CustomerPart,
		ReleaseQty,
		ShippedQty,
		DueDate
)


SELECT 
		RANDemand.RawDocumentGUID,
		RANDemand.RAN,
		RANDemand.ShipToID,
		RAnDemand.CustomerPart,
		RANDemand.QtyRequired,
		COALESCE(RANShipped.QtyShipped,0),
		RANDemand.DueDate

FROM @RANDemand RANDemand
LEFT JOIN
		@RANsShipped RANShipped ON RANShipped.ShipToID = RANDemand.ShipToID
		 AND RANShipped.CustomerPart = RANDemand.CustomerPart 
		 AND RANShipped.RAN = RANDemand.RAN
		

	INSERT
		@CurrentSS
	SELECT DISTINCT
		RawDocumentGUID = ssh.RawDocumentGUID
	,	ReleaseNo =  COALESCE(OpenRANs.RANNumber,'')
	,	ShipToCode = ss.ShipToCode
	,	ShipFromCode = COALESCE(ss.ShipFromCode,'')
	,	ConsigneeCode = COALESCE(ss.ConsigneeCode,'')
	,	CustomerPart = ss.CustomerPart
	,	CustomerPO = COALESCE(ss.CustomerPO,'')
	,	CustomerModelYear = COALESCE(ss.CustomerModelYear,'')
	,	OpenReleaseQty = OpenRANs.OpenRANQty
	,	ReleaseDT = OpenRANs.DueDate
	,	RowCreateDT = ss.RowCreateDT
	,	NewDocument =
			CASE
				WHEN ssh.Status = 0 --(select dbo.udf_StatusValue('EDIADAC.ShipScheduleHeaders', 'Status', 'New'))
					THEN 1
				ELSE 0
			END
	FROM
		(	SELECT
				*
			FROM
				@OpenRANs
				WHERE
						OpenRANQty>0

		) OpenRANs
		JOIN EDIADAC.ShipScheduleHeaders ssh
			JOIN EDIADAC.ShipSchedules ss
			ON ss.RawDocumentGUID = ssh.RawDocumentGUID
			ON		ss.ShipToCode = OpenRANs.ShipToCode
			AND ss.CustomerPart = OpenRANs.CustomerPart
			AND ss.RawDocumentGUID = OpenRANs.RawDocumentGUID
			AND ss.ReleaseDT = OpenRans.DueDate
			AND ss.UserDefined5 = OpenRANs.RANNumber
			AND ss.ReleaseDT >= getdate()-30 -- Added this date to eliminate old RANs that have been actually shipped but the RAN number was incorrect in order detail due to typo errors
			AND OpenRANs.RANNumber NOT IN ( 
			Select RANNumber from EDIADAC.CanceledRANs

				
				

			) -- Added to eliminate RANs that have been cancelled Andre S. Boulanger 
		
--- </Body>

---	<Return>
	RETURN
END















































GO
