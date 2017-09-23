SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[CDIsp_ford_asn_detail]  (@shipper INTEGER)
AS

BEGIN

CREATE TABLE #atr_package_type (
		part			VARCHAR(25),
		package_type		VARCHAR(25),
		pack_qty 			NUMERIC(20,6),
		pack_count		INT
		)


CREATE TABLE #atr_objects(
		serial 		INT,
		part		VARCHAR(25),
		package_quantity	VARCHAR(25), 
		package_type	VARCHAR(25)
		)



INSERT 	#atr_package_type
SELECT 	audit_trail.part,
	COALESCE(NULLIF(audit_trail.package_type,''), 'CTN90'),
	audit_trail.quantity,
	COUNT(1)

FROM	audit_trail
		
WHERE	audit_trail.type = 'S' AND
	audit_trail.part <> 'PALLET' AND
	audit_trail.shipper = CONVERT(VARCHAR(25), @shipper)

GROUP BY	audit_trail.part,
	COALESCE(NULLIF(audit_trail.package_type,''), 'CTN90'),
	audit_trail.quantity



INSERT	#atr_objects

SELECT	audit_trail.serial,
	audit_trail.part,
	audit_trail.quantity,
	COALESCE(NULLIF(audit_trail.package_type,''), 'CTN90')

FROM	audit_trail

WHERE	audit_trail.type = 'S' AND
	audit_trail.part <> 'PALLET'  AND
	audit_trail.shipper = CONVERT(VARCHAR(25), @shipper)
	
	
SELECT 		edi_setups.prev_cum_in_asn,
		shipper_detail.customer_part, 
		shipper_detail.alternative_qty, 
		shipper_detail.alternative_unit, 
		shipper_detail.net_weight, 
		shipper_detail.gross_weight, 
		shipper_detail.accum_shipped, 
		shipper_detail.shipper, 
		shipper_detail.customer_po,
		(SELECT ISNULL(MAX(sd2.accum_shipped),0)
			FROM shipper_detail sd2
         		WHERE  sd2.order_no = shipper_detail.order_no AND
                       	CONVERT(DATETIME, sd2.date_shipped,110) = (SELECT 	MAX(CONVERT(DATETIME,sd3.date_shipped,110))
                       					FROM	shipper_detail sd3
                       					WHERE	sd3.order_no = shipper_detail.order_no AND
                       					CONVERT(DATETIME, sd3.date_shipped,110) < CONVERT(DATETIME,shipper_detail.date_shipped,110))) AS accum2,
                       	#atr_package_type.package_type AS pack_type,
                       	#atr_package_type.pack_count AS pack_count,
                       	#atr_package_type.pack_qty AS pack_quantity,
                       	#atr_objects.serial AS pack_serial	
 
FROM 		edi_setups, 
		shipper_detail,
		shipper,
		#atr_package_type,
		#atr_objects 

WHERE		( shipper.destination = edi_setups.destination) AND
		( shipper.id = @shipper) AND 
		( #atr_package_type.part = shipper_detail.part_original ) AND
		( #atr_objects.part = shipper_detail.part_original) AND
		( #atr_objects.part = #atr_package_type.part) AND
		( #atr_objects.package_quantity = #atr_package_type.pack_qty) AND
		( #atr_objects.package_type = #atr_package_type.package_type) AND		 
		( ( shipper_detail.shipper = @shipper ) ) 

ORDER BY	shipper_detail.customer_part,
		pack_type,
		pack_count,
		pack_quantity,
		pack_serial

END


GO
GRANT EXECUTE ON  [dbo].[CDIsp_ford_asn_detail] TO [public]
GO
