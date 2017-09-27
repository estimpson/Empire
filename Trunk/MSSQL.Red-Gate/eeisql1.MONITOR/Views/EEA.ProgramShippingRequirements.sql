SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[ProgramShippingRequirements]
as
select
	ProgramCode
,	CustomerPart
,	BillTo
,	ShipTo
,	InHouseFG
,	InHouseRaw
,	InTransit
,	CurrentBuild
,	NextBuild
,	ShipSched
,	OrderNo
,	DueDT
,	PartCode
,	QtyDue
,	Firm
,	StandardPack
,	Totes
,	QtyFG
,	QtyRaw
,	QtyTrans
,	QtyCurrent
,	QtyNext
,	QtyShip
,	AccumRequired
from
	EEA.fn_ProgramShippingRequirements2() fpsr
GO
