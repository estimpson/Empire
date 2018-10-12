SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure	[dbo].[eeisp_rpt_copper_pricepershipment] (@startdate datetime, @enddate datetime, @lookbackmonthspan integer, @intialshipmentlookback integer)
 
 as
Begin
 	
 	
 	create table #finshipped (
 					shipperid				integer,
 					destination				varchar(20),
 					price					numeric(20,6),
 					dateshipped 		datetime,
 					finpart					varchar(25),
 					customerPart		varchar(50),
 					finQty					numeric (20,6),
 					firstshipdate		datetime,
 					dollarshipped		numeric(20,6))
 					
 					
 					Insert 		#finshipped
 					Select		
 									shipper_detail_eei.shipper,
 									destination_eei.destination,
 									shipper_detail_eei.alternate_price,
 									shipper_eei.date_shipped,
 									part_original,
 									customer_part,
 									Qty_Packed,
 									(select min(date_shipped) from shipper_detail_eei sdeei
 										where	substring(sdeei.part_original,1,7)=substring(shipper_detail_eei.part_original,1,7) and
 										sdeei.part_original not like '%PT'),
 										shipper_detail_eei.alternate_price*Qty_Packed
 					from			shipper_detail_eei
 					join			shipper_eei on shipper_detail_eei.shipper = shipper_eei.id
 					join			destination_eei on shipper_eei.destination = destination_eei.destination
 				where			shipper_eei.type is NULL and shipper_eei.date_shipped >= @startdate and shipper_eei.date_shipped < dateadd(dd,-1, @enddate) and
 									shipper_detail_eei.part_original not like '%PT' and alternate_price > 0 and shipper_eei.type is NULL
 					
 					
 	create table #copperwire(
 						FinPart				varchar(25),
 						part					varchar(25),
 						BOMQty			numeric(20,6),
 						maxrawpart		varchar(25))
 					
 					
 					Insert 		#copperwire
 					Select		FinishedPart,
 									RawPart,
 									Quantity,
 									(select max(RawPart) from vweeiBOM as BOMtwo
 									where	vweeiBOM.FinishedPart = BOMtwo.Finishedpart and BOMtwo.RawPart in (Select part from part_vendor where vendor in ('DIXIEWIRE', 'DIXIEHON','COPPERFLD', 'ESSEX', 'ANIXTER')))
 					from			vweeiBOM
 					where		RawPart in (Select part from part_vendor where vendor in ('DIXIEWIRE', 'DIXIEHON','COPPERFLD', 'ESSEX', 'ANIXTER'))
 					
 					
 	create table		#coppershipped ( 					
 					shipperID				integer,
 					FirstShippedDate		datetime,
 					DateShipped			datetime,
 					FinPart						varchar(25),
 					CustomerPart			varchar(50),
 					WirePart					varchar(25),
 					FinQty						numeric(20,6),
 					ShippedQty				numeric(20,6),
 					WireBOMQty			numeric(20,6),
 					WireQty					numeric(20,6),
 					PriorInvoiceDate		datetime,
 					FirstInvoiceDate		datetime,
 					FirstInvoiceDateaft	datetime,
 					LastInvDatepriorYear	datetime,
 					destination				varchar(20),
 					Price						numeric(20,6),
 					FinDollarShipped	numeric(20,6))
 					
 					
 				Insert	#coppershipped
 				Select	#finshipped.shipperid,
 							#finshipped.firstshipdate,
 							#finshipped.dateshipped,
 							#finshipped.FinPart,
 							#finshipped.customerPart,
 							#copperWire.part,
 						(CASE WHEN (#copperwire.Part = #copperwire.maxrawpart) THEN #finshipped.finQty ELSE 0 END),
 							 #finshipped.finQty,
 							#copperWire.BOMQty,
 							#finshipped.FinQty*#copperWire.BOMQty,
 							isNULL((select max(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date<=#finshipped.dateshipped and
 												ap_items.Item = #copperWire.part and
 												ap_items.price>0 and
 												ap_headers.pay_vendor in ('DIXIEWIRE')),(select max(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date<=#finshipped.dateshipped and
 												ap_items.Item = #copperWire.part and
 												ap_items.price>0 and
 												ap_headers.pay_vendor  in ('DIXIEWIRE'))),
 							isNULL((select max(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date<=dateadd(mm, -6, #finshipped.firstshipdate) and
 												ap_items.Item = #copperWire.part and
 												ap_items.price>0 and
 												ap_headers.pay_vendor in ('DIXIEWIRE')),(select max(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date<=dateadd(mm, -6, #finshipped.firstshipdate) and
 												ap_items.Item = #copperWire.part and
 												ap_items.price>0 and
 												ap_headers.pay_vendor not in ('DIXIEWIRE'))),
 							IsNULL((select min(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date>=dateadd(mm, -6, #finshipped.firstshipdate) and
 												ap_items.Item = #copperWire.part and
 												ap_items.price>0 and
 												ap_headers.pay_vendor in ('DIXIEWIRE')),(select min(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date>=dateadd(mm, -6, #finshipped.firstshipdate) and
 												ap_items.Item = #copperWire.part and
 												ap_items.price>0 and
 												ap_headers.pay_vendor not in ('DIXIEWIRE'))),
 							IsNULL((select max(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date<='2006-01-01' and
 												ap_items.Item = #copperWire.part and
 												ap_items.price>0 and
 												ap_headers.pay_vendor in ('DIXIEWIRE')),(select max(inv_cm_date) from ap_items
 									join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 									where	ap_headers.inv_cm_date<='2006-01-01' and
 												ap_items.Item = #copperWire.part and
 												ap_items.price>0 and
 												ap_headers.pay_vendor not in ('DIXIEWIRE'))),
 							#finshipped.destination,
 							#finshipped.price,
							#finshipped.dollarshipped
 							
 				from		#finshipped
 				Join		#copperWire on #finshipped.finPart = #copperwire.finPart
 				
 	Select				#coppershipped.firstshippeddate,
 							#coppershipped.dateshipped,
 							#coppershipped.FinPart,
 							#coppershipped.CustomerPart,
 							#coppershipped.WirePart,
 							#coppershipped.FinQty,
 							#coppershipped.WireQty,
 							isNULL((Select avg(isNULL(price,0))	from		ap_items
 								join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 								where	ap_headers.inv_cm_date>= dateadd(mm,(@lookbackmonthspan*-1),#coppershipped.PriorInvoiceDate) and 
 											ap_headers.inv_cm_date<=#coppershipped.PriorInvoiceDate and
 											#coppershipped.WirePart = ap_items.Item and
 											ap_headers.inv_cm_flag = 'I' and
 											ap_items.unit_of_measure is not null and
 											isNULL(ap_items.purchase_order,'0')>'0'),0) as avgcost, 											
 							isNULL((Select avg(isNULL(price,0))	from		ap_items
 								join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 								where	ap_headers.inv_cm_date>= dateadd(dd,(@intialshipmentlookback*-1),isNULL(#coppershipped.firstinvoicedate,#coppershipped.firstinvoicedateaft) ) and 
 											ap_headers.inv_cm_date<=dateadd(dd,(@intialshipmentlookback),isNULL(#coppershipped.firstinvoicedate, #coppershipped.firstinvoicedateaft) ) and
 											#coppershipped.WirePart = ap_items.Item and
 											ap_headers.inv_cm_flag = 'I'  and
 											ap_items.unit_of_measure is not null and
 											isNULL(ap_items.purchase_order,'0')>'0'),0) as Intialcost, 							
 								customer_eei.custom2,
 								destination_eei.customer,
 								#coppershipped.price,
 								Substring(#coppershipped.FinPart,1,7) as basepart,
 								#coppershipped.shipperid,
 								isNULL((Select avg(isNULL(price,0))	from		ap_items
 								join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 								where	ap_headers.inv_cm_date>= dateadd(dd,(@intialshipmentlookback*-1),LastInvDatepriorYear ) and 
 											ap_headers.inv_cm_date<=dateadd(dd,(@intialshipmentlookback),LastInvDatepriorYear ) and
 											#coppershipped.WirePart = ap_items.Item and
 											ap_headers.inv_cm_flag = 'I' and
 											ap_items.unit_of_measure is not null and
 											isNULL(ap_items.purchase_order,'0')>'0'),0) as LastCostPrior,
 								#coppershipped.LastInvDatepriorYear,
 								#coppershipped.WireBOMQty,
 								(#coppershipped.WireBOMQty*#coppershipped.ShippedQty*isNULL((Select avg(isNULL(price,0))	from		ap_items
 								join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 								where	ap_headers.inv_cm_date>= dateadd(dd,(@intialshipmentlookback*-1),isNULL(#coppershipped.firstinvoicedate,#coppershipped.firstinvoicedateaft) ) and 
 											ap_headers.inv_cm_date<=dateadd(dd,(@intialshipmentlookback),isNULL(#coppershipped.firstinvoicedate, #coppershipped.firstinvoicedateaft) ) and
 											#coppershipped.WirePart = ap_items.Item and
 											ap_headers.inv_cm_flag = 'I'  and
 											ap_items.unit_of_measure is not null and
 											isNULL(ap_items.purchase_order,'0')>'0'),0)) as 	initalWireCost,
 								(#coppershipped.WireBOMQty*#coppershipped.ShippedQty*isNULL((Select avg(isNULL(price,0))	from		ap_items
 								join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 								where	ap_headers.inv_cm_date>= dateadd(mm,(@lookbackmonthspan*-1),#coppershipped.PriorInvoiceDate) and 
 											ap_headers.inv_cm_date<=#coppershipped.PriorInvoiceDate and
 											#coppershipped.WirePart = ap_items.Item and
 											ap_headers.inv_cm_flag = 'I' and
 											ap_items.unit_of_measure is not null and
 											isNULL(ap_items.purchase_order,'0')>'0'),0)) 	as 		ActualWireCost,
 											
 								#coppershipped.FinDollarShipped,
 								
 								(#coppershipped.WireBOMQty*#coppershipped.ShippedQty*isNULL((Select avg(isNULL(price,0))	from		ap_items
 								join		ap_headers on ap_items.invoice_cm = ap_headers.invoice_cm and ap_items.vendor = ap_headers.vendor and ap_items.inv_cm_flag = ap_headers.inv_cm_flag
 								where	ap_headers.inv_cm_date>= dateadd(dd,(@intialshipmentlookback*-1),LastInvDatepriorYear ) and 
 											ap_headers.inv_cm_date<=dateadd(dd,(@intialshipmentlookback),LastInvDatepriorYear ) and
 											#coppershipped.WirePart = ap_items.Item and
 											ap_headers.inv_cm_flag = 'I' and
 											ap_items.unit_of_measure is not null and
 											isNULL(ap_items.purchase_order,'0')>'0'),0)) as WireCostatyearstart
 								
 								
 											
 											
 	 from 				#coppershipped
 	 Join					destination_eei on #coppershipped.destination = destination_eei.destination
 	 Join					customer_eei on destination_eei.customer = customer_eei.customer
 	 
 	 order by 		#coppershipped.FinPart,
 	 						#coppershipped.dateshipped
 							


End
GO
