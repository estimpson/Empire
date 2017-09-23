SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_select_csm_demand] 
  @base_part varchar(30),
  @release_id varchar(30)
as

--[EEIUser].[acctg_csm_sp_select_csm_demand]  'FNG0036',   '2016-03'

select	@base_part as [base_part],
		b.version,
		b.release_id, 
		b.[Mnemonic-Vehicle/Plant] as MnemonicVehiclePlant, 
		b.platform, 
		b.program, 
		b.brand+' '+b.nameplate as [vehicle], 
		b.plant, 
		b.sop, 
		b.eop,  
		ISNULL(a.qty_per,0) as [qty_per],
		ISNULL(a.take_rate,0) as [take_rate], 
		ISNULL(a.family_allocation,0) as [family_allocation],

		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2015] end),0) as [jan 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2015] end),0) as [feb 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2015] end),0) as [mar 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2015] end),0) as [apr 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2015] end),0) as [may 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2015] end),0) as [jun 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2015] end),0) as [jul 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2015] end),0) as [aug 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2015] end),0) as [sep 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2015] end),0) as [oct 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2015] end),0) as [nov 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2015] end),0) as [dec 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2015],0)+ISNULL(b.[Feb 2015],0)+ISNULL(b.[Mar 2015],0)+ISNULL(b.[Apr 2015],0)+ISNULL(b.[May 2015],0)+ISNULL(b.[Jun 2015],0)+ISNULL(b.[Jul 2015],0)+ISNULL(b.[Aug 2015],0)+ISNULL(b.[Sep 2015],0)+ISNULL(b.[Oct 2015],0)+ISNULL(b.[Nov 2015],0)+ISNULL(b.[Dec 2015],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2015]+b.[Feb 2015]+b.[Mar 2015]+b.[Apr 2015]+b.[May 2015]+b.[Jun 2015]+b.[Jul 2015]+b.[Aug 2015]+b.[Sep 2015]+b.[Oct 2015]+b.[Nov 2015]+b.[Dec 2015]) end),0) as [total_2015],
		
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2016] end),0) as [jan 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2016] end),0) as [feb 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2016] end),0) as [mar 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2016] end),0) as [apr 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2016] end),0) as [may 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2016] end),0) as [jun 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2016] end),0) as [jul 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2016] end),0) as [aug 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2016] end),0) as [sep 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2016] end),0) as [oct 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2016] end),0) as [nov 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2016] end),0) as [dec 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2016],0)+ISNULL(b.[Feb 2016],0)+ISNULL(b.[Mar 2016],0)+ISNULL(b.[Apr 2016],0)+ISNULL(b.[May 2016],0)+ISNULL(b.[Jun 2016],0)+ISNULL(b.[Jul 2016],0)+ISNULL(b.[Aug 2016],0)+ISNULL(b.[Sep 2016],0)+ISNULL(b.[Oct 2016],0)+ISNULL(b.[Nov 2016],0)+ISNULL(b.[Dec 2016],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2016]+b.[Feb 2016]+b.[Mar 2016]+b.[Apr 2016]+b.[May 2016]+b.[Jun 2016]+b.[Jul 2016]+b.[Aug 2016]+b.[Sep 2016]+b.[Oct 2016]+b.[Nov 2016]+b.[Dec 2016]) end),0) as [total_2016],

		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2017] end),0) as [jan 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2017] end),0) as [feb 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2017] end),0) as [mar 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2017] end),0) as [apr 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2017] end),0) as [may 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2017] end),0) as [jun 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2017] end),0) as [jul 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2017] end),0) as [aug 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2017] end),0) as [sep 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2017] end),0) as [oct 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2017] end),0) as [nov 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2017] end),0) as [dec 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2017],0)+ISNULL(b.[Feb 2017],0)+ISNULL(b.[Mar 2017],0)+ISNULL(b.[Apr 2017],0)+ISNULL(b.[May 2017],0)+ISNULL(b.[Jun 2017],0)+ISNULL(b.[Jul 2017],0)+ISNULL(b.[Aug 2017],0)+ISNULL(b.[Sep 2017],0)+ISNULL(b.[Oct 2017],0)+ISNULL(b.[Nov 2017],0)+ISNULL(b.[Dec 2017],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2017]+b.[Feb 2017]+b.[Mar 2017]+b.[Apr 2017]+b.[May 2017]+b.[Jun 2017]+b.[Jul 2017]+b.[Aug 2017]+b.[Sep 2017]+b.[Oct 2017]+b.[Nov 2017]+b.[Dec 2017]) end),0) as [total_2017],

		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2018] end),0) as [jan 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2018] end),0) as [feb 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2018] end),0) as [mar 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2018] end),0) as [apr 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2018] end),0) as [may 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2018] end),0) as [jun 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2018] end),0) as [jul 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2018] end),0) as [aug 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2018] end),0) as [sep 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2018] end),0) as [oct 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2018] end),0) as [nov 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2018] end),0) as [dec 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2018],0)+ISNULL(b.[Feb 2018],0)+ISNULL(b.[Mar 2018],0)+ISNULL(b.[Apr 2018],0)+ISNULL(b.[May 2018],0)+ISNULL(b.[Jun 2018],0)+ISNULL(b.[Jul 2018],0)+ISNULL(b.[Aug 2018],0)+ISNULL(b.[Sep 2018],0)+ISNULL(b.[Oct 2018],0)+ISNULL(b.[Nov 2018],0)+ISNULL(b.[Dec 2018],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2018]+b.[Feb 2018]+b.[Mar 2018]+b.[Apr 2018]+b.[May 2018]+b.[Jun 2018]+b.[Jul 2018]+b.[Aug 2018]+b.[Sep 2018]+b.[Oct 2018]+b.[Nov 2018]+b.[Dec 2018]) end),0) as [total_2018],

		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2019] end),0) as [total_2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2020] end),0) as [total_2020]
from 
		(	select	* 
			from	eeiuser.acctg_csm_base_part_mnemonic
		) a 
		left outer join 
		(	select	* 
			from	eeiuser.acctg_csm_NAIHS 
			where	release_id = @release_id
		) b
		on b.[Mnemonic-Vehicle/Plant] = a.mnemonic 
		where	a.base_part = @base_part 
			and b.[Mnemonic-Vehicle/Plant] is not null
			and b.Version = 'CSM'
			--and (case	when b.version='Empire' 
			--			then ( ISNULL(b.[Jan 2012],0)+ISNULL(b.[Feb 2012],0)+ISNULL(b.[Mar 2012],0)+ISNULL(b.[Apr 2012],0)+ISNULL(b.[May 2012],0)+ISNULL(b.[Jun 2012],0)+ISNULL(b.[Jul 2012],0)+ISNULL(b.[Aug 2012],0)+ISNULL(b.[Sep 2012],0)+ISNULL(b.[Oct 2012],0)+ISNULL(b.[Nov 2012],0)+ISNULL(b.[Dec 2012],0)
			--		   		  +ISNULL(b.[Jan 2014],0)+ISNULL(b.[Feb 2014],0)+ISNULL(b.[Mar 2014],0)+ISNULL(b.[Apr 2014],0)+ISNULL(b.[May 2014],0)+ISNULL(b.[Jun 2014],0)+ISNULL(b.[Jul 2014],0)+ISNULL(b.[Aug 2014],0)+ISNULL(b.[Sep 2014],0)+ISNULL(b.[Oct 2014],0)+ISNULL(b.[Nov 2014],0)+ISNULL(b.[Dec 2014],0)
			--				  +ISNULL(b.[Jan 2015],0)+ISNULL(b.[Feb 2015],0)+ISNULL(b.[Mar 2015],0)+ISNULL(b.[Apr 2015],0)+ISNULL(b.[May 2015],0)+ISNULL(b.[Jun 2015],0)+ISNULL(b.[Jul 2015],0)+ISNULL(b.[Aug 2015],0)+ISNULL(b.[Sep 2015],0)+ISNULL(b.[Oct 2015],0)+ISNULL(b.[Nov 2015],0)+ISNULL(b.[Dec 2015],0)
			--				  +ISNULL(b.[Jan 2011],0)+ISNULL(b.[Feb 2011],0)+ISNULL(b.[Mar 2011],0)+ISNULL(b.[Apr 2011],0)+ISNULL(b.[May 2011],0)+ISNULL(b.[Jun 2011],0)+ISNULL(b.[Jul 2011],0)+ISNULL(b.[Aug 2011],0)+ISNULL(b.[Sep 2011],0)+ISNULL(b.[Oct 2011],0)+ISNULL(b.[Nov 2011],0)+ISNULL(b.[Dec 2011],0)
			--				  +ISNULL(b.[Jan 2012],0)+ISNULL(b.[Feb 2012],0)+ISNULL(b.[Mar 2012],0)+ISNULL(b.[Apr 2012],0)+ISNULL(b.[May 2012],0)+ISNULL(b.[Jun 2012],0)+ISNULL(b.[Jul 2012],0)+ISNULL(b.[Aug 2012],0)+ISNULL(b.[Sep 2012],0)+ISNULL(b.[Oct 2012],0)+ISNULL(b.[Nov 2012],0)+ISNULL(b.[Dec 2012],0)
			--		  	      ) 
			--		  	else  a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2012]+b.[Feb 2012]+b.[Mar 2012]+b.[Apr 2012]+b.[May 2012]+b.[Jun 2012]+b.[Jul 2012]+b.[Aug 2012]+b.[Sep 2012]+b.[Oct 2012]+b.[Nov 2012]+b.[Dec 2012]
			--		  													+b.[Jan 2014]+b.[Feb 2014]+b.[Mar 2014]+b.[Apr 2014]+b.[May 2014]+b.[Jun 2014]+b.[Jul 2014]+b.[Aug 2014]+b.[Sep 2014]+b.[Oct 2014]+b.[Nov 2014]+b.[Dec 2014]
			--		  													+b.[Jan 2015]+b.[Feb 2015]+b.[Mar 2015]+b.[Apr 2015]+b.[May 2015]+b.[Jun 2015]+b.[Jul 2015]+b.[Aug 2015]+b.[Sep 2015]+b.[Oct 2015]+b.[Nov 2015]+b.[Dec 2015]
			--		  													+b.[Jan 2011]+b.[Feb 2011]+b.[Mar 2011]+b.[Apr 2011]+b.[May 2011]+b.[Jun 2011]+b.[Jul 2011]+b.[Aug 2011]+b.[Sep 2011]+b.[Oct 2011]+b.[Nov 2011]+b.[Dec 2011]
			--		  													+b.[Jan 2012]+b.[Feb 2012]+b.[Mar 2012]+b.[Apr 2012]+b.[May 2012]+b.[Jun 2012]+b.[Jul 2012]+b.[Aug 2012]+b.[Sep 2012]+b.[Oct 2012]+b.[Nov 2012]+b.[Dec 2012]		
			--		  													) 
			--			end
			--	) <> -.00003
			  -- (case @checkbox1 when 0 then 0 else -.0003 end) 
			 
order by b.vehicle desc












GO
