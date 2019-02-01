SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Customer_Get]
	@CustomerCode varchar(50)
as
set nocount on
set ansi_warnings on


--- <Body>
select
	c.CustomerName
,	c.Address1
,	c.Address2
,	c.Address3
,	c.City
,	c.[State]
,	c.Country
,	c.PostalCode
,	c.Terms
,	c.LtaType
from
	eeiuser.QT_CustomersNew c
where
	c.CustomerCode = @CustomerCode
--- </Body>


GO
