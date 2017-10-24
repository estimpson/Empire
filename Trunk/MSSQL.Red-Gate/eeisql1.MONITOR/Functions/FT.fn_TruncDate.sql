SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [FT].[fn_TruncDate]
(	@DatePart nvarchar (25),
	@ArgDT datetime)
returns datetime
begin
	declare @ReturnDT datetime
	set	@ReturnDT = FT.fn_DateAdd (@DatePart, FT.fn_DateDiff (@DatePart, '1995-01-01', @ArgDT), '1995-01-01')
	return	@ReturnDT
end

GO
