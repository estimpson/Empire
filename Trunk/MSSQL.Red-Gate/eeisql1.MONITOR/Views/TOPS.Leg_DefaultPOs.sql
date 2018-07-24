SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [TOPS].[Leg_DefaultPOs]
as
select
	Part = part.part
,	Type = part.type
,	DefaultPONumber = part_online.default_po_number
,	VendorCode = po_header.vendor_code
,	BlanketPart = po_header.blanket_part
from
	MONITOR.dbo.part part
,	MONITOR.dbo.part_online part_online
,	MONITOR.dbo.po_header po_header
where
	part.part = part_online.part
	and part_online.default_po_number = po_header.po_number
	and
	(
		(part.type = 'F')
		and (po_header.vendor_code = 'EEH')
		and (isnull(part.description_short, 'XXX') <> 'ASB')
	)
GO
