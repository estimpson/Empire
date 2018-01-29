SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [TOPS].[usp_Test]
	@Part varchar(30)
as
begin

select
	p.name
from
	dbo.part p
where
	p.part = @Part

end
GO
