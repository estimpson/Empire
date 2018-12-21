SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Heber Murillo
-- Create date: 02-12-2018
-- Description:	Lista los Shipper
-- =============================================
CREATE FUNCTION [HN].[FN_ShippingDock_ShipperList]
()


RETURNS 
@List TABLE

(	ShipperID int,
	Date_S  datetime,
	Dest_Code varchar(20),
	Customer_Name varchar(200),
	Ship_via varchar(20),
	St varchar(1), 
	Prt  varchar(1), 
    BOL varchar(1),
	Pallets int ,
	Boxes int, 
	BOL_Number int,
	Ship_time datetime,
	picklist_printed varchar(10),
	Plant varchar(10)

	)

AS
BEGIN
	
	Insert into @List
	Select	ShipperID=
	 shipper.id,  shipper.date_stamp , shipper.destination, customer.name,  shipper.ship_via, shipper.status,
	 shipper.printed, BOL= CASE WHEN shipper.bill_of_lading_number is null then null else 1 end, shipper.staged_pallets ,
	  shipper.staged_objs, shipper.bill_of_lading_number, shipper.scheduled_ship_time , shipper.picklist_printed, shipper.plant
	  FROM dbo.shipper shipper
		join dbo.customer customer on customer.customer = shipper.customer 
	WHERE   date_stamp>=dateadd(day,-7,getdate()) and status in ('O','S') 
	order by  ShipperID
	
	RETURN 
END
GO
