SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [HN].[fn_PickList_ShipperList_ByPlant]
(@Plant varchar(10) = 'EEI')	
returns @List table
(	ShipperID int,
	Shipper varchar(25))
as
begin

	Insert into @List
	Select	ShipperID, Shipper
	from (
	--Select	ShipperID = NULL, Shipper='Selected one', Orden=0 
	Select	ShipperID = -1, Shipper='Selected one', Orden=0 
	union all 
	--Select	ShipperID = id, Shipper=convert(varchar,id), Orden=1 
	Select	ShipperID = id, Shipper=convert(varchar,id) + '-' + destination, Orden=1 
	FROM shipper 
	where isnull(plant,'EEI')=@Plant 
	and date_stamp>=dateadd(day,-7,getdate()) and status in ('O','S') ) Data
	order by Orden, ShipperID



--Cambios a realizar.
--Select	ShipperID = -1, Shipper='Selected one', Orden=0 
--Select	ShipperID = id, Shipper=convert(varchar,id) + '-' + destination, Orden=1 

return
end
GO
