SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[udf_Today]
()
returns	datetime
as
begin
	declare	@ResultDT datetime

	select	@ResultDT = DateAdd ( day, DateDiff ( day, '2001-01-01', getdate() ), '2001-01-01' )

	return	@ResultDT
end

GO
