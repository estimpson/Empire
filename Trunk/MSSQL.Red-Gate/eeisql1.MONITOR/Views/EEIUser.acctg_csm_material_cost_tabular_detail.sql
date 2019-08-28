SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EEIUser].[acctg_csm_material_cost_tabular_detail]
as
select
	ReleaseID
,	BasePart
,	[Version]
,	EffectiveMonth = month(dateadd(month, row_number() over (partition by ReleaseId, Version, BasePart order by BasePart) - 1, '2008-1-1'))
,	EffectiveYear = year(dateadd(month, row_number() over (partition by ReleaseId, Version, BasePart order by BasePart) - 1, '2008-1-1'))
,	EffectiveDT = dateadd(month, row_number() over (partition by ReleaseId, Version, BasePart order by BasePart) - 1, '2008-1-1')
,	MaterialCost
from
(
	select
		mct.RELEASE_ID as ReleaseId
	,	mct.BASE_PART as BasePart
	,	mct.[VERSION] as [Version]
	,	JAN_08 = coalesce(mct.JAN_08, 0)
	,	FEB_08 = coalesce(mct.FEB_08, 0)
	,	MAR_08 = coalesce(mct.MAR_08, 0)
	,	APR_08 = coalesce(mct.APR_08, 0)
	,	MAY_08 = coalesce(mct.MAY_08, 0)
	,	JUN_08 = coalesce(mct.JUN_08, 0)
	,	JUL_08 = coalesce(mct.JUL_08, 0)
	,	AUG_08 = coalesce(mct.AUG_08, 0)
	,	SEP_08 = coalesce(mct.SEP_08, 0)
	,	OCT_08 = coalesce(mct.OCT_08, 0)
	,	NOV_08 = coalesce(mct.NOV_08, 0)
	,	DEC_08 = coalesce(mct.DEC_08, 0)
	,	JAN_09 = coalesce(mct.JAN_09, 0)
	,	FEB_09 = coalesce(mct.FEB_09, 0)
	,	MAR_09 = coalesce(mct.MAR_09, 0)
	,	APR_09 = coalesce(mct.APR_09, 0)
	,	MAY_09 = coalesce(mct.MAY_09, 0)
	,	JUN_09 = coalesce(mct.JUN_09, 0)
	,	JUL_09 = coalesce(mct.JUL_09, 0)
	,	AUG_09 = coalesce(mct.AUG_09, 0)
	,	SEP_09 = coalesce(mct.SEP_09, 0)
	,	OCT_09 = coalesce(mct.OCT_09, 0)
	,	NOV_09 = coalesce(mct.NOV_09, 0)
	,	DEC_09 = coalesce(mct.DEC_09, 0)
	,	JAN_10 = coalesce(mct.JAN_10, 0)
	,	FEB_10 = coalesce(mct.FEB_10, 0)
	,	MAR_10 = coalesce(mct.MAR_10, 0)
	,	APR_10 = coalesce(mct.APR_10, 0)
	,	MAY_10 = coalesce(mct.MAY_10, 0)
	,	JUN_10 = coalesce(mct.JUN_10, 0)
	,	JUL_10 = coalesce(mct.JUL_10, 0)
	,	AUG_10 = coalesce(mct.AUG_10, 0)
	,	SEP_10 = coalesce(mct.SEP_10, 0)
	,	OCT_10 = coalesce(mct.OCT_10, 0)
	,	NOV_10 = coalesce(mct.NOV_10, 0)
	,	DEC_10 = coalesce(mct.DEC_10, 0)
	,	JAN_11 = coalesce(mct.JAN_11, 0)
	,	FEB_11 = coalesce(mct.FEB_11, 0)
	,	MAR_11 = coalesce(mct.MAR_11, 0)
	,	APR_11 = coalesce(mct.APR_11, 0)
	,	MAY_11 = coalesce(mct.MAY_11, 0)
	,	JUN_11 = coalesce(mct.JUN_11, 0)
	,	JUL_11 = coalesce(mct.JUL_11, 0)
	,	AUG_11 = coalesce(mct.AUG_11, 0)
	,	SEP_11 = coalesce(mct.SEP_11, 0)
	,	OCT_11 = coalesce(mct.OCT_11, 0)
	,	NOV_11 = coalesce(mct.NOV_11, 0)
	,	DEC_11 = coalesce(mct.DEC_11, 0)
	,	JAN_12 = coalesce(mct.JAN_12, 0)
	,	FEB_12 = coalesce(mct.FEB_12, 0)
	,	MAR_12 = coalesce(mct.MAR_12, 0)
	,	APR_12 = coalesce(mct.APR_12, 0)
	,	MAY_12 = coalesce(mct.MAY_12, 0)
	,	JUN_12 = coalesce(mct.JUN_12, 0)
	,	JUL_12 = coalesce(mct.JUL_12, 0)
	,	AUG_12 = coalesce(mct.AUG_12, 0)
	,	SEP_12 = coalesce(mct.SEP_12, 0)
	,	OCT_12 = coalesce(mct.OCT_12, 0)
	,	NOV_12 = coalesce(mct.NOV_12, 0)
	,	DEC_12 = coalesce(mct.DEC_12, 0)
	,	JAN_13 = coalesce(mct.JAN_13, 0)
	,	FEB_13 = coalesce(mct.FEB_13, 0)
	,	MAR_13 = coalesce(mct.MAR_13, 0)
	,	APR_13 = coalesce(mct.APR_13, 0)
	,	MAY_13 = coalesce(mct.MAY_13, 0)
	,	JUN_13 = coalesce(mct.JUN_13, 0)
	,	JUL_13 = coalesce(mct.JUL_13, 0)
	,	AUG_13 = coalesce(mct.AUG_13, 0)
	,	SEP_13 = coalesce(mct.SEP_13, 0)
	,	OCT_13 = coalesce(mct.OCT_13, 0)
	,	NOV_13 = coalesce(mct.NOV_13, 0)
	,	DEC_13 = coalesce(mct.DEC_13, 0)
	,	JAN_14 = coalesce(mct.JAN_14, 0)
	,	FEB_14 = coalesce(mct.FEB_14, 0)
	,	MAR_14 = coalesce(mct.MAR_14, 0)
	,	APR_14 = coalesce(mct.APR_14, 0)
	,	MAY_14 = coalesce(mct.MAY_14, 0)
	,	JUN_14 = coalesce(mct.JUN_14, 0)
	,	JUL_14 = coalesce(mct.JUL_14, 0)
	,	AUG_14 = coalesce(mct.AUG_14, 0)
	,	SEP_14 = coalesce(mct.SEP_14, 0)
	,	OCT_14 = coalesce(mct.OCT_14, 0)
	,	NOV_14 = coalesce(mct.NOV_14, 0)
	,	DEC_14 = coalesce(mct.DEC_14, 0)
	,	JAN_15 = coalesce(mct.JAN_15, 0)
	,	FEB_15 = coalesce(mct.FEB_15, 0)
	,	MAR_15 = coalesce(mct.MAR_15, 0)
	,	APR_15 = coalesce(mct.APR_15, 0)
	,	MAY_15 = coalesce(mct.MAY_15, 0)
	,	JUN_15 = coalesce(mct.JUN_15, 0)
	,	JUL_15 = coalesce(mct.JUL_15, 0)
	,	AUG_15 = coalesce(mct.AUG_15, 0)
	,	SEP_15 = coalesce(mct.SEP_15, 0)
	,	OCT_15 = coalesce(mct.OCT_15, 0)
	,	NOV_15 = coalesce(mct.NOV_15, 0)
	,	DEC_15 = coalesce(mct.DEC_15, 0)
	,	JAN_16 = coalesce(mct.JAN_16, 0)
	,	FEB_16 = coalesce(mct.FEB_16, 0)
	,	MAR_16 = coalesce(mct.MAR_16, 0)
	,	APR_16 = coalesce(mct.APR_16, 0)
	,	MAY_16 = coalesce(mct.MAY_16, 0)
	,	JUN_16 = coalesce(mct.JUN_16, 0)
	,	JUL_16 = coalesce(mct.JUL_16, 0)
	,	AUG_16 = coalesce(mct.AUG_16, 0)
	,	SEP_16 = coalesce(mct.SEP_16, 0)
	,	OCT_16 = coalesce(mct.OCT_16, 0)
	,	NOV_16 = coalesce(mct.NOV_16, 0)
	,	DEC_16 = coalesce(mct.DEC_16, 0)
	,	JAN_17 = coalesce(mct.JAN_17, 0)
	,	FEB_17 = coalesce(mct.FEB_17, 0)
	,	MAR_17 = coalesce(mct.MAR_17, 0)
	,	APR_17 = coalesce(mct.APR_17, 0)
	,	MAY_17 = coalesce(mct.MAY_17, 0)
	,	JUN_17 = coalesce(mct.JUN_17, 0)
	,	JUL_17 = coalesce(mct.JUL_17, 0)
	,	AUG_17 = coalesce(mct.AUG_17, 0)
	,	SEP_17 = coalesce(mct.SEP_17, 0)
	,	OCT_17 = coalesce(mct.OCT_17, 0)
	,	NOV_17 = coalesce(mct.NOV_17, 0)
	,	DEC_17 = coalesce(mct.DEC_17, 0)
	,	JAN_18 = coalesce(mct.JAN_18, 0)
	,	FEB_18 = coalesce(mct.FEB_18, 0)
	,	MAR_18 = coalesce(mct.MAR_18, 0)
	,	APR_18 = coalesce(mct.APR_18, 0)
	,	MAY_18 = coalesce(mct.MAY_18, 0)
	,	JUN_18 = coalesce(mct.JUN_18, 0)
	,	JUL_18 = coalesce(mct.JUL_18, 0)
	,	AUG_18 = coalesce(mct.AUG_18, 0)
	,	SEP_18 = coalesce(mct.SEP_18, 0)
	,	OCT_18 = coalesce(mct.OCT_18, 0)
	,	NOV_18 = coalesce(mct.NOV_18, 0)
	,	DEC_18 = coalesce(mct.DEC_18, 0)
	,	JAN_19 = coalesce(mct.JAN_19, 0)
	,	FEB_19 = coalesce(mct.FEB_19, 0)
	,	MAR_19 = coalesce(mct.MAR_19, 0)
	,	APR_19 = coalesce(mct.APR_19, 0)
	,	MAY_19 = coalesce(mct.MAY_19, 0)
	,	JUN_19 = coalesce(mct.JUN_19, 0)
	,	JUL_19 = coalesce(mct.JUL_19, 0)
	,	AUG_19 = coalesce(mct.AUG_19, 0)
	,	SEP_19 = coalesce(mct.SEP_19, 0)
	,	OCT_19 = coalesce(mct.OCT_19, 0)
	,	NOV_19 = coalesce(mct.NOV_19, 0)
	,	DEC_19 = coalesce(mct.DEC_19, 0)
	,	JAN_20 = coalesce(mct.JAN_20, 0)
	,	FEB_20 = coalesce(mct.FEB_20, 0)
	,	MAR_20 = coalesce(mct.MAR_20, 0)
	,	APR_20 = coalesce(mct.APR_20, 0)
	,	MAY_20 = coalesce(mct.MAY_20, 0)
	,	JUN_20 = coalesce(mct.JUN_20, 0)
	,	JUL_20 = coalesce(mct.JUL_20, 0)
	,	AUG_20 = coalesce(mct.AUG_20, 0)
	,	SEP_20 = coalesce(mct.SEP_20, 0)
	,	OCT_20 = coalesce(mct.OCT_20, 0)
	,	NOV_20 = coalesce(mct.NOV_20, 0)
	,	DEC_20 = coalesce(mct.DEC_20, 0)
	,	JAN_21 = coalesce(mct.JAN_21, 0)
	,	FEB_21 = coalesce(mct.FEB_21, 0)
	,	MAR_21 = coalesce(mct.MAR_21, 0)
	,	APR_21 = coalesce(mct.APR_21, 0)
	,	MAY_21 = coalesce(mct.MAY_21, 0)
	,	JUN_21 = coalesce(mct.JUN_21, 0)
	,	JUL_21 = coalesce(mct.JUL_21, 0)
	,	AUG_21 = coalesce(mct.AUG_21, 0)
	,	SEP_21 = coalesce(mct.SEP_21, 0)
	,	OCT_21 = coalesce(mct.OCT_21, 0)
	,	NOV_21 = coalesce(mct.NOV_21, 0)
	,	DEC_21 = coalesce(mct.DEC_21, 0)
	from
		eeiuser.acctg_csm_material_cost_tabular mct
) as spp
unpivot
(
	MaterialCost for MaterialCosts in 
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
	,	JAN_21
	,	FEB_21
	,	MAR_21
	,	APR_21
	,	MAY_21
	,	JUN_21
	,	JUL_21
	,	AUG_21
	,	SEP_21
	,	OCT_21
	,	NOV_21
	,	DEC_21
	)
) as mcu
GO
