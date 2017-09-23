SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_shipments_not_in_realTime]
as

Select Shipments.part, ShipperID, userentereddate, actualdate, qty_packed as QtyShipped from 
(select max(serial) MaxSerial, part, convert(int,shipper) as ShipperID, convert(char(10), date_stamp,111) as userentereddate, convert(char(10), dbDAte,111) as actualdate
 from audit_trail where type = 'S' and date_stamp > '2007-07-01'  and  datepart(m, date_stamp)<> datepart(m,dbdate)
group by part, shipper, convert(char(10), date_stamp,111) , convert(char(10), dbDAte,111) ) ShipMents
join shipper_detail on Shipments.shipperID = shipper_detail.shipper and Shipments.Part = part_original 
GO
