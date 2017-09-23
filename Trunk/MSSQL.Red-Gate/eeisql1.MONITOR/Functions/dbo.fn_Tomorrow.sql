SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[fn_Tomorrow]
( )
returns	datetime
as
begin
	declare	@ResultDT datetime

	select	@ResultDT = dbo.fn_Today ( ) + 1

	return	@ResultDT
end
GO
