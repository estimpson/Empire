SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [TOPS].[Leg_EOP]
as
select
	BasePart = acvssf.base_part
,	SOP = min(acvssf.sop)
,	EOP = max(acvssf.eop)
,	CSM_SOP = min(acvssf.CSM_sop)
,	CSM_EOP = max(acvssf.CSM_eop)
from
	eeiuser.acctg_csm_vw_select_sales_forecast acvssf
group by
	acvssf.base_part
GO
