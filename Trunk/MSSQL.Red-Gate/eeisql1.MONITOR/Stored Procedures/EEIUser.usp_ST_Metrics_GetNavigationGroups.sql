SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Metrics_GetNavigationGroups]
as
set nocount on
set ansi_warnings off

--- <Body>
select
	ng.NavigationGroup
from
	EEIUser.ST_Metrics_NavigationGroups ng
order by
	ng.Sequence
--- </Body>
GO
