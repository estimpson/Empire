SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [FT].[vwCommonSerial_POD]
as
select	PONumber = po_number,
	Part = part_number,
	DueDT = date_due,
	RowID = row_id,
	Received = received,
	Balance = balance,
	PostAccum =
	(	select	sum (balance)
		from	po_detail pod2
		where	po_number = po_detail.po_number and
			part_number = po_detail.part_number and
			(	date_due < po_detail.date_due or
				(	date_due = po_detail.date_due and
					row_id <= po_detail.row_id)))
from	po_detail
where	po_number in
	(	select	PONumber = po_header.po_number
		from	FT.CommonSerialShipLog ShipLog
			left outer join part_online on ShipLog.Part = part_online.part
			left outer join po_header on part_online.default_po_number = po_header.po_number
		where	ShipLog.Part != 'PALLET' and
			ShipLog.RowStatus = 103) and
	status = 'A'
GO
