SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[ftsp_AuditNALRANS]
as 

Begin

Select	NAL862Releases.ShipToCode as RAWEDIShipToCode,
		NAL862Releases.CustomerPart as RAWEDICustomerPart,
		ReleaseDT as RAWEDIReleaseDT,
		ReleaseQty as RAWEDIReleaseQty,
		ReleaseNo as RawEDIRAN,
		Release_no  as SalesOrderRAN,
		Coalesce(Quantity,0) as SalesOrderQuantity,
		due_date as SalesOrderDueDate,
		Order_no as SalesOrderNumber,
		BlanketOrderNo as ActiveOrderNo,
		Part_number as SalesOrderPartNumber,
		destination as SalesOrderDestination,
		RANShippedRAN,
		Coalesce(RANQtyShipped,0) as RANShippedQTY
Into #RanAudit
		 From
(SELECT	distinct 
		RawDocumentGUID,
		shipToCode CurrentShipToCode, 
		CustomerPart  CurrentCustomerPart
FROM 
	[NALEDI].[Current862s] ()) CurrentNAL862s
join
	EDI.NAL_862_Releases NAL862Releases on NAL862Releases.RawDocumentGUID = CurrentNAL862s.RawDocumentGUID and ShipToCode = CurrentShipToCode and CustomerPart = CurrentCustomerPart
left join
	order_detail od on od.release_no =  NAL862Releases.ReleaseNo and od.customer_part = CustomerPart
left join ( Select RanNumber RANShippedRAN, Sum(Qty) RANQtyShipped From NALRanNumbersShipped group by RANNumber) RANSShipped on RANShippedRAN = ReleaseNo
left Join NALEDI.BlanketOrders NALBo on order_no = BlanketOrderNo

Select* From #RanAudit
Where (RAWEDIReleaseQty-RANShippedQty) != SalesOrderQuantity
order by RAWEDIShipToCode, RAWEDICustomerPart, RAWEDIReleaseDT


End


GO
