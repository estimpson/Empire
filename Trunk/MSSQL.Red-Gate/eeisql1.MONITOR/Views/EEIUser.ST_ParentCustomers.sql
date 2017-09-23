SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [EEIUser].[ST_ParentCustomers]
as
select
	isnull(f.parent_customer, '') as ParentCustomer
from 
	EEIUser.acctg_csm_NAIHS acn 
	join EEIUser.acctg_csm_vw_select_sales_forecast f
		on f.mnemonic = acn.[Mnemonic-Vehicle/Plant]
group by
	f.parent_customer
GO
