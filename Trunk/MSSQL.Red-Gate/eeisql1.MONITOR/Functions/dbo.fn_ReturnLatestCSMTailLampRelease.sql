SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE function  [dbo].[fn_ReturnLatestCSMTailLampRelease] ()

returns varchar (10)
as
begin
	declare	@ReturnReleaseID varchar (10)

	select	@ReturnReleaseID = max(release_id) from eeiuser.acctg_csm_study_tail_lamp where  release_id like '2%'
	--select @ReturnReleaseID = '2011-12'


	return	@ReturnReleaseID
end


GO
