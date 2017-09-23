SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Metrics_GetNavigationGroups]
as
set nocount on
set ansi_warnings off

--- <Body>
select
	ng.NavigationGroup
from
	EEIUser.QT_Metrics_NavigationGroups ng
order by
	ng.Sequence
--- </Body>
GO
