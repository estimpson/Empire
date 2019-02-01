SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[usp_Web_QuoteLog_NewCustomer_GetRequests]
as
set nocount on
set ansi_warnings on


--- <Body>
select
	cn.CustomerCode
,	cn.CustomerName
,	cn.Address1
,	cn.Address2
,	cn.Address3
,	cn.City
,	cn.[State]
,	cn.Country
,	cn.PostalCode
,	cn.Terms
,	cn.LtaType
,	e.name as Requestor
,	cn.ResponseNote as LastResponse
from
	eeiuser.QT_CustomersNew cn
	left join dbo.employee e
		on e.operator_code = cn.RowCreateUser
where
	cn.[Status] = 0
order by
	cn.RowCreateDT asc
--- </Body>

return
GO
