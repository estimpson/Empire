SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	PROCEDURE [FT].[ftsp_CopyNALOrderDetail]
AS
BEGIN

SELECT	*
FROM	dbo.order_header
WHERE	customer = 'EEA'


END



GO
