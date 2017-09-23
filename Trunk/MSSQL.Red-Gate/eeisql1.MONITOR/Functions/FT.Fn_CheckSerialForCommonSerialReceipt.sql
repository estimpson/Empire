SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Andre S. Boulanger Fore-thought, LLC
-- Create date: 2016-06-03
-- Description:	Returns 1 is Serial can be received; Returns 0 if serial should not be received; It is used in the procedure [FT].[ftsp_CommonSerialReceiveSerials]
-- =============================================
CREATE FUNCTION [FT].[Fn_CheckSerialForCommonSerialReceipt]
(
	
	@Serial int
)
RETURNS INT
AS
BEGIN
	
	DECLARE @LastReceiptDate datetime
	DECLARE @LastRTVDate datetime
	DECLARE @ReturnResult INT

	
	SELECT @LastReceiptDate = 
				Coalesce((	Select max(date_stamp)
						From
							audit_trail at
						Where
							at.type = 'R' and
							at.serial =  @Serial
					), '1900-01-01')
					
			
				
				SELECT @LastRTVDate = 
				Coalesce((	Select max(date_stamp)
						From
							audit_trail at
						Where
							at.type = 'V' and
							at.serial =  @Serial
					), '1900-01-02')
					
				if  @LastRTVDate > @LastReceiptDate
		
					Select @ReturnResult = 1
					
					Else
						Select @ReturnResult = 0
						
				RETURN @ReturnResult
				

END
GO
