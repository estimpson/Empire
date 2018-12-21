SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Customer_LtaTypes_Get]
as
set nocount on
set ansi_warnings on


--- <Body>
select
	lt.LtaType
from
	eeiuser.QT_LtaTypes lt
order by
	lt.LtaType
--- </Body>


GO
