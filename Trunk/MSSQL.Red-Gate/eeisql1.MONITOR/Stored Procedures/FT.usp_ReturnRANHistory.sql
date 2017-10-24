SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [FT].[usp_ReturnRANHistory] @RanNumber varchar(50)
as
Begin
Select  
		Status, 
		ShipToCode,
		CustomerPart,
		CustomerPO,
		ReleaseNo as RANNumber,
		ReleaseDT as ShipmentDueDate,
		RowCreateDT as DateEDIProcessed
		
	From 
	EDI.NAL_862_Releases where ReleaseNo like '%'+ @RanNumber + '%'
	End
	
GO
