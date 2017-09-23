SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Metrics_GetNavigationGroupItems]
	@NavigationGroup varchar(100)
as
set nocount on
set ansi_warnings off

--- <Body>
-- Get all navigation items for the group
select 
	ni.NavigationItem
from
	EEIUser.ST_Metrics_NavigationGroups ng
	join EEIUser.ST_Metrics_NavigationItems ni
		on ni.NavigationGroup = ng.NavigationGroup
where
	ng.NavigationGroup = @NavigationGroup
order by
	ni.Sequence
--- </Body>
GO
