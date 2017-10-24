SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [HN].[fn_Inventory_FIFObyPart] (@Part char(25), @Plant varchar(15))
RETURNS @Objects table
	(	Serial int,
		Location varchar (10),
		Quantity numeric (20, 6),
		FirstDT datetime null, 
		WeeksOnStock int,
		Status varchar(1),
		Fifo char(1) null)
as
BEGIN

Declare @FindPart varchar(25) 
set @FindPart =ltrim(rtrim(@Part))

insert into @Objects( Serial, Location, Quantity,FirstDT, WeeksOnStock, Status )
Select	Serial,
		Location,
		Quantity,
		ObjectBirthday,
		weeks_on_stock,
		status
from	[HN].[vw_FifoOnHold_Object]
where	part=@FindPart
/*
Select	Serial, 
		location, 
		quantity, 
		o.ObjectBirthday, 
		weeks_on_stock=case when datediff(week,o.ObjectBirthday,getdate())>12 then 13 else datediff(week,o.ObjectBirthday,getdate()) end,
		o.Status
from	object o
	left join location loc
		 on o.location = loc.code
where	part <> 'pallet'
	and quantity >0
	and part=@Part
	and location not like '%STAGE%'		
	and o.status='H'
		and o.location not like '%FIS'
		and o.location not like '%-%F'
		and o.location not like 'QC%'
		*/

Declare	@MaxWeekOnStock int
SET	@MaxWeekOnStock = (select max(WeeksOnStock) from @Objects)					

UPDATE	@Objects
set	Fifo = '*'
where WeeksOnStock= @MaxWeekOnStock
	

RETURN
END


GO
