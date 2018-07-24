SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [TOPS].[Leg_EOP]
as
select
	BasePart = base_part
,	SOP = sop
,	EOP = eop
from
	[eeiuser].[acctg_csm_vw_select_sales_forecast]
GO
