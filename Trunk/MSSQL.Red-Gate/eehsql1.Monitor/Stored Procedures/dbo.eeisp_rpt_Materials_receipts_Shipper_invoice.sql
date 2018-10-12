SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	procedure [dbo].[eeisp_rpt_Materials_receipts_Shipper_invoice] (@Date datetime)
as
begin

--eeisp_rpt_Materials_receipts_Shipper_invoice '2008-12-15'




Select	purchase_order, 
		substring(bill_of_lading, 1, isNULL(nullif(patindex('%[_]%', bill_of_lading),0),datalength(bill_of_lading))-1) as PRI_Shipper, 
		Invoice, 
		item,
		total_cost
into		#POReceivers
 
from		po_receiver_items 
where	Changed_date >=  dateadd(wk,0, ft.fn_TruncDate('wk',@Date)) and
		purchase_order not like '%[A-Z]%'

Select	sum(std_quantity) Shipperqty,
		audit_trail.part ATPart,
		convert(int,audit_trail.po_number) ATShipperPO,
		shipper ATShipper,
		from_loc
into		#DetailReceipts
from		audit_trail 
where	audit_trail.type  = 'R'  and		
		date_stamp >=dateadd(wk,0, ft.fn_TruncDate('wk',@Date)) and
		date_stamp <	dateadd(wk,1, ft.fn_TruncDate('wk',@Date))
group by	audit_trail.part,
		convert(int,audit_trail.po_number),
		shipper,
		from_loc



Select	*
from		#DetailReceipts
left join	#POReceivers on #DetailReceipts.ATShipperPO = #POReceivers.Purchase_order and ATPart  = Item and ATShipper=PRI_Shipper
order by purchase_order,
		Invoice



End
GO
