SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [EDI_XML_STANLEY_ASN].[udf_ASNLinePackQtyDetails]
(	@ShipperID INT
)

--Select * from  [EDI_XML_STANLEY_ASN].[udf_ASNLinePackQtyDetails](115990 ) 

RETURNS @ASNPartPackQty TABLE
(	RowNumber INT
	,ShipperID INT
,	CustomerPart VARCHAR(50)
,	DiscretePO VARCHAR(50)
,	PackQty INT
,	PackCount INT
,	PackageType VARCHAR(50)

)
AS
BEGIN
--- <Body>

--- </Body>

INSERT @ASNPartPackQty
        ( RowNumber,
			ShipperID ,
          CustomerPart ,
		  DiscretePO,
          PackQty ,
          PackCount ,
          PackageType
        )
	

SELECT
	RowNumber = ROW_NUMBER() OVER (PARTITION BY sd.customerpart ORDER BY sd.customerpart)
,	ShipperID = sd.shipperID
,	CustomerPart = sd.customerpart
,	DiscretePO = sd.DiscretePO
,	PackQty = sd.SerialQty
,	PackCount = COUNT(*)
,	PackageType = 'CTN90'
FROM
	 [EDI_XML_STANLEY_ASN].[udf_ASNSerials] (@ShipperID) sd
		
GROUP BY
	sd.shipperID
,	sd.customerpart
,	sd.DiscretePO
,	sd.SerialQty

---	<Return>
	RETURN
END







GO
