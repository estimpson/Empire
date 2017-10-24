SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[fn_ReturnDueDate]
(	@ArgDT datetime,
	@Terms	varchar (20) )
returns	Datetime
begin
	declare	@ReturnDT Datetime
	
Set	@ReturnDT = 
	(CASE WHEN	@Terms = 'NET 60'
	THEN	dateadd (day, 60, @ArgDT)
	WHEN	@Terms in ('NET 45', 'NET 45 WITH VMI', '1% NET 45')
	THEN	dateadd (day, 45, @ArgDT)
	WHEN	@Terms = 'NET 30'
	THEN	dateadd (day, 30, @ArgDT)
	WHEN	@Terms =  '2D 2M'
	THEN	DateAdd (day, 1, DateAdd (month, 1, FT.fn_TruncDate('Month', dateadd (day, 30, @ArgDT))))
	WHEN	@Terms =  '15D 2M'
	THEN	DateAdd (day, 14, DateAdd (month, 1, FT.fn_TruncDate('Month', dateadd (day, 30, @ArgDT))))
	WHEN	@Terms =  '5D 2M'
	THEN	DateAdd (day, 4, DateAdd (month, 1, FT.fn_TruncDate('Month', dateadd (day, 30, @ArgDT))))
	WHEN	@Terms in ('30D EOM +10')
	THEN	DateAdd (day, 9, DateAdd (month, 1, FT.fn_TruncDate('Month', dateadd (day, 30, @ArgDT))))
	WHEN	@Terms in ('30D EOM +20')
	THEN	DateAdd (day, 19, DateAdd (month, 1, FT.fn_TruncDate('Month', dateadd (day, 30, @ArgDT))))
	WHEN	@Terms =  '30TH PROX'
	THEN	DateAdd (day, 29, FT.fn_TruncDate('Month', dateadd (day, 2, @ArgDT)))
	WHEN	@Terms = 'PROX 25'
	THEN	DateAdd (day, 24, FT.fn_TruncDate('Month', dateadd (day, 7, @ArgDT)))
	WHEN	@Terms = 'PROX 15'
	THEN	 DateAdd (day, 14, FT.fn_TruncDate('Month', dateadd (day, 17, @ArgDT)))
	WHEN	@Terms = '55D'
	THEN	dateadd (day, 55, @ArgDT)
	WHEN	@Terms  in ('60D EOM + 2', '60D EOM +2') 
	THEN	DateAdd (day, 1, DateAdd (month, 1, FT.fn_TruncDate('Month', dateadd (day, 60, @ArgDT))))
	WHEN	@Terms =  'NET 15'
	THEN	dateadd (day, 15, @ArgDT)
	WHEN	nullif(@Terms,'') is null or @Terms in ('NET 0', 'C I A', 'CIA')
	THEN	@ArgDT
	ELSE		dateadd (day, 30, @ArgDT)
	END)
		
	return @ReturnDT
end
GO
