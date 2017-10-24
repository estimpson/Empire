SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[ProgramShippingRequirements_NewIntransit]
as
select
	fpsr.ProgramCode
,	fpsr.CustomerPart
,	fpsr.BillTo
,	fpsr.ShipTo
,	fpsr.InHouseFG
,	fpsr.InHouseRaw
,	fpsr.InTransit1
,	fpsr.InTransit2
,	fpsr.CurrentBuild
,	fpsr.NextBuild
,	fpsr.ShipSched
,	fpsr.OrderNo
,	fpsr.DueDT
,	fpsr.PartCode
,	fpsr.QtyDue
,	fpsr.Firm
,	fpsr.StandardPack
,	fpsr.Totes
,	fpsr.QtyFG
,	fpsr.QtyRaw
,	fpsr.QtyTrans1
,	fpsr.QtyTrans2
,	fpsr.QtyCurrent
,	fpsr.QtyNext
,	fpsr.QtyShip
,	fpsr.AccumRequired
from
	EEA.fn_ProgramShippingRequirements_NewIntransit() fpsr
GO
