SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create VIEW [dbo].[EEI_part_customer_price_matrix]
AS
SELECT       *
FROM            EEISQL1.Monitor.dbo.part_customer_price_matrix 


GO
