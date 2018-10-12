SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_dixieaccums] as
select	(StdQty + AccumAdjust) as AdjustedAccum,*
from		EEH.[FT].[POReceiptTotals] with (READUNCOMMITTED)
join		EEH.[dbo].po_header on EEH.[FT].[POReceiptTotals].POnumber = EEH.[dbo].po_header.po_number and 
		EEH.[FT].[POReceiptTotals].Part = EEH.[dbo].po_header.blanket_part and EEH.[dbo].po_header.vendor_code like '%DIXIE%' 
GO
