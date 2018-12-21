SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE FUNCTION [EDI_XML_STANLEY_ASN].[udf_ASNSerials]
(	@ShipperID INT
)

--Select * from  [EDI_XML_STANLEY_ASN].[udf_ASNSerials](115990 ) 

RETURNS @ASNSerials TABLE
(		ShipperID INT
	 , DiscretePO VARCHAR(50)
	,  CustomerPart VARCHAR(50)
	,  Serial VARCHAR(75)
	,  PackageType VARCHAR(50)
	,  SerialQty INT

)
AS
BEGIN

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
	SET A.DiscretePOPriorAccum = COALESCE(( SELECT SUM(B.QuantityShipped) FROM @DiscretePOsShipped B WHERE B.id < A.ID AND  A.Part = B.part ),0),
			A.DiscretePOAccum = COALESCE(( SELECT SUM(B.QuantityShipped) FROM @DiscretePOsShipped B WHERE B.id <= A.ID  AND A.Part = B.part  ),0)
	FROM @DiscretePOsShipped A
	

DECLARE @ShippedSerials TABLE
	(	ID INT IDENTITY (1,1),
		shipper INT,
		serial VARCHAR(75),
		CustomerPart VARCHAR(50),
		qtyShipped INT,
		AccumShipped INT
      )

	  INSERT @ShippedSerials
	          ( shipper ,
	            serial ,
	            CustomerPart ,
	            qtyShipped ,
	            AccumShipped
	          )
	SELECT at.shipper,
					ISNULL(es.supplier_code,'') + CONVERT ( VARCHAR(50), at.serial ),
					sd.customer_part,
					at.quantity,
					NULL
FROM
	dbo.shipper s
	JOIN dbo.edi_setups es ON es.destination = s.destination AND s.id = @ShipperID
	JOIN dbo.shipper_detail sd
		ON sd.shipper = @ShipperID
	JOIN dbo.audit_trail at
		ON at.type = 'S'
		   AND at.shipper = CONVERT(VARCHAR(50), @ShipperID)
		   AND at.part = sd.part
WHERE
	COALESCE(s.type, 'N') IN ('N', 'M')

			ORDER BY 3,4
		
			


				UPDATE  A
				SET A.AccumShipped = ( SELECT SUM(B.qtyShipped) FROM @ShippedSerials B WHERE B.CustomerPart = A.CustomerPart AND B.ID<=A.ID )
				FROM
				@ShippedSerials A 

				INSERT @ASNSerials
				        ( ShipperID ,
				          DiscretePO ,
				          CustomerPart ,
				          Serial ,
						  PackageType,
				          SerialQty
				        )
				

				SELECT    ss.Shipper,
								COALESCE(ShippedPOs.DiscretePO, 'NoDiscretePO') ,
								ss.CustomerPart,
								ss.serial,
								'CTN90', 
								ss.qtyShipped
				FROM 
				 @ShippedSerials ss 
				 OUTER APPLY 
				( SELECT * 
					FROM @DiscretePOsShipped dpo
				 WHERE 
					ss.shipper = dpo.Shipper 
					AND ss.CustomerPart = dpo.Part
					AND  ss.AccumShipped> dpo.DiscretePOPriorAccum
					AND ss.AccumShipped <= dpo.DiscretePOAccum ) AS ShippedPOs
				ORDER BY 2


		
		---	<Return>
	RETURN
END

				


GO
