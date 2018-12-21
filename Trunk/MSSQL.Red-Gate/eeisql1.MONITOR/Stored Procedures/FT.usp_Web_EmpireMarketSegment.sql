SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[usp_Web_EmpireMarketSegment]
as
set nocount on
set ansi_warnings on


--- <Body>
select
	ems.EmpireMarketSegment
,	case
		when ems.[Status] = 0 then 'Waiting Approval'
		when ems.[Status] = 1 then 'Approved'
		when ems.[Status] = -1 then 'Denied'
	end as ApprovalStatus
,	case
		when ems.RowCreateUser = 'dbo' then ''
		else e.name 
	end as Requestor
,	ems.RequestorNote
,	ems.ResponseNote
from
	eeiuser.QT_EmpireMarketSegment ems
	left join dbo.employee e
		on e.operator_code = ems.RowCreateUser
order by
	case
		when ems.[Status] = 0 then 1
		when ems.[Status] = 1 then 2
		else 3
	end
,	ems.EmpireMarketSegment asc
--- </Body>

return
GO
