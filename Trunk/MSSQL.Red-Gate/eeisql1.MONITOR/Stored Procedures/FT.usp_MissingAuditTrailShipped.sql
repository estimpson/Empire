SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[usp_MissingAuditTrailShipped]
as 
Select  shipper.date_shipped, 
			shipper.id, 
			part_original, 
			qty_packed as ShipperDetailQty
into
	#ShipperDetail
From
	shipper_detail 
join
	shipper on shipper.id = shipper_detail.shipper


where
	shipper.date_shipped >= '2015-01-01' and
	shipper.type is NULL 
	
 Select SUM(quantity) atQty,
			part,
			convert(int, shipper) Shipper
		into 
			#AuditTrail
			From audit_trail
			where type = 'S' and 
						date_stamp>= '2015-01-01'
			group by
			part,
			convert(int, shipper)
				

Select * From
	#ShipperDetail sd
Left join
	#AuditTrail at on at.Shipper =  sd.id and at.part =  sd.part_original
Where
	sd.ShipperDetailQty != coalesce(atQty,0)
	
	order by 1 asc
	
GO
