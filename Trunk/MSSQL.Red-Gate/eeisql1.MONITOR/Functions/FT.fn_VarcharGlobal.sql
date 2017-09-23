SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [FT].[fn_VarcharGlobal]
(	@GlobalName varchar (50) )
returns varchar (255)
as
begin
	declare	@ReturnVarchar varchar (255)

	select	@ReturnVarchar = Value
	from	FT.VarcharGlobals
	where	Name = @GlobalName

	return	@ReturnVarchar
end
GO
