SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE FUNCTION [dbo].[EDI_XML_STANLEY_ASN]].[udf_ASNLines]].[udf_ASNLines]
(	@ShipperID INT
)

--Select [EDI_XML_STANLEY_ASN]].[udf_ASNLines](115990) 

RETURNS @ASNLines TABLE
(	ShipperID INT
,	CustomerPart VARCHAR(30)
,	CustomerPO VARCHAR(30)
,	Quantity INT
,	PriorAccumQty INT
,   AccumQty INT

)
AS
BEGIN
--- <Body>

--- </Body>
	DECLARE @DiscretePOsShipped TABLE
(   ID INT IDENTITY (1,1),
	Shipper INT,
	DiscretePO VARCHAR(50),
	Part VARCHAR(50),
	QuantityShipped INT,
	DiscretePOPriorAccum INT,
	DiscretePOAccum INT
	)


	INSERT @DiscretePOsShipped
	        ( Shipper ,
	          DiscretePO ,
	          Part ,
	          QuantityShipped
	        )

SELECT   dpo.Shipper, 
				dpo.DiscretePONumber,
				oh.customer_part,
				SUM(dpo.Qty)

 FROM dbo.DiscretePONumbersShipped dpo JOIN
order_header oh ON oh.order_no = dpo.OrderNo AND dpo.Shipper =  @ShipperID
GROUP BY 
				dpo.Shipper, 
				dpo.DiscretePONumber,
				oh.customer_part
	ORDER BY 3,4 ASC

	UPDATE A
	SET A.DiscretePOPriorAccum = COALESCE(( SELECT SUM(B.QuantityShipped) FROM @DiscretePOsShipped B WHERE B.id < A.ID  ),0),
			A.DiscretePOAccum = COALESCE(( SELECT SUM(B.QuantityShipped) FROM @DiscretePOsShipped B WHERE B.id <= A.ID  ),0)
	FROM @DiscretePOsShipped A

	INSERT
		@ASNLines
	(		ShipperID
		,	CustomerPart 
		,	CustomerPO
		,	Quantity
		,	PriorAccumQty 
		,   AccumQty 
	)
	

	SELECT 
		Shipper 
		,Part 
		,DiscretePO	
	,	QuantityShipped 
	,	DiscretePOPriorAccum 
	,	DiscretePOAccum

	FROM @DiscretePOsShipped

---	<Return>
	RETURN
END






GO
