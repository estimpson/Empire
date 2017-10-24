SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[eeivw_ars_exception_noorderstatus]
as 

SELECT  "part_eecustom"."part",
			"part_online"."default_po_number",
			"non_order_note",
			iSnull((select  max(PostDemandAccum) 
			from 		ft.wknmps 
			where 	FT.wknmps.part = part_eecustom.part and 
						part_online.default_po_number = po_header.po_number),0) as total_net_demand,
			ISnull((select  sum(po_detail.balance) 
				from 	po_detail 
				where po_detail.part_number = part_eecustom.part and 
						part_online.default_po_number = po_detail.po_number),0) as total_on_defaultPO,
			ISnull((select  sum(po_detail.balance) 
				from 	po_detail 
			where 	po_detail.part_number = part_eecustom.part and 
						part_online.default_po_number <> po_detail.po_number),0) as total_not_on_defaultPO,
			iSnull((select  max(standardPack) 
			from 		ft.wknmps 
			where 	FT.wknmps.part = part_eecustom.part and 
						part_online.default_po_number = po_header.po_number),0) as stdPack
			
    FROM "part_eecustom",   
         "part_online",   
         "po_header"  
   WHERE ( "part_eecustom"."part" = "part_online"."part" ) and  
         ( "part_online"."default_po_number" = "po_header"."po_number" ) and  
        	( "po_header"."blanket_part" = "part_online"."part") and
         (  "part_eecustom"."auto_releases" = 'Y'  )  and
			(  isNULL("part_eecustom"."Non_Order_Note",'') > '1' )  
GO
