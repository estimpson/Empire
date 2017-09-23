SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[fn_ReturnCustomerCheckReceiptDate]
(	@ArgDT datetime,
	@Terms	varchar (20),
	@Customer varchar (20) )
returns	Datetime
begin
	declare	@ReturnDT Datetime
	
Set	@ReturnDT = 
	(CASE WHEN	@customer = 'ALC'
	THEN	DateAdd (day, 6, FT.fn_TruncDate ('Week', [dbo].[fn_ReturnDueDate] ( @ArgDT, @Terms)))
	WHEN	@customer = 'AUTOSYSTEM'
	THEN	DateAdd (week, 2 * (DateDiff (week, '2008-01-07', [dbo].[fn_ReturnDueDate] ( @ArgDT, @Terms))/ 2) + 2, '2008-01-07')
	WHEN	@customer = 'TRW-AUTO'
	THEN	DateAdd (day, 2, FT.fn_TruncDate ('Month', DateAdd (day, 15, [dbo].[fn_ReturnDueDate] ( @ArgDT, @Terms))))
	WHEN	@customer = 'GUIDEMEX'
	THEN	DateAdd (day, 12, FT.fn_TruncDate ('Week', [dbo].[fn_ReturnDueDate] ( @ArgDT, @Terms)))
	WHEN	@customer = 'NALFLORA'
	THEN	DateAdd (day, 5, FT.fn_TruncDate ('Week', [dbo].[fn_ReturnDueDate] ( @ArgDT, @Terms)))
	WHEN	@customer = 'GMP'
	THEN	DateAdd (day, 1, FT.fn_TruncDate ('Week', [dbo].[fn_ReturnDueDate] ( @ArgDT, @Terms)))
	WHEN	@customer = 'TRW-2'
	THEN	DateAdd (day, 4, FT.fn_TruncDate ('Week', [dbo].[fn_ReturnDueDate] ( @ArgDT, @Terms)))
	WHEN	@customer = 'ALCQRO'
	THEN	DateAdd (day, -1, dateadd (month, 1, FT.fn_TruncDate ('Month', DateAdd (day, 10, [dbo].[fn_ReturnDueDate] ( @ArgDT, @Terms)))))
	ELSE		dateadd (day, 10, [dbo].[fn_ReturnDueDate] ( @ArgDT, @Terms))
	END)
		
	return @ReturnDT
end
GO
