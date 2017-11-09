SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[usp_WP_UpdateCsmDemand_EmpireFactor_GetHistoryNotes] 
	@BasePart varchar(50)	
,	@StartDate datetime
,	@EndDate datetime
as
set nocount on
set ansi_warnings off

--- <Body>
select
	base_part as BasePart
,	time_stamp as DateStamp
,	note as Note
from
	EEIUser.acctg_csm_base_part_notes bpn
where
	bpn.base_part = @BasePart
	and bpn.time_stamp between @StartDate and @EndDate
order by
	time_stamp asc
--- </Body>

GO
