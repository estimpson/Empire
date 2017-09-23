SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwPODSoft]
(	PONumber,
	Part,
	DueDT,
	LineID )
as
--	Description:
--	Get open purchase order details beyond the frozen horizon or those where
--	the po balance is zero (release deleted but not yet printed).
select	PONumber = pod.po_number,
	Part = pod.part_number,
	DueDT = pod.date_due,
	LineID = pod.row_id
from	dbo.po_detail pod
	join FT.vwPPrA PPrA on pod.po_number = PPrA.DefaultPO
where	DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), pod.date_due ) - DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate ( ) ) >= PPrA.FrozenWeeks or
	PPrA.FrozenWeeks = 0 or
	pod.balance = 0
GO
