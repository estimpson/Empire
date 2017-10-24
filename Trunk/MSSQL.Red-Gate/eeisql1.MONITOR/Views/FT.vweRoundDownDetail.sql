SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweRoundDownDetail]
(	Part,
	WeekNo,
	PONumber,
	QtyRequired,
	OrderedQty,
	Shortage,
	StandardPack,
	ExcessPieces )
as
select	Part,
	WeekNo,
	PONumber,
	QtyRequired = PostDemandAccum - PriorPOAccum,
	OrderedQty = FrozenPOBalance + POBalance,
	Shortage = PostDemandAccum - PriorPOAccum - FrozenPOBalance - POBalance,
	StandardPack,
	ExcessPieces = StandardPack - PostDemandAccum + PriorPOAccum + FrozenPOBalance + POBalance
from	FT.WkNMPS WkNMPS
where	RoundingMethod <= 0 and
	PostDemandAccum > ( PriorPOAccum + FrozenPOBalance + POBalance )
GO
