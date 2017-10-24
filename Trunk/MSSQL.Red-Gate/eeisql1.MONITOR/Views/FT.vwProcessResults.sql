SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwProcessResults]
as
select	*,
	eStandardPack =
	(	case	when FrozenBalance % StandardPack != 0 then 1
			else 0
		end ),
	eLeadDemand =
	(	case	when FrozenBalance > LeadDemand then 1
			else 0
		end ),
	eTotalDemand =
	(	case	when FrozenBalance > TotalDemand then 1
			else 0
		end ),
	eMinOnHand =
	(	case	when TotalDemand = MinOnHand and MinOnHand > 0 then 1
			else 0
		end ),
	eRoundDown = IsNull (
	(	select	min (1)
		from	FT.WkNMPS WkNMPSRD
		where	WkNMPSRD.Part = WkNMPS.Part and
			WkNMPSRD.RoundingMethod <= 0 and
			WkNMPSRD.PostDemandAccum > ( WkNMPSRD.PriorPOAccum + WkNMPSRD.FrozenPOBalance ) ), 0 )
from	(	select	WkNMPS.Part,
			PONumber = Max ( WkNMPS.PONumber ),
			FrozenBalance = convert ( integer, Max ( WkNMPS.FrozenPOBalance ) ),
			FrozenHorizon = Max ( WkNMPS.FrozenWeeks ),
			RoundingMethod = Max ( WkNMPS.RoundingMethod ),
			StandardPack = convert ( integer, Max ( WkNMPS.StandardPack ) ),
			LeadDemand =
			(	select	Max ( WkNMPSLead.PostDemandAccum )
				from	FT.WkNMPS WkNMPSLead
				where	WkNMPSLead.WeekNo <= Ceiling ( Max ( vwPPrA.VendorLeadTime / 7 ) ) and
					WkNMPS.Part = WkNMPSLead.Part ),
			Lead = Ceiling ( Max ( vwPPrA.VendorLeadTime / 7 ) ),
			TotalDemand = Max ( WkNMPS.PostDemandAccum ),
			MinOnHand = Max ( vwPOH.MinOnHand )
		from	FT.WkNMPS WkNMPS
			join FT.vwPPrA vwPPrA on WkNMPS.PONumber = vwPPrA.DefaultPO and
				WkNMPS.Part = vwPPrA.Part
			join FT.vwPOH vwPOH on WkNMPS.Part = vwPOH.Part
		group by
			WkNMPS.Part ) WkNMPS
GO
