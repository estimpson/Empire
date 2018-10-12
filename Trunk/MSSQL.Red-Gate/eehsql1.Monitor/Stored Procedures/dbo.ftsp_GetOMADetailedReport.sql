SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[ftsp_GetOMADetailedReport]
(	@OMAId int)
as
select	RawPart,
	RawDescription,
	RawXRef,
	GrossDemand,
	BOMOnhand,
	FabAuthCommitment,
	RawAuthCommitment,
	NegotiatedCommitment,
	NetDemand,
	StandardPack,
	NetRemaining =
	(	case when NetDemand < 0 then -NetDemand else
			(	case when NetDemand % StandardPack = 0 then 0
					else StandardPack - NetDemand % StandardPack
				end )
		end ),
	Cost,
	LeadTime,
	RunDT,
	DefaultVendor,
	Comment
from	(	select	RawPart = XRt.ChildPart,
			RawDescription = min (raw.name),
			RawXRef = min (raw.cross_ref),
			GrossDemand = sum (EndingQty * XQty) + IsNull (min (OrderDemand), 0),
			BOMOnhand = isnull (min (BOMOnhand), 0) + isnull (min (OMAEarlyReceipts.StdQty), 0) - isnull (min (OMA_RMA.StdQty), 0),
			FabAuthCommitment = isnull (min (FabAuthorization.AuthorizedAccum - CurrentAccum.CurrentAccum), 0),
			RawAuthCommitment = isnull (min (RawAuthorization.AuthorizedAccum - CurrentAccum.CurrentAccum), 0),
			NegotiatedCommitment = min (NegotiatedFab.NegotiatedAccum - CurrentAccum.CurrentAccum),
			NetDemand = convert (integer, sum (EndingQty * XQty) + isnull (min (OrderDemand), 0) - (isnull (min (BOMOnhand), 0) + isnull (min (OMAEarlyReceipts.StdQty), 0) - isnull (min (OMA_RMA.StdQty), 0)) - isnull (min (isnull (NegotiatedFab.NegotiatedAccum, FabAuthorization.AuthorizedAccum) - CurrentAccum.CurrentAccum), 0)),
			StandardPack = convert (integer, min (part_inventory.standard_pack)),
			Cost = min (part_standard.cost_cum),
			LeadTime = part_vendor.lead_time,
			RunDT = GetDate (),
			DefaultVendor = min(part_online.default_vendor),
			Comment = min (OMARawPartComments.Comment)
		from	FT.OMAEndingOrders OMAEndingOrders
			join FT.XRt XRT on OMAEndingOrders.PartCode = XRt.TopPart
			join FT.OMARawParts OMARawParts on XRt.ChildPart = OMARawParts.PartCode and
				OMARawParts.OMAId = @OMAId
			join dbo.part raw on XRt.ChildPart = raw.part and
				raw.type = 'R'
			join dbo.part_inventory part_inventory on XRt.ChildPart = part_inventory.part
			join dbo.part_standard part_standard on XRt.ChildPart = part_standard.part
			join dbo.part_online part_online on XRt.ChildPart = part_online.part
			left outer join dbo.part_vendor part_vendor on part_online.default_vendor = part_vendor.vendor and
				XRt.ChildPart = part_vendor.part
			left outer join
			(	select	XRt1.ChildPart,
					BOMOnhand = sum (object.std_quantity * XRt1.XQty)
				from	dbo.object object
					left outer join FT.OMASecureLocationExclusions OMASecureLocationExclusions on OMASecureLocationExclusions.OMAId = @OMAId and
						object.part = OMASecureLocationExclusions.PartCode and
						object.location = OMASecureLocationExclusions.LocationCode
					join dbo.location location on object.location = location.code and
						(	isnull (location.secured_location, 'N') = 'N' or
							OMASecureLocationExclusions.LocationCode = location.code)
					join FT.XRt XRt1 on object.part = XRt1.TopPart
				group by
					XRt1.ChildPart ) BOMOnhand on XRt.ChildPart = BOMOnhand.ChildPart
			left outer join FT.OMA_RMA OMA_RMA on OMA_RMA.OMAId = @OMAId and
				XRt.ChildPart = OMA_RMA.PartCode
			left outer join FT.OMAEarlyReceipts OMAEarlyReceipts on OMAEarlyReceipts.OMAId = @OMAId and
				XRt.ChildPart = OMAEarlyReceipts.PartCode
			left outer join
			(	select	HighFabAuthorizations.Part,
					AuthorizedAccum = min (AuthorizedAccum)
				from	FT.HighFabAuthorizations HighFabAuthorizations
					join dbo.part_online part_online on HighFabAuthorizations.PONumber = part_online.default_po_number and
						part_online.part = HighFabAuthorizations.Part
				group by
					HighFabAuthorizations.Part) FabAuthorization on FabAuthorization.Part = XRt.ChildPart
			left outer join
			(	select	HighRawAuthorizations.Part,
					AuthorizedAccum = min (AuthorizedAccum)
				from	FT.HighRawAuthorizations HighRawAuthorizations
					join dbo.part_online part_online on HighRawAuthorizations.PONumber = part_online.default_po_number and
						part_online.part = HighRawAuthorizations.Part
				group by
					HighRawAuthorizations.Part) RawAuthorization on RawAuthorization.Part = XRt.ChildPart
			left outer join
			(	select	XRt1.ChildPart,
					OrderDemand = sum (order_detail.std_qty * XRt1.XQty)
				from	dbo.order_detail order_detail
					join FT.XRt XRt1 on order_detail.part_number = XRt1.TopPart
				where	order_detail.part_number not in
					(	select	PartCode
						from	FT.OMAEndingOrders
						where	OMAId = @OMAId)
				group by
					XRt1.ChildPart) OrderDemand on XRt.ChildPart = OrderDemand.ChildPart
			left outer join FT.OMARawPartComments OMARawPartComments on OMARawPartComments.OMAId = @OMAId and
				XRt.ChildPart = OMARawPartComments.PartCode
			left outer join
			(	select	POReceiptTotals.Part,
					CurrentAccum = min (StdQty)
				from	FT.POReceiptTotals POReceiptTotals
					join dbo.part_online part_online on POReceiptTotals.PONumber = part_online.default_po_number and
						part_online.part = POReceiptTotals.Part
				group by
					POReceiptTotals.Part ) CurrentAccum on XRt.ChildPart = CurrentAccum.Part
			left outer join
			(	select	PartCode,
					NegotiatedAccum = min (NegotiatedAccum)
				from	FT.OMANegotiatedFabAuthorizations
				where	OMAId = @OMAId
				group by
					PartCode ) NegotiatedFab on XRt.ChildPart = NegotiatedFab.PartCode
		where	OMAEndingOrders.OMAId = @OMAId
		group by
			XRt.ChildPart,
			part_online.default_po_number,
			part_vendor.lead_time) NetDemand
order by
	1
GO
