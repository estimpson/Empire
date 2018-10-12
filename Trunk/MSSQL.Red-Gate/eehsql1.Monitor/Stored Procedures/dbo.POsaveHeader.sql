SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[POsaveHeader] 
as
Declare @po_number varchar(10),		@vendor_code varchar(10),
        @po_date datetime,        @terms varchar(20),
        @fob varchar(20),        @ship_via varchar(15),
        @ship_to_destination varchar(25), @status varchar(1),
        @type varchar(1), @plant varchar(10),
        @freight_type varchar(20), @ship_type varchar(10),
        @flag int, @release_no int, @release_control varchar(1),
        @currency_unit varchar(3), @cum_received_qty int,
        @blanket_part varchar(25)
                          
	
BEGIN
	
	

   INSERT INTO po_header
                      (po_number, vendor_code, po_date, terms, fob, ship_via, ship_to_destination, status, type, plant, freight_type, blanket_part, ship_type, flag, release_no, 
                      release_control, currency_unit, cum_received_qty)
VALUES     (@po_number,@vendor_code,@po_date,@terms,@fob,@ship_via,@ship_to_destination,@status,@type,@plant,@freight_type,@blanket_part,@ship_type,@flag,@release_no,@release_control,@currency_unit,@cum_received_qty)
END
GO
