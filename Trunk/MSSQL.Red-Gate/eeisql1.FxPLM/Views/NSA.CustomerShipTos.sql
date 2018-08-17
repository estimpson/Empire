SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[CustomerShipTos]
as
select
	CustomerCode = c.customer
,	ShipToCode = d.destination
,	CustomerName = c.name
,	ShipToName = d.name
,	Address1 = d.address_1
,	Address2 = d.address_2
,	Address3 = d.address_3
,	Address4 = d.address_4
,	Address5 = d.address_5
,	Address6 = d.address_6
from
	MONITOR.dbo.customer c
	join MONITOR.dbo.destination d
		on d.customer = c.customer
where
	coalesce(c.region_code, '') != 'INTERNAL'
GO
