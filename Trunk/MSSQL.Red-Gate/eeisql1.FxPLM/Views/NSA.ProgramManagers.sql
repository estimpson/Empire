SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[ProgramManagers]
as
select
	UserName = u.UserName
,	UserCode = upper(u.UserCode)
,	UserInitials = u.Initials
,	EmailAddress = lower(left(coalesce(nullif(x.FirstName, ''), u.FirstName), 1) + coalesce(nullif(x.LastName, ''), u.LastName)) + '@empireelect.com'
,	RowID = isnull(row_number() over (order by u.UserCode), 0)
from
	MONITOR.EEIUser.QT_ProgramManagerInitials x
	left join NSA.Users u
		on u.Initials = x.Initials
		and u.UserName = coalesce(nullif(x.FirstName, '') + ' ' + nullif(x.LastName, ''), u.UserName)
where
	u.UserCode is not null
GO
