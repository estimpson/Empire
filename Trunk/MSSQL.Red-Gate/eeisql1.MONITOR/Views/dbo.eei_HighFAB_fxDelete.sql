SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[eei_HighFAB_fxDelete]
AS
SELECT		FT.HighFabAuthorizations.PONumber, 
					FT.HighFabAuthorizations.Part, 
					FT.HighFabAuthorizations.AuthorizedAccum, 
					dbo.part_standard.cost_cum,
					isNULL((Select sum(qty)
				from eei_weekly_receipts eeiwr
			where	 FT.HighFabAuthorizations.ponumber = eeiwr.ponumber and
						 FT.HighFabAuthorizations.part = eeiwr.part),0) as AccumReceived,
					isNULL((Select sum(cum_adjust)
				from edi_po_year 
			where	 FT.HighFabAuthorizations.ponumber = edi_po_year.po_number and
						 FT.HighFabAuthorizations.part = edi_po_year.part),0) as AccumAdjust,
				(Select lead_time
						from		part_vendor,
									po_header
				where			po_header.vendor_code = part_vendor.vendor and
									po_header.blanket_part = part_vendor.part and
									po_header.po_number =  FT.HighFabAuthorizations.ponumber) as LeadTime,
				(Select min(date_due) from po_detail
					where	po_number =  FT.HighFabAuthorizations.ponumber) as nextDueDate
				
					
FROM         FT.HighFabAuthorizations 
					INNER JOIN        dbo.part_standard ON FT.HighFabAuthorizations.Part = dbo.part_standard.part
					INNER JOIN        dbo.po_header ON FT.HighFabAuthorizations.Part = dbo.po_header.blanket_part and  FT.HighFabAuthorizations.PONumber = po_header.po_number
WHERE			po_header.type = 'B'
GO
