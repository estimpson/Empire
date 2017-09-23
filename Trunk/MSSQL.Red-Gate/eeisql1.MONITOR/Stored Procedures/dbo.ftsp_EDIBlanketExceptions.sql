SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE Procedure [dbo].[ftsp_EDIBlanketExceptions]
AS
BEGIN

	
DECLARE	@EDIExceptions table
(	OrderNo int,
	EmpirePart varchar(25),
	CustomerPart varchar(35),
	Destination varchar(25),
	TypeOfException varchar(25)
	)
	
	INSERT	@EDIExceptions
	        ( OrderNo ,
	          EmpirePart ,
	          CustomerPart ,
	          Destination,
	          TypeOfException
	        )
	SELECT	Order_no,
			Blanket_part,
			Customer_part,
			order_header.Destination,
			'Duplicate Blanket Order'
	FROM	dbo.part
	JOIN	order_header ON part.part = order_header.blanket_part
	JOIN	edi_setups ON dbo.order_header.destination = dbo.edi_setups.destination AND NULLIF(dbo.edi_setups.parent_destination,'') IS NOT NULL
	JOIN	(SELECT	COUNT(1) AS OrderCount, 
					blanket_part Blanketpart, 
					customer_part CustomerPart, 
					destination ShipToID 
			FROM	order_header 
			GROUP BY Blanket_part,Customer_part,Destination 
			HAVING COUNT(1)>1) DuplicateOrders ON order_header.blanket_part = Blanketpart AND order_header.customer_part = CustomerPart AND order_header.destination = ShipToID
			
			ORDER BY 4,2
INSERT	@EDIExceptions
        ( OrderNo ,
          EmpirePart ,
          CustomerPart ,
          Destination ,
          TypeOfException
        )
SELECT		Order_no,
			Blanket_part,
			Customer_part,
			order_header.Destination,
			'No Active Order Defined'
	FROM	dbo.part
	JOIN	order_header ON part.part = order_header.blanket_part
	JOIN	edi_setups ON dbo.order_header.destination = dbo.edi_setups.destination AND NULLIF(dbo.edi_setups.parent_destination,'') IS NOT NULL
	WHERE NOT EXISTS (SELECT	1 
						FROM	dbo.order_header oh 
						WHERE	oh.customer_part = order_header.customer_part AND	
								oh.destination = order_header.destination AND	
								ISNULL(NULLIF(oh.status,''),'X') = 'A')
	
	ORDER BY 4,2
	
	
INSERT	@EDIExceptions
        ( OrderNo ,
          EmpirePart ,
          CustomerPart ,
          Destination ,
          TypeOfException
        )
        
SELECT	Order_no,
			Blanket_part,
			Customer_part,
			order_header.Destination,
			'Duplicate Active Order'
	FROM	dbo.part
	JOIN	order_header ON part.part = order_header.blanket_part
	JOIN	edi_setups ON dbo.order_header.destination = dbo.edi_setups.destination AND NULLIF(dbo.edi_setups.parent_destination,'') IS NOT NULL
	JOIN	(SELECT	COUNT(1) AS OrderCount, 
					customer_part CustomerPart, 
					destination ShipToID 
			FROM	order_header 
			WHERE	order_header.status = 'A'
			GROUP BY Customer_part,Destination 
			HAVING COUNT(1)>1) DuplicateOrders ON order_header.customer_part = CustomerPart AND order_header.destination = ShipToID
	
	
		
	
	SELECT	*,
			(SELECT MAX(scheduler) FROM dbo.destination WHERE destination.destination = EDIExceptions.Destination) AS Scheduler
	FROM	@EDIExceptions EDIExceptions
	ORDER BY 5,4,2
	
	
	
END



GO
