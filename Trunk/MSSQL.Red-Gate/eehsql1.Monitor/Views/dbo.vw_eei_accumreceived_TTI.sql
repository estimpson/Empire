SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_accumreceived_TTI] 
as
Select	Part, 
		PONumber,
		AccumReceived,
		AccumAdjustments,
		LastTimeReceived
from		[EEH].[dbo].vw_eei_accum_received with (READUNCOMMITTED)
where	poNumber in ( Select edi_po.Po_Number from edi_po, po_header where edi_po.po_number = po_header.po_number and vendor_code = 'TTI') 
		
GO
