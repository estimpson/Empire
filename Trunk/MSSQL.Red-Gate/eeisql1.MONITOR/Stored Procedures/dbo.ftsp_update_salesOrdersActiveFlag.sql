SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ftsp_update_salesOrdersActiveFlag]
as
SELECT	COUNT(1) OrderCount,
		order_no,
		customer_part,
		destination,
		part_number
INTO	#Orders
		
FROM	order_detail
WHERE	order_detail.due_date >= DATEADD(dd,-60,GETDATE()) AND quantity > 1
GROUP BY order_no,
		customer_part,
		destination,
		part_number
		
		ORDER BY 
		customer_part,
		destination,
		1 DESC
SELECT	order_no, (SELECT MAX(OrderCount) FROM #Orders o2 WHERE o2.customer_part = #Orders.customer_part AND o2.destination = #Orders.destination) HighCount , #Orders.OrderCount
INTO	#OrdersCount
FROM	#Orders

UPDATE	order_header
SET status = 'A'
WHERE	order_no IN (

SELECT	Order_no
FROM	#OrdersCount
WHERE	HighCount = OrderCount)

GO
