SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_QT_Customer_States_Get]
as
set nocount on
set ansi_warnings on


--- <Body>
select
	s.Abbreviation
,	s.Name
from
	dbo.States s
order by
	s.Abbreviation
--- </Body>
GO
