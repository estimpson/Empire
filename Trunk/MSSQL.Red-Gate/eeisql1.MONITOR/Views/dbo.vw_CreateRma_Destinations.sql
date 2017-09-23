SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_CreateRma_Destinations]
as
select 
	d.destination 
from 
	destination d 
	join shipper s
		on s.destination = d.destination
where
	s.date_shipped >= dateadd(dd, -90, getdate())	
group by
	d.destination
GO
