SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function  [dbo].[fn_ReturnLatestCSMRelease] (@ForeCastVersion varchar(10))

returns varchar (10)
as
begin
	declare	@ReturnReleaseID varchar (10)

	select	@ReturnReleaseID = max(release_id) from eeh.dbo.csm_NACSM where  release_id like '2%' and version = @ForeCastVersion
	
	return	@ReturnReleaseID
end
GO
