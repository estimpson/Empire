SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[ftsp_asn_detail_masterserial_nascote] (@shipper int)
as
Begin

--[dbo].[ftsp_asn_detail_masterserial_nascote] 55570

Create table #atr_package_type (
		part			varchar(25),
		ParentSerial	int,
		package_type	varchar(25),
		pack_qty 		numeric(20,6),
		pack_count		int
		)

Insert 	#atr_package_type
Select 	audit_trail.part,
		audit_trail.parent_serial,
		'PLT71',
		SUM(audit_trail.quantity),
		max(1)

From	audit_trail
		
Where	audit_trail.type = 'S' and
		audit_trail.part <> 'PALLET' and
		nullif(parent_serial,0) is not null and		
		audit_trail.shipper = CONVERT(varchar(25), @shipper)

Group By	audit_trail.part,
				audit_trail.parent_serial
				
Create table #atr_package_typeo (
		part			varchar(25),
		package_type		varchar(25),
		pack_qty 			numeric(20,6),
		pack_count		int
		)


Create table #atr_objectso(
		serial 		int,
		part		varchar(25),
		package_quantity	varchar(25), 
		package_type	varchar(25)
		)



Insert 	#atr_package_typeo
Select 	audit_trail.part,
		'CTN25',
		audit_trail.quantity,
		count(1)

From	audit_trail
		
Where	audit_trail.type = 'S' and
		audit_trail.part <> 'PALLET' and
		nullif(parent_serial,0) is null and
		audit_trail.shipper = CONVERT(varchar(25), @shipper)

Group By	audit_trail.part,
			audit_trail.quantity



Insert	#atr_objectso

Select	audit_trail.serial,
		audit_trail.part,
		audit_trail.quantity,
		'CTN25'

From	audit_trail

Where	audit_trail.type = 'S' and
		audit_trail.part <> 'PALLET'and
		nullif(parent_serial,0) is null and
		audit_trail.shipper = CONVERT(varchar(25), @shipper)


SELECT 	COALESCE(edi_setups.prev_cum_in_asn,'N')	,
		shipper_detail.customer_part, 
		shipper_detail.alternative_qty, 
		shipper_detail.alternative_unit, 
		shipper_detail.net_weight, 
		shipper_detail.gross_weight, 
		shipper_detail.accum_shipped, 
		shipper_detail.shipper, 
		shipper_detail.customer_po,
		(SELECT isNULL(max(sd2.accum_shipped),0)
			FROM shipper_detail sd2
         		WHERE  sd2.order_no = shipper_detail.order_no and
                       	convert(datetime, sd2.date_shipped,110) = (SELECT 	max(convert(datetime,sd3.date_shipped,110))
                       					FROM	shipper_detail sd3
                       					WHERE	sd3.order_no = shipper_detail.order_no and
                       					convert(datetime, sd3.date_shipped,110) < convert(datetime,shipper_detail.date_shipped,110))) as accum2,
                       	#atr_package_type.package_type as pack_type,
                       	#atr_package_type.pack_count as pack_count,
                       	#atr_package_type.pack_qty as pack_quantity,
                       	#atr_package_type.ParentSerial as pack_serial	
 
FROM 	edi_setups, 
		shipper_detail,
		shipper,
		#atr_package_type

WHERE		( shipper.destination = edi_setups.destination) and
		( shipper.id = @shipper) and 
		( #atr_package_type.part = shipper_detail.part_original ) and		 
		( ( shipper_detail.shipper = @shipper ) ) 
		
union all

SELECT 	COALESCE(edi_setups.prev_cum_in_asn,'N')	,
		shipper_detail.customer_part, 
		shipper_detail.alternative_qty, 
		shipper_detail.alternative_unit, 
		shipper_detail.net_weight, 
		shipper_detail.gross_weight, 
		shipper_detail.accum_shipped, 
		shipper_detail.shipper, 
		shipper_detail.customer_po,
		(SELECT isNULL(max(sd2.accum_shipped),0)
			FROM shipper_detail sd2
         		WHERE  sd2.order_no = shipper_detail.order_no and
                       	convert(datetime, sd2.date_shipped,110) = (SELECT 	max(convert(datetime,sd3.date_shipped,110))
                       					FROM	shipper_detail sd3
                       					WHERE	sd3.order_no = shipper_detail.order_no and
                       					convert(datetime, sd3.date_shipped,110) < convert(datetime,shipper_detail.date_shipped,110))) as accum2,
                       	#atr_package_typeo.package_type as pack_type,
                       	#atr_package_typeo.pack_count as pack_count,
                       	#atr_package_typeo.pack_qty as pack_quantity,
                       	#atr_objectso.serial as pack_serial	
 
FROM 		edi_setups, 
		shipper_detail,
		shipper,
		#atr_package_typeo,
		#atr_objectso 

WHERE		( shipper.destination = edi_setups.destination) and
		( shipper.id = @shipper) and 
		( #atr_package_typeo.part = shipper_detail.part_original ) and
		( #atr_objectso.part = shipper_detail.part_original) and
		( #atr_objectso.part = #atr_package_typeo.part) and
		( #atr_objectso.package_quantity = #atr_package_typeo.pack_qty) and
		( #atr_objectso.package_type = #atr_package_typeo.package_type) and		 
		( ( shipper_detail.shipper = @shipper ) ) 

ORDER BY	2,
		11,
		12,
		13,
		14




End







GO
