SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- 
CREATE view [EEIUser].[acctg_csm_selling_prices_tabular_detail]
as
select
	ReleaseID
,	BasePart
,	[Version]
,	EffectiveMonth = month(dateadd(month, row_number() over (partition by ReleaseId, Version, BasePart order by BasePart) - 1, '2008-1-1'))
,	EffectiveYear = year(dateadd(month, row_number() over (partition by ReleaseId, Version, BasePart order by BasePart) - 1, '2008-1-1'))
,	EffectiveDT = dateadd(month, row_number() over (partition by ReleaseId, Version, BasePart order by BasePart) - 1, '2008-1-1')
,	SellingPrice
from
(
	select
		spt.RELEASE_ID as ReleaseId
	,	spt.BASE_PART as BasePart
	,	spt.[VERSION] as [Version]
	,	JAN_08 = coalesce(spt.JAN_08, 0)
	,	FEB_08 = coalesce(spt.FEB_08, 0)
	,	MAR_08 = coalesce(spt.MAR_08, 0)
	,	APR_08 = coalesce(spt.APR_08, 0)
	,	MAY_08 = coalesce(spt.MAY_08, 0)
	,	JUN_08 = coalesce(spt.JUN_08, 0)
	,	JUL_08 = coalesce(spt.JUL_08, 0)
	,	AUG_08 = coalesce(spt.AUG_08, 0)
	,	SEP_08 = coalesce(spt.SEP_08, 0)
	,	OCT_08 = coalesce(spt.OCT_08, 0)
	,	NOV_08 = coalesce(spt.NOV_08, 0)
	,	DEC_08 = coalesce(spt.DEC_08, 0)
	,	JAN_09 = coalesce(spt.JAN_09, 0)
	,	FEB_09 = coalesce(spt.FEB_09, 0)
	,	MAR_09 = coalesce(spt.MAR_09, 0)
	,	APR_09 = coalesce(spt.APR_09, 0)
	,	MAY_09 = coalesce(spt.MAY_09, 0)
	,	JUN_09 = coalesce(spt.JUN_09, 0)
	,	JUL_09 = coalesce(spt.JUL_09, 0)
	,	AUG_09 = coalesce(spt.AUG_09, 0)
	,	SEP_09 = coalesce(spt.SEP_09, 0)
	,	OCT_09 = coalesce(spt.OCT_09, 0)
	,	NOV_09 = coalesce(spt.NOV_09, 0)
	,	DEC_09 = coalesce(spt.DEC_09, 0)
	,	JAN_10 = coalesce(spt.JAN_10, 0)
	,	FEB_10 = coalesce(spt.FEB_10, 0)
	,	MAR_10 = coalesce(spt.MAR_10, 0)
	,	APR_10 = coalesce(spt.APR_10, 0)
	,	MAY_10 = coalesce(spt.MAY_10, 0)
	,	JUN_10 = coalesce(spt.JUN_10, 0)
	,	JUL_10 = coalesce(spt.JUL_10, 0)
	,	AUG_10 = coalesce(spt.AUG_10, 0)
	,	SEP_10 = coalesce(spt.SEP_10, 0)
	,	OCT_10 = coalesce(spt.OCT_10, 0)
	,	NOV_10 = coalesce(spt.NOV_10, 0)
	,	DEC_10 = coalesce(spt.DEC_10, 0)
	,	JAN_11 = coalesce(spt.JAN_11, 0)
	,	FEB_11 = coalesce(spt.FEB_11, 0)
	,	MAR_11 = coalesce(spt.MAR_11, 0)
	,	APR_11 = coalesce(spt.APR_11, 0)
	,	MAY_11 = coalesce(spt.MAY_11, 0)
	,	JUN_11 = coalesce(spt.JUN_11, 0)
	,	JUL_11 = coalesce(spt.JUL_11, 0)
	,	AUG_11 = coalesce(spt.AUG_11, 0)
	,	SEP_11 = coalesce(spt.SEP_11, 0)
	,	OCT_11 = coalesce(spt.OCT_11, 0)
	,	NOV_11 = coalesce(spt.NOV_11, 0)
	,	DEC_11 = coalesce(spt.DEC_11, 0)
	,	JAN_12 = coalesce(spt.JAN_12, 0)
	,	FEB_12 = coalesce(spt.FEB_12, 0)
	,	MAR_12 = coalesce(spt.MAR_12, 0)
	,	APR_12 = coalesce(spt.APR_12, 0)
	,	MAY_12 = coalesce(spt.MAY_12, 0)
	,	JUN_12 = coalesce(spt.JUN_12, 0)
	,	JUL_12 = coalesce(spt.JUL_12, 0)
	,	AUG_12 = coalesce(spt.AUG_12, 0)
	,	SEP_12 = coalesce(spt.SEP_12, 0)
	,	OCT_12 = coalesce(spt.OCT_12, 0)
	,	NOV_12 = coalesce(spt.NOV_12, 0)
	,	DEC_12 = coalesce(spt.DEC_12, 0)
	,	JAN_13 = coalesce(spt.JAN_13, 0)
	,	FEB_13 = coalesce(spt.FEB_13, 0)
	,	MAR_13 = coalesce(spt.MAR_13, 0)
	,	APR_13 = coalesce(spt.APR_13, 0)
	,	MAY_13 = coalesce(spt.MAY_13, 0)
	,	JUN_13 = coalesce(spt.JUN_13, 0)
	,	JUL_13 = coalesce(spt.JUL_13, 0)
	,	AUG_13 = coalesce(spt.AUG_13, 0)
	,	SEP_13 = coalesce(spt.SEP_13, 0)
	,	OCT_13 = coalesce(spt.OCT_13, 0)
	,	NOV_13 = coalesce(spt.NOV_13, 0)
	,	DEC_13 = coalesce(spt.DEC_13, 0)
	,	JAN_14 = coalesce(spt.JAN_14, 0)
	,	FEB_14 = coalesce(spt.FEB_14, 0)
	,	MAR_14 = coalesce(spt.MAR_14, 0)
	,	APR_14 = coalesce(spt.APR_14, 0)
	,	MAY_14 = coalesce(spt.MAY_14, 0)
	,	JUN_14 = coalesce(spt.JUN_14, 0)
	,	JUL_14 = coalesce(spt.JUL_14, 0)
	,	AUG_14 = coalesce(spt.AUG_14, 0)
	,	SEP_14 = coalesce(spt.SEP_14, 0)
	,	OCT_14 = coalesce(spt.OCT_14, 0)
	,	NOV_14 = coalesce(spt.NOV_14, 0)
	,	DEC_14 = coalesce(spt.DEC_14, 0)
	,	JAN_15 = coalesce(spt.JAN_15, 0)
	,	FEB_15 = coalesce(spt.FEB_15, 0)
	,	MAR_15 = coalesce(spt.MAR_15, 0)
	,	APR_15 = coalesce(spt.APR_15, 0)
	,	MAY_15 = coalesce(spt.MAY_15, 0)
	,	JUN_15 = coalesce(spt.JUN_15, 0)
	,	JUL_15 = coalesce(spt.JUL_15, 0)
	,	AUG_15 = coalesce(spt.AUG_15, 0)
	,	SEP_15 = coalesce(spt.SEP_15, 0)
	,	OCT_15 = coalesce(spt.OCT_15, 0)
	,	NOV_15 = coalesce(spt.NOV_15, 0)
	,	DEC_15 = coalesce(spt.DEC_15, 0)
	,	JAN_16 = coalesce(spt.JAN_16, 0)
	,	FEB_16 = coalesce(spt.FEB_16, 0)
	,	MAR_16 = coalesce(spt.MAR_16, 0)
	,	APR_16 = coalesce(spt.APR_16, 0)
	,	MAY_16 = coalesce(spt.MAY_16, 0)
	,	JUN_16 = coalesce(spt.JUN_16, 0)
	,	JUL_16 = coalesce(spt.JUL_16, 0)
	,	AUG_16 = coalesce(spt.AUG_16, 0)
	,	SEP_16 = coalesce(spt.SEP_16, 0)
	,	OCT_16 = coalesce(spt.OCT_16, 0)
	,	NOV_16 = coalesce(spt.NOV_16, 0)
	,	DEC_16 = coalesce(spt.DEC_16, 0)
	,	JAN_17 = coalesce(spt.JAN_17, 0)
	,	FEB_17 = coalesce(spt.FEB_17, 0)
	,	MAR_17 = coalesce(spt.MAR_17, 0)
	,	APR_17 = coalesce(spt.APR_17, 0)
	,	MAY_17 = coalesce(spt.MAY_17, 0)
	,	JUN_17 = coalesce(spt.JUN_17, 0)
	,	JUL_17 = coalesce(spt.JUL_17, 0)
	,	AUG_17 = coalesce(spt.AUG_17, 0)
	,	SEP_17 = coalesce(spt.SEP_17, 0)
	,	OCT_17 = coalesce(spt.OCT_17, 0)
	,	NOV_17 = coalesce(spt.NOV_17, 0)
	,	DEC_17 = coalesce(spt.DEC_17, 0)
	,	JAN_18 = coalesce(spt.JAN_18, 0)
	,	FEB_18 = coalesce(spt.FEB_18, 0)
	,	MAR_18 = coalesce(spt.MAR_18, 0)
	,	APR_18 = coalesce(spt.APR_18, 0)
	,	MAY_18 = coalesce(spt.MAY_18, 0)
	,	JUN_18 = coalesce(spt.JUN_18, 0)
	,	JUL_18 = coalesce(spt.JUL_18, 0)
	,	AUG_18 = coalesce(spt.AUG_18, 0)
	,	SEP_18 = coalesce(spt.SEP_18, 0)
	,	OCT_18 = coalesce(spt.OCT_18, 0)
	,	NOV_18 = coalesce(spt.NOV_18, 0)
	,	DEC_18 = coalesce(spt.DEC_18, 0)
	,	JAN_19 = coalesce(spt.JAN_19, 0)
	,	FEB_19 = coalesce(spt.FEB_19, 0)
	,	MAR_19 = coalesce(spt.MAR_19, 0)
	,	APR_19 = coalesce(spt.APR_19, 0)
	,	MAY_19 = coalesce(spt.MAY_19, 0)
	,	JUN_19 = coalesce(spt.JUN_19, 0)
	,	JUL_19 = coalesce(spt.JUL_19, 0)
	,	AUG_19 = coalesce(spt.AUG_19, 0)
	,	SEP_19 = coalesce(spt.SEP_19, 0)
	,	OCT_19 = coalesce(spt.OCT_19, 0)
	,	NOV_19 = coalesce(spt.NOV_19, 0)
	,	DEC_19 = coalesce(spt.DEC_19, 0)
	,	JAN_20 = coalesce(spt.JAN_20, 0)
	,	FEB_20 = coalesce(spt.FEB_20, 0)
	,	MAR_20 = coalesce(spt.MAR_20, 0)
	,	APR_20 = coalesce(spt.APR_20, 0)
	,	MAY_20 = coalesce(spt.MAY_20, 0)
	,	JUN_20 = coalesce(spt.JUN_20, 0)
	,	JUL_20 = coalesce(spt.JUL_20, 0)
	,	AUG_20 = coalesce(spt.AUG_20, 0)
	,	SEP_20 = coalesce(spt.SEP_20, 0)
	,	OCT_20 = coalesce(spt.OCT_20, 0)
	,	NOV_20 = coalesce(spt.NOV_20, 0)
	,	DEC_20 = coalesce(spt.DEC_20, 0)
	from
		eeiuser.acctg_csm_selling_prices_tabular spt
) as spp
unpivot
(
	SellingPrice for SellingPrices in 
	(
		JAN_08
	,	FEB_08
	,	MAR_08
	,	APR_08
	,	MAY_08
	,	JUN_08
	,	JUL_08
	,	AUG_08
	,	SEP_08
	,	OCT_08
	,	NOV_08
	,	DEC_08
	,	JAN_09
	,	FEB_09
	,	MAR_09
	,	APR_09
	,	MAY_09
	,	JUN_09
	,	JUL_09
	,	AUG_09
	,	SEP_09
	,	OCT_09
	,	NOV_09
	,	DEC_09
	,	JAN_10
	,	FEB_10
	,	MAR_10
	,	APR_10
	,	MAY_10
	,	JUN_10
	,	JUL_10
	,	AUG_10
	,	SEP_10
	,	OCT_10
	,	NOV_10
	,	DEC_10
	,	JAN_11
	,	FEB_11
	,	MAR_11
	,	APR_11
	,	MAY_11
	,	JUN_11
	,	JUL_11
	,	AUG_11
	,	SEP_11
	,	OCT_11
	,	NOV_11
	,	DEC_11
	,	JAN_12
	,	FEB_12
	,	MAR_12
	,	APR_12
	,	MAY_12
	,	JUN_12
	,	JUL_12
	,	AUG_12
	,	SEP_12
	,	OCT_12
	,	NOV_12
	,	DEC_12
	,	JAN_13
	,	FEB_13
	,	MAR_13
	,	APR_13
	,	MAY_13
	,	JUN_13
	,	JUL_13
	,	AUG_13
	,	SEP_13
	,	OCT_13
	,	NOV_13
	,	DEC_13
	,	JAN_14
	,	FEB_14
	,	MAR_14
	,	APR_14
	,	MAY_14
	,	JUN_14
	,	JUL_14
	,	AUG_14
	,	SEP_14
	,	OCT_14
	,	NOV_14
	,	DEC_14
	,	JAN_15
	,	FEB_15
	,	MAR_15
	,	APR_15
	,	MAY_15
	,	JUN_15
	,	JUL_15
	,	AUG_15
	,	SEP_15
	,	OCT_15
	,	NOV_15
	,	DEC_15
	,	JAN_16
	,	FEB_16
	,	MAR_16
	,	APR_16
	,	MAY_16
	,	JUN_16
	,	JUL_16
	,	AUG_16
	,	SEP_16
	,	OCT_16
	,	NOV_16
	,	DEC_16
	,	JAN_17
	,	FEB_17
	,	MAR_17
	,	APR_17
	,	MAY_17
	,	JUN_17
	,	JUL_17
	,	AUG_17
	,	SEP_17
	,	OCT_17
	,	NOV_17
	,	DEC_17
	,	JAN_18
	,	FEB_18
	,	MAR_18
	,	APR_18
	,	MAY_18
	,	JUN_18
	,	JUL_18
	,	AUG_18
	,	SEP_18
	,	OCT_18
	,	NOV_18
	,	DEC_18
	,	JAN_19
	,	FEB_19
	,	MAR_19
	,	APR_19
	,	MAY_19
	,	JUN_19
	,	JUL_19
	,	AUG_19
	,	SEP_19
	,	OCT_19
	,	NOV_19
	,	DEC_19
	,	JAN_20
	,	FEB_20
	,	MAR_20
	,	APR_20
	,	MAY_20
	,	JUN_20
	,	JUL_20
	,	AUG_20
	,	SEP_20
	,	OCT_20
	,	NOV_20
	,	DEC_20
	)
) as spu

GO
