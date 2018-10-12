SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create	procedure [HN].[HCSP_Change_Object_Status](
				@Operator varchar(10),
				@lngSerial int, 
				@strUserDefinedStatus varchar(30), 
				@Note as varchar(254) = NULL, 
				@Result int OUTPUT )
as	
	exec EEH.HN.HCSP_Inv_Change_Object_Status
			@Operator = @Operator,
			@LngSerial = @LngSerial,
			@strUserDefinedStatus = @strUserDefinedStatus,
			@Note = @Note,
			@Result = @Result out
			
GO
