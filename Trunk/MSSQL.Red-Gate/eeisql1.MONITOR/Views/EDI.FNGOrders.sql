SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [EDI].[FNGOrders]
		as
		
		select	InternalDocumentID = max(FnGH.RowID),
					TradingPartner,
					ReleaseNo,
					CustomerPart,
					CustomerPO,
					ShipToCode
		from		edi.FnG_830_Headers FnGH
		join		edi.FnG_830_Releases FnGR on FnGH.RawDocumentGUID = FnGR.RawDocumentGUID
		where	exists ( select 1 from order_header oh join order_detail on oh.order_no = order_detail.order_no join edi_setups es on oh.destination = es.destination where oh.customer_part = CustomerPart and customer_po = CustomerPO and ShipToCode = parent_destination and release_no = ReleaseNo)
		group by
					TradingPartner,
					ReleaseNo,
					CustomerPart,
					CustomerPO,
					ShipToCode
GO
