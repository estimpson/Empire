SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweRoundDownFP]
(	Part,
	FinishedPart,
	QtyOnOrder )
as
select	Part = WkNMPS.Part,
	FinishedPart = XRt.TopPart,
	QtyOnOrder =
	(	select	sum ( vwSOD.StdQty )
		from	FT.vwSOD vwSOD
		where	XRt.TopPart = vwSOD.Part )
from	FT.WkNMPS WkNMPS
	join FT.XRt XRt on WkNMPS.Part = XRt.ChildPart
where	RoundingMethod <= 0 and
	PostDemandAccum > ( PriorPOAccum + FrozenPOBalance + POBalance )
group by
	WkNMPS.Part,
	XRt.TopPart
having	(	select	sum ( vwSOD.StdQty )
		from	FT.vwSOD vwSOD
		where	XRt.TopPart = vwSOD.Part ) > 0
GO
