SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FT].[PODetailAccum]
as
select	PODetailCurrent.PONumber,
	PODetailCurrent.BasePart,
	PODetailCurrent.Part,
	PODetailCurrent.DueDT,
	PODetailCurrent.Balance,
	PostAccum = Sum (PODetailPrior.Balance)
from	(	select	PONumber = po_number,
			BasePart = left (part_number, 7),
			Part = part_number,
			Balance = balance,
			DueDT = date_due
		from	po_detail
		where	vendor_code = 'EEH' ) PODetailCurrent
	join
	(	select	PONumber = po_number,
			BasePart = left (part_number, 7),
			Part = part_number,
			Balance = balance,
			DueDT = date_due
		from	po_detail
		where	vendor_code = 'EEH' ) PODetailPrior on PODetailCurrent.BasePart = PODetailPrior.BasePart and
		(	(	PODetailCurrent.DueDT = PODetailPrior.DueDT and
				PODetailCurrent.Part >= PODetailPrior.Part) or
			(	PODetailCurrent.DueDT > PODetailPrior.DueDT))
group by
	PODetailCurrent.PONumber,
	PODetailCurrent.BasePart,
	PODetailCurrent.Part,
	PODetailCurrent.Balance,
	PODetailCurrent.DueDT
GO
