SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Customer_Codes_Get]
as
set nocount on
set ansi_warnings on


--- <Body>
select
	c.CustomerCode
from
	eeiuser.QT_CustomersNew c
where
	c.[Status] = 0
order by
	c.CustomerCode
--- </Body>


GO
