SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[fn_Today]
( )
returns	datetime
as
begin
	declare	@ResultDT datetime

	select	@ResultDT = DateAdd ( day, DateDiff ( day, '2001-01-01', CurrentDatetime ), '2001-01-01' )
	from	vwGetDate

	return	@ResultDT
end
GO
