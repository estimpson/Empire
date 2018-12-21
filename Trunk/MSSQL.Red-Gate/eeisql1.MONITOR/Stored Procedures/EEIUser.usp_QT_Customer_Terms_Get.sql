SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_QT_Customer_Terms_Get]
as
set nocount on
set ansi_warnings on


--- <Body>
select
	t.[description] as Term
from
	dbo.term t
order by
	t.[description]
--- </Body>


GO
