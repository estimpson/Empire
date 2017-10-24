SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EEIUser].[OBS_acctg_csm_sp_select_base_part_mnemonic_dw] 
  @base_part varchar(30),
  @release_id varchar(15)
as

select	@base_part as base_part,
		@release_id AS release_id,
		min(a.family) as family,
		min(a.empire_market_segment) as empire_market_segment,
		min(a.empire_application) as empire_application,
		min(a.empire_sop) as empire_sop,
		max(a.empire_eop) as empire_eop,
		b.include_in_forecast
from	eeiuser.acctg_csm_base_part_mnemonic a
JOIN	eeiuser.acctg_csm_excluded_base_parts b
ON	a.base_part = b.base_part 
where	a.base_part = @base_part
	AND b.release_id = @release_id
group by a.base_part,
		b.release_id,
		b.include_in_forecast


GO
