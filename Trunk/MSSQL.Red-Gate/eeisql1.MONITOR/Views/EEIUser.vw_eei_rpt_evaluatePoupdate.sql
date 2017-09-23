SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [EEIUser].[vw_eei_rpt_evaluatePoupdate]
as

Select		po_header.po_number,
				po_header.blanket_part,
				po_detail.balance,
				po_detail.date_due po_detailduedate,
				po_header.date_due lastupdated,
				part_eecustom.prod_start,
				part_eecustom.prod_end	,			
				(Case WHEN datediff (month, getdate(),isNULL(part_eecustom.prod_end,'2000-05-1') )<=6   THEN 1 ELSE 0 END) as evalupdate,
				datediff (month, getdate(),isNULL(part_eecustom.prod_end,'2000-05-1')) timesincelastupdate

from		po_header
				
Left Outer JOIN			po_detail on po_header.po_number = po_detail.po_number
JOIN								part_online on po_header.blanket_part = part_online.part and po_header.po_number = part_online.default_po_number
JOIN								part_eecustom on po_header.blanket_part = part_eecustom.part
Where							ABS(datediff (week, isNULL(po_header.date_due,'2007-05-1'), getdate()))>0  and balance > 0
GO
