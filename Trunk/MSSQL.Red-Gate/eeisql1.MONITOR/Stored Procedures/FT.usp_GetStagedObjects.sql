SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[usp_GetStagedObjects] 
	@Shipper int
as 

select 
	o.part as Part
,	o.quantity as Quantity
,	o.serial as Serial
from
	dbo.shipper s
	join dbo.object o
		on o.shipper = s.id
where
	s.id = @Shipper
order by
	o.serial
GO
