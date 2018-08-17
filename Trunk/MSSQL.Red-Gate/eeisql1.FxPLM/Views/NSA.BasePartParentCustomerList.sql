SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[BasePartParentCustomerList]
as
select distinct
	bpa.BasePartCustomer
,	bpa.ParentCustomer
from
	NSA.BasePartAttributes bpa
GO
