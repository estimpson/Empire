SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [dbo].[ftsp_ASN_Alert_test_One_Destination] (@ediShipToCode varchar(25))

AS 

BEGIN

-- [dbo].[ftsp_ASN_Alert_test_One_Destination] 'FW64' 

--Get Shipments From Prior Week
DECLARE @Shipments TABLE 
	(
	ShipperID VARCHAR(25),
	DateShipped DATETIME,
	Operator VARCHAR(50),
	Destination VARCHAR(25),
	TradingPartnerCode VARCHAR(25), PRIMARY KEY (ShipperID)
	)

DECLARE	@Date1 DATETIME,
			@Date2 DATETIME,
			@TradingPartnerCode varchar(25)
			
Select @TradingPartnerCode =  (Select MAX(trading_partner_code) from edi_setups where parent_destination = @ediShipToCode)

SELECT	@Date1 = DATEADD(DAY,-10, GETDATE())
SELECT	@Date2 = DATEADD(MINUTE,-30, GETDATE())

INSERT	@Shipments
	SELECT
		s.id,
		s.date_shipped,
		MAX(e.name),
		s.destination,
		es.trading_partner_code
	FROM 
		shipper s
	JOIN
		edi_setups es ON s.destination = es.destination
	JOIN
		shipper_detail sd ON s.id = sd.shipper
	LEFT JOIN
		employee e ON sd.operator = e.operator_code
	WHERE
		status in ('C', 'Z' ) AND 
		COALESCE(auto_create_asn,'N') = 'Y'AND
		s.date_shipped >= @Date1 AND  s.date_shipped <= @Date2 
		AND NOT EXISTS ( SELECT 1 FROM shipper_detail sd WHERE part_original LIKE '%-PT%' AND sd.shipper = s.id  ) AND
		es.trading_partner_code != 'DECOFINMEX'  and
		es.parent_destination = @EDiShipToCode and
		es.trading_partner_code = @TradingPartnerCode
	GROUP BY
		s.id,
		s.date_shipped,
		s.destination,
		es.trading_partner_code
		
UNION

SELECT
		s.id,
		s.date_shipped,
		MAX(e.name),
		s.destination,
		es.trading_partner_code
	FROM 
		shipper s
	JOIN
		edi_setups es ON s.destination = es.destination
	JOIN
		shipper_detail sd ON s.id = sd.shipper
	LEFT JOIN
		employee e ON sd.operator = e.operator_code
	WHERE
		status in ('C', 'Z') AND 
		COALESCE(auto_create_asn,'N') = 'Y'AND
		s.date_shipped >= @Date1 AND  s.date_shipped <= @Date2 AND
		es.trading_partner_code = 'DECOFINMEX'  
	GROUP BY
		s.id,
		s.date_shipped,
		s.destination,
		es.trading_partner_code
--Select * From @shipments

DECLARE @ASNs TABLE 
	(
	Id INT IDENTITY(1,1),
	ShipperID VARCHAR(25),
	TradingPartnerCode VARCHAR(25)
	)

INSERT @ASNs
 (	ShipperID,
	TradingPartnerCode
		)

	SELECT 
		DISTINCT	
		DocNumber,
		TradingPartner
	FROM
		fxEDI.EDI.EDIDocuments
	WHERE
		Status IN (0,1) AND
		TradingPartner =  @TradingPartnerCode AND
		RowCreateDT >= @Date1 AND
		type IN ('856', 'DESADV')

	UPDATE
		fxEDI.EDI.EDIDocuments
		SET Status = 1
	WHERE
		Status = 0 
		AND		RowCreateDT >= @Date1 
		AND		type IN ('856', 'DESADV')
	
DECLARE @Exceptions TABLE 
	(
	ShipperID INT,
	Destination VARCHAR(25),
	DateShipped DATETIME,
	Operator VARCHAR(25),
	TradingPartnerCode VARCHAR(25), 
	Notes VARCHAR(MAX), PRIMARY KEY (ShipperID)
	)

INSERT
	@Exceptions
SELECT 
	Shipments.ShipperID,
	Shipments.Destination,
	Shipments.DateShipped,
	Shipments.Operator,
	Shipments.TradingPartnerCode,
	'ASN Not Sent from TLW' 
FROM 
	@Shipments Shipments
WHERE 
	ShipperID NOT IN ( SELECT ShipperID FROM @ASNs ASNs)
ORDER BY 5,1
	

Select * From @Exceptions

IF EXISTS (SELECT 1 FROM @Exceptions)

BEGIN

DECLARE @tableHTML  NVARCHAR(MAX) ;

SET @tableHTML =
    N'<H1>ASN Issue Alert</H1>' +
    N'<table border="1">' +
    N'<tr><th>TradingPartner</th>' +
    N'<th>Destination</th><th>ShipperID</th><th>DateShipped</th>' +
    N'<th>Notes</th></tr>' +
    CAST ( ( SELECT td = eo.TradingPartnerCode, '',
                    td = eo.Destination, '',
                    td = eo.ShipperID, '',
					td = eo.DateShipped, '',
                    td = eo.Notes
              FROM @Exceptions  eo
              ORDER BY 1,2,3  
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' +
    N'1) Please go to Monitor > Orders > ASN > Test'+
    N'2) Select the shipper from the list on the right hand side'+
    N'3) The EDI should generate on the left hand window and any errors will display below'+
    N'4) Correct the erroneous data or input missing data required (commonly missing is a tran mode or truck number)'+
    N'5) Click the create button to create the EDI file for TrustedLink to pick up and process'+
    N'6) You can go into TrustedLink and manually transmit the file if time is of the essence or it will process automatically'+
    N'at the next scheduled interval';
    
EXEC msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = 'mminth@empireelect.com;gurbina@empireelect.com;vgarcia@empireelect.com;JStoehr@empireelect.com;jjflores@empire.hn', -- varchar(max)
    @copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com;spetrovski@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'ASN Issue Alert', -- nvarchar(255)
    @body = @TableHTML, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)
    
 END
 
 END














GO
