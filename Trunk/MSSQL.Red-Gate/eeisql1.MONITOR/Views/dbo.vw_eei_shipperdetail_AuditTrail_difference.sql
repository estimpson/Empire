SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [dbo].[vw_eei_shipperdetail_AuditTrail_difference]
as
Select * from (Select shipper.type, shipper, part, qty_packed, (select sum(quantity) from audit_trail where type = 'S' and part = shipper_detail.part and shipper = convert(varchar(10), shipper_detail.shipper) ) atQtyShipped, (Select sum(quantity) 
from object where part = shipper_detail.part ) ObjectQty from shipper_detail, shipper  where shipper.id = shipper and shipper >= 33569 and shipper.date_shipped is not null and shipper.type is NULL ) ShipperReconcile
where isNULL(qty_packed,0) != isNULL(atQtyShipped,0)
GO
