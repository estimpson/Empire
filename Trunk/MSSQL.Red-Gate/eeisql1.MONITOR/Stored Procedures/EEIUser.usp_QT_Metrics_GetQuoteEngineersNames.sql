SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Metrics_GetQuoteEngineersNames]
as
set nocount on
set ansi_warnings off

--- <Body>
select
	qei.FirstName
,	qei.LastName
from
	EEIUser.QT_EngineeringInitials qei
where
	coalesce(qei.FirstName, '') != ''
	and coalesce(qei.LastName, '') != ''
--- </Body>
GO
