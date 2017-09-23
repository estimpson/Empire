SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [FT].[fn_ShipDate]
(	@DatePart nvarchar (25),
	@ShipDay nvarchar(25),
	@ArgDT datetime)
returns datetime
begin
	declare	@ReturnDT datetime
	declare	@ShipDayInt int
	set			@ShipDayInt = (case 
													when @ShipDay = 'Monday' then 1
													when @ShipDay = 'Tuesday' then 2
													when @ShipDay = 'Wednesday' then 3
													when @ShipDay = 'Thursday' then 4
													when @ShipDay = 'Friday' then 5
													when @ShipDay = 'Saturday' then 6
													else 0 end)
	if		@ShipDayInt = 0
	begin
	
	set			@ReturnDT = @ArgDT
		
	end
	if		@ShipDayInt != 0
	begin
	
	set			@ReturnDT = FT.fn_DateAdd (@DatePart, FT.fn_DateDiff (@DatePart, '1995-01-01', @ArgDT), '1995-01-01')
	set			@ReturnDT =  FT.fn_DateAdd ('d', @ShipDayInt, @ReturnDT)
	

	end
	return		@ReturnDT
end


GO
