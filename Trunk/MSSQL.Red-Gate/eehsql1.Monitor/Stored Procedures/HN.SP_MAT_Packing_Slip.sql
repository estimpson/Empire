SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [HN].[SP_MAT_Packing_Slip]( 
 @Shipper numeric(5,0)
)
	
AS

EXECUTE EEISQL1.Monitor.dbo.eeisp_form_d_eei_shipper @Shipper
GO
