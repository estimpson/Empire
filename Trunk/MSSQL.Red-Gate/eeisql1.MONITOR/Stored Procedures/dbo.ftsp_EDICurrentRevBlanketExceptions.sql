SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE	Procedure [dbo].[ftsp_EDICurrentRevBlanketExceptions]
AS
BEGIN

	
DECLARE	@EDIExceptions table
(	OrderNo int,
	EmpirePart varchar(25),
	CustomerPart varchar(35),
	Destination varchar(25)
	)
	
	INSERT	@EDIExceptions
	        ( OrderNo ,
	          EmpirePart ,
	          CustomerPart ,
	          Destination
	        )
	SELECT	Order_no,
			Blanket_part,
			Customer_part,
			order_header.Destination
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
	
	
		
	
	SELECT	*
	FROM	@EDIExceptions
	
	
	
END



GO
