SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [FT].[fn_DTGlobal]
(	@GlobalName varchar (25) )
returns datetime
as
begin
	declare	@ReturnDT datetime

	select	@ReturnDT = Value
	from	FT.DTGlobals
	where	Name = @GlobalName

	return	@ReturnDT
end
GO
