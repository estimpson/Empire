SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FT].[fn_GetLinkedServer]
(	@Name sysname)
returns sysname
as
begin
	declare	@LinkedServer sysname

	select	@LinkedServer = LinkedServer
	from	FT.LinkedServers
	where	Name = @Name

	return	@LinkedServer
end
GO
