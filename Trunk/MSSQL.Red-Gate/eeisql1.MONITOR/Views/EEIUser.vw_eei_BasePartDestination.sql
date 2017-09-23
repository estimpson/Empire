SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [EEIUser].[vw_eei_BasePartDestination]
as
Select	distinct basepart, 
		oem, 
		program, 
		vehicle, 
		partname,
		order_header.destination,
		destination.address_1,
		destination.address_2,
		destination.address_3		
from		[dbo].[vw_flatCSM]
left		join order_header on basepart = left(blanket_part,7)
join		destination on order_header.destination = destination.destination
GO
