SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [dbo].[vw_eei_mitsubishi_inventory] as
	select	sum(std_quantity) Qty,
			part,
			isNULL(station, '') PONumber
	from		object
	where	part like 'MIT%'
	group by	part,
			isNULL(station, '')
			
GO
