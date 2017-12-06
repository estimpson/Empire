SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [FT].[vw_Carrierdata]
AS
--andre s. boulanger 11/16/2017 FT, LLC
--Data Used in Spreadsheet by Mario Calix
--
SELECT COUNT(1) CountOfDeliveriespast365days , S.destination, d.name AS DestinationName, carrier.scac, carrier.name AS CarrierName FROM
Shipper s
JOIN destination d ON d.destination =s.destination 
OUTER APPLY ( SELECT TOP 1 * FROM  dbo.carrier c WHERE   c.scac = s.ship_via ) carrier
WHERE S.status IN ('C' , 'Z') AND s.date_shipped >= GETDATE() -365 
GROUP BY s.destination,  d.name, carrier.scac, carrier.name
GO
