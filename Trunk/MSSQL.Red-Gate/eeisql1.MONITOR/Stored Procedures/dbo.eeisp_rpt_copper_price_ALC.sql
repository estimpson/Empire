SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure	[dbo].[eeisp_rpt_copper_price_ALC] 
 
 as
Begin


---get surcharges 



create table #apitemsmetalsurcharge(
 						inv_cm_date			datetime,
 						vendor						varchar(25),
 						invoice_cm				varchar(25),
 						purchase_order		varchar(25),
 						item							varchar(25),
 						quantity					numeric(20,6),
 						metaladjustments	numeric(20,6),
 						unitcost					numeric(20,6),
 						costincrease			numeric(20,6),
 						totalunitcost				numeric(20,6))

insert #apitemsmetalsurcharge
 			
 			select 	Vw_eei_spread_metal_surcharges.inv_cm_date,
			 			Vw_eei_spread_metal_surcharges.vendor, 
						Vw_eei_spread_metal_surcharges.invoice_cm,
			 			Vw_eei_spread_metal_surcharges.purchase_order,
						ap_items.item, 
						ap_items.quantity,
						metaladjustments,
						Vw_eei_spread_metal_surcharges.price as cost,			
						surcharged_price-Vw_eei_spread_metal_surcharges.price,
						surcharged_price
			
from					Vw_eei_spread_metal_surcharges,
						ap_items
where				ap_items.invoice_cm = Vw_eei_spread_metal_surcharges.invoice_cm and
						ap_items.purchase_order = Vw_eei_spread_metal_surcharges.purchase_order and
						ap_items.vendor = Vw_eei_spread_metal_surcharges.vendor and 
						metaladjustments > 0 and ap_items.quantity>0

--get ALC Part Information

		create table #ALCPart(
					basepart	varchar(25) Primary Key,
					customer_part varchar (25),
					description	varchar(255),
					current_price	numeric(20,6),
					SOP	datetime,
					EOP	datetime,
					quote_date datetime,
					EAU		numeric(20,6)
					
)

insert	#ALCPart
Select part,
			(Select max(customer_part) from shipper_detail_eei where substring(shipper_detail_eei.part_original,1,7) = alc_quote_date.part and shipper_detail_eei.part_original not like '%RW%' and shipper_detail_eei.part_original not like '%PT%' ),
			(Select max(part_eei.name) from part_eei  where	substring(part_eei.part,1,7) = alc_quote_date.part and part_eei.part not like '%RW%' and part_eei.part not like '%PT%' ),
			isNULL((Select max(shipper_detail_eei.alternate_price) from shipper_detail_eei where date_shipped = (Select max(date_shipped) from shipper_detail_eei where substring(part_original,1,7) = alc_quote_date.part and part_original not like '%PT%' and alternate_price >0) and substring(part_original,1,7) = alc_quote_date.part and part_original not like '%PT%' and alternate_price >0), alc_quote_date.price),
			(Select	max(prod_start) from part_eecustom_eei where substring(part_eecustom_eei.part,1,7) = alc_quote_date.part and part_eecustom_eei.part not like '%RW%' and part_eecustom_eei.part not like '%PT%' ),
			(Select	max(prod_end) from part_eecustom_eei where substring(part_eecustom_eei.part,1,7) = alc_quote_date.part and part_eecustom_eei.part not like '%RW%' and part_eecustom_eei.part not like '%PT%' ),
			quote_date,
			(Select	max(eau) from part_eecustom_eei where substring(part_eecustom_eei.part,1,7) = alc_quote_date.part and part_eecustom_eei.part not like '%RW%' and part_eecustom_eei.part not like '%PT%' )
from		alc_quote_date




			
---get BOM Info for ALC Parts 			
 	
 					
 	create table #copperBOM(
 						FinPart				varchar(25),
 						part					varchar(25),
 						BOMQty			numeric(20,6)
 						)
 					
 					
 				insert		#copperBOM
 					Select		substring(FinishedPart,1,7),
 									RawPart,
 									Quantity
 					from			vweeiBOM
					
 					where		substring(finishedPart,1,7) in (Select basepart from #ALCPart) and RawPart in (Select part from part_vendor where vendor in ('DIXIEWIRE', 'DIXIEHON','COPPERFLD', 'ESSEX', 'ANIXTER') UNION (select distinct item from #apitemsmetalsurcharge ))
					and			finishedpart in (Select max(finishedpart) from vweeiBOM where substring(Finishedpart,1,7) in (select basepart from #ALCPart) and FinishedPart not like '%RW%' and finishedPart not like '%PT%'  group by substring(Finishedpart,1,7))
 					

 					
 					
 	create table		#ALCCopperBOM ( 					
 					FinPart							varchar(25),
 					CustomerPart				varchar(50),
 					CopperPart					varchar(25),
 					CopperBOMQty			numeric(20,6),
 					LastCopperInvDate		datetime,
 					FirstCopperInvDate		datetime,
 					FirstnonWireInvdate		datetime,
					LastnonWireInvdate		datetime
 					)


 						

 				
 					
 					
 				Insert	#ALCCopperBOM
 				Select	#ALCPart.basePart,
 							#ALCPart.customer_Part,
 							#CopperBOM.part,
 							#CopperBOM.BOMQty,
 							isNULL((select max(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date<=Getdate() and
 												ap_items.Item = #CopperBOM.part and
 												ap_items.Item not in ( select item from #apitemsmetalsurcharge) and
 												ap_items.price>0 and
 												ap_headers.pay_vendor in ('DIXIEWIRE')),(select max(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date<=getdate() and
 												ap_items.Item = #CopperBOM.part and
 												ap_items.Item not in ( select item from #apitemsmetalsurcharge) and
 												ap_items.price>0 and
 												ap_headers.pay_vendor  in ('DIXIEWIRE'))),
 												
 												
 							isNULL((select max(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date<=dateadd(mm, -1, #ALCpart.quote_date) and
 												ap_items.Item = #CopperBOM.part and
 												ap_items.Item not in ( select item from #apitemsmetalsurcharge) and
 												ap_items.price>0 and
 												ap_headers.pay_vendor in ('DIXIEWIRE')),isNULL((select min(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date>=dateadd(mm, -1, #ALCpart.quote_date) and
 												ap_items.Item = #CopperBOM.part and
 												ap_items.Item not in ( select item from #apitemsmetalsurcharge) and
 												ap_items.price>0 and
 												ap_headers.pay_vendor in ('DIXIEWIRE')),(select max(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date<=dateadd(mm, -1, #ALCpart.quote_date) and
 												ap_items.Item = #CopperBOM.part and
 												ap_items.Item not in ( select item from #apitemsmetalsurcharge) and
 												ap_items.price>0 and
 												ap_headers.pay_vendor not in ('DIXIEWIRE')) )),												
 														
 												
 						
 			
 												
 						isNULL((select max(inv_cm_date) from #apitemsmetalsurcharge
 									
 									where	#apitemsmetalsurcharge.inv_cm_date<= #ALCpart.quote_date and
 												#apitemsmetalsurcharge.Item = #CopperBOM.part and
 												#apitemsmetalsurcharge.unitcost >0 ),(select min(inv_cm_date) from #apitemsmetalsurcharge
 									
 									where	#apitemsmetalsurcharge.inv_cm_date>= #ALCpart.quote_date and
 												#apitemsmetalsurcharge.Item = #CopperBOM.part and
 												#apitemsmetalsurcharge.unitcost >0 )),
 												
 												
 							
 							(select min(inv_cm_date) from #apitemsmetalsurcharge
 									
 									where	#apitemsmetalsurcharge.inv_cm_date>=dateadd(mm, -6, #ALCpart.quote_date) and
 												#apitemsmetalsurcharge.Item = #CopperBOM.part and
 												#apitemsmetalsurcharge.unitcost>0 )
 												
 												
 										
 							
 				from		#ALCPart
 				Join		#CopperBOM on #ALCpart.basepart = #CopperBOM.finPart
 				
 	Select				#ALCCopperBOM.FinPart,
 							#ALCCopperBOM.CustomerPart,
 							#ALCCopperBOM.CopperPart,
  							#ALCCopperBOM.CopperBOMQty,
 							#ALCPart.current_price,
							#ALCPart.description,
							#ALCpart.SOP,
							#ALCpart.EOP,
							#ALCpart.quote_date,
 								
 								
 								#ALCCopperBOM.CopperBOMQty*isNULL((Select avg(isNULL(price,0))	
 								from		ap_items
 								join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 								where	ap_headers.inv_cm_date>= dateadd(dd,-30,#ALCCopperBOM.FirstCopperInvDate ) and 
 											ap_headers.inv_cm_date<=dateadd(dd,30,#ALCCopperBOM.FirstCopperInvDate ) and
 											#ALCCopperBOM.CopperPart= ap_items.Item and
 											ap_headers.inv_cm_flag = 'I'  and
 											ap_items.unit_of_measure = 'FT' and
 											ap_items.Item not in ( select item from #apitemsmetalsurcharge) and
 											ap_items.unit_of_measure is not null and
 											isNULL(ap_items.purchase_order,'0')>'0'),0) as 	initalWireCost,								
 											
 											
 								#ALCCopperBOM.CopperBOMQty*isNULL((Select avg(isNULL(price,0))	
 								from		ap_items
 								join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 								where	ap_headers.inv_cm_date>= dateadd(dd,-30,#ALCCopperBOM.lastCopperInvDate ) and 
 											ap_headers.inv_cm_date<=dateadd(dd,1,#ALCCopperBOM.lastCopperInvDate ) and
 											#ALCCopperBOM.CopperPart= ap_items.Item and
 											ap_headers.inv_cm_flag = 'I'  and
 											ap_items.unit_of_measure = 'FT' and
 											ap_items.Item not in ( select item from #apitemsmetalsurcharge) and
 											ap_items.unit_of_measure is not null and
 											isNULL(ap_items.purchase_order,'0')>'0'),0) 	as 		ActualWireCost,											
 																
 								
 								#ALCCopperBOM.CopperBOMQty*isNULL((Select price	from		terminals
 								where	subString(#ALCCopperBOM.CopperPart,1,7)= terminals.terminal ),0) as 	initalnonWireCost,							
 											
 											
 							#ALCCopperBOM.CopperBOMQty*isNULL((Select avg(isNULL(totalunitcost,0))	from		#apitemsmetalsurcharge
 								where	#apitemsmetalsurcharge.inv_cm_date>= dateadd(dd,-30,#ALCCopperBOM.lastnonWireInvDate ) and 
 											#apitemsmetalsurcharge.inv_cm_date<=dateadd(dd,30,#ALCCopperBOM.lastnonWireInvDate ) and
 											#ALCCopperBOM.CopperPart= #apitemsmetalsurcharge.Item ),0) as 	currentnonWireCost,
								 											 											
 							#ALCPart.EAU
 											
 	 from 				#ALCCopperBOM
 	 Join					#ALCPart on #ALCCopperBOM.finPart = #ALCPart.basepart
 	
 	 
 	 order by 		#ALCCopperBOM.FinPart
 	 						
 							


End
GO
