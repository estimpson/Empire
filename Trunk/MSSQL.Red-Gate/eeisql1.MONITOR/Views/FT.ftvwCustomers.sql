SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[ftvwCustomers]
(	Code,
	Name,
	AddressLine1,
	AddressLine2,
	AddressLine3,
	Contact )
as
select	customer, name, address_1, address_2, address_3, contact
from	dbo.customer
GO
