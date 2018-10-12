SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[EEIsp_rpt_blanketPONew] (@vendor varchar(15))
as
Begin 
 SELECT 		Distinct (CASE WHEN part.cross_ref is NULL or part.cross_ref='' THEN part_vendor.vendor_part ELSE part.cross_ref END), 
 		po_header.po_number, 
 		po_header.vendor_code, 
 		po_header.blanket_part, 
 		po_detail.unit_of_measure, 
 		po_detail.date_due, 
 		po_detail.quantity, 
 		po_detail.received, 
 		po_detail.balance, 
 		po_header.terms, 
 		po_header.fob, 
 		po_header.ship_via, 
 		po_header.plant, 
 		destination.name, 
 		destination.address_1, 
 		destination.address_2, 
 		destination.address_3, 
 		po_header.type,
 		isNULL((select 	(stdqty + accumadjust) 
 		  from 	ft.poreceipttotals
 		  where	ft.poreceipttotals.poNumber = po_header.po_number and
 		  			ft.poreceipttotals.part = po_header.blanket_part),0) as received_qty,
 		  part_vendor.lead_time,
 		  po_detail.alternate_price,
 		  vendor.contact,
 		  vendor.address_6, 		  
 		  vendor.fax,
 		  vendor.phone,
 		 (select 	LastReceivedDT 
 		  from 	ft.poreceipttotals
 		  where	ft.poreceipttotals.PONumber = po_header.po_number and
 		  			ft.poreceipttotals.Part = po_header.blanket_part) as last_rec_date,
 		 (select  isnull( max(audit_trail.shipper), '' )
                from    audit_trail
                where   audit_trail.part = po_header.blanket_part and
                        audit_trail.date_stamp =  (select 	LastReceivedDT 
 		  from 	ft.poreceipttotals
 		  where	ft.poreceipttotals.PONumber = po_header.po_number and
 		  			ft.poreceipttotals.Part = po_header.blanket_part) and
                        audit_trail.po_number = convert(varchar(30), po_header.po_number) and
                        audit_trail.type = 'R') as last_rec_id
 		  
 		
 		  
 FROM   		 po_header 		
 
 LEFT OUTER JOIN 		po_detail ON po_header.po_number = po_detail.po_number
 JOIN								vendor ON po_header.vendor_code = vendor.code
 JOIN								part ON po_header.blanket_part = part.part
 JOIN								part_online on po_header.po_number = part_online.default_po_number
 LEFT OUTER JOIN 		destination ON po_header.ship_to_destination=destination.destination
 LEFT OUTER JOIN 		part_vendor  ON po_header.blanket_part = part_vendor.part and po_header.vendor_code = part_vendor.vendor


 		
 WHERE 		po_header."type"='B' AND
 					po_header.status <> 'C' AND
 					vendor.code = @vendor AND
 					po_header.vendor_code = @vendor
 		
ORDER BY	po_header.po_number, po_detail.date_due

End
GO
