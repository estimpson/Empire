SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE function  [dbo].[fn_ReturnSecondLatestCSMRelease] (@ForeCastVersion varchar(10))

returns varchar (10)
as
begin
	declare	@ReturnReleaseID varchar (10)

	--select	@ReturnReleaseID = max(release_id) from eeiuser.acctg_csm_NACSM where  release_id like '2%' and version = @ForeCastVersion
	select @ReturnReleaseID = '2011-12'


	return	@ReturnReleaseID
end



GO
