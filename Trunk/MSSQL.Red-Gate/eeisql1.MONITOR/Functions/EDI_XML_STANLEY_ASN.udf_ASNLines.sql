SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [EDI_XML_STANLEY_ASN].[udf_ASNLines]
(	@ShipperID INT
)

--Select * from  [EDI_XML_STANLEY_ASN].[udf_ASNLines](115990) 

RETURNS @ASNLines TABLE
(	RowNumber INT
,	ShipperID INT
,	CustomerPart VARCHAR(30)
,	CustomerPO VARCHAR(30)
,	Quantity INT

)
AS
BEGIN
--- <Body>

--- </Body>


	INSERT
		@ASNLines
	(		RowNumber
		,	ShipperID
		,	CustomerPart 
		,	CustomerPO
		,	Quantity 
	)
	

	SELECT 
		 RowNumber = ROW_NUMBER() OVER (PARTITION BY ShipperID ORDER BY CustomerPart)
		,ShipperID
		,CustomerPart 
		,DiscretePO	
	,	SUM(SerialQty)


	FROM [EDI_XML_STANLEY_ASN].[udf_ASNSerials](@ShipperID ) 
	GROUP BY
	     ShipperID
		,CustomerPart 
		,DiscretePO	

---	<Return>
	RETURN
END








GO
