SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisP_edi_inalfa_desadv] (@shipper integer)

as
begin

create table #inalfapallets		
(palletid integer identity,
	pallet varchar (50))

insert #inalfapallets		
(pallet)

Select  
			distinct UPPER(edi_setups.supplier_code+(CASE WHEN audit_trail.serial > 999999 THEN '0' + convert( varchar(15),isNULL(audit_trail.parent_serial,0)) ELSE '00' +convert( varchar(15),isNULL(audit_trail.parent_serial,0)) END ))  
 FROM order_header,   
         	shipper,   
         	shipper_detail,
			audit_trail,
			edi_setups  
   WHERE ( edi_setups. destination = shipper.destination) and
			( audit_trail.shipper = convert(varchar(15),shipper.id)) and
			( audit_trail.part = order_header.blanket_part) and
			( audit_trail.type = 'S') and
			( shipper_detail.part_original = order_header.blanket_part ) and
			( shipper_detail.order_no = order_header.order_no ) and  
         	( shipper_detail.shipper = shipper.id ) and
			( shipper.id = convert(integer,@shipper) )    			


SELECT '4' pkg_level,
			'16' pkg_instruct,
			'EA' qty_ship_uom,
			'EA' cytd_ship_uom,
			order_header.our_cum,   
         shipper_detail.customer_po,   
         shipper_detail.customer_part,   
         shipper_detail.qty_packed,   
         shipper_detail.part_original,
			shipper_detail.boxes_staged,   
         shipper.model_year,
			UPPER(edi_setups.supplier_code+ (CASE WHEN audit_trail.serial > 999999 THEN '0' + convert( varchar(15),audit_trail.serial) ELSE '00' +convert( varchar(15),audit_trail.serial) END )) as li_plate,
			UPPER(edi_setups.supplier_code+(CASE WHEN audit_trail.serial > 999999 THEN '0' + convert( varchar(15),isNULL(audit_trail.parent_serial,0)) ELSE '00' +convert( varchar(15),isNULL(audit_trail.parent_serial,0)) END )) as p_li_plate,
			(Select count(1) from audit_trail at2 where at2.part = shipper_detail.part_original and at2.shipper = convert(varchar(15),shipper.id) and at2.parent_serial = audit_trail.parent_serial) as partpalletcount,
			(Select sum(quantity) from audit_trail at2 where at2.part = shipper_detail.part_original and at2.shipper = convert(varchar(15),shipper.id) and at2.parent_serial = audit_trail.parent_serial) as partpalletqty,
			palletid as palletline,
			order_header.standard_pack,
			audit_trail.quantity as Objectqty,
			order_header.line_feed_code,
			UPPER((CASE WHEN audit_trail.serial > 999999 THEN '0' + convert( varchar(15),isNULL(audit_trail.parent_serial,0)) ELSE '00' +convert( varchar(15),isNULL(audit_trail.parent_serial,0)) END )) 

			  
    FROM order_header,   
         shipper,   
         shipper_detail,
			audit_trail,
			edi_setups,
			#inalfapallets  
   WHERE ( edi_setups. destination = shipper.destination) and
   				 #inalfapallets.pallet = UPPER(edi_setups.supplier_code+(CASE WHEN audit_trail.serial > 999999 THEN '0' + convert( varchar(15),isNULL(audit_trail.parent_serial,0)) ELSE '00' +convert( varchar(15),isNULL(audit_trail.parent_serial,0)) END )) and
			( audit_trail.shipper = convert(varchar(15),shipper.id)) and
			( audit_trail.part = order_header.blanket_part) and
			( audit_trail.type = 'S') and  
			( shipper_detail.part_original = order_header.blanket_part ) and
			( shipper_detail.order_no = order_header.order_no ) and  
         ( shipper_detail.shipper = shipper.id ) and
			( shipper.id = convert(integer,@shipper) )    
			
			order by palletline, part_original, li_plate
			
end
GO
