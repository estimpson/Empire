SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE procedure [EEIUser].[acctg_csm_sp_select_csm_demand2019] 
  @base_part varchar(30),
  @release_id varchar(30)
as

--[EEIUser].[acctg_csm_sp_select_csm_demand2019]  'DFN0001',   '2019-03'

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
		ISNULL(a.qty_per,0) as qty_per,
		ISNULL(a.take_rate,0) as take_rate, 
		ISNULL(a.family_allocation,0) as family_allocation,

		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2015] end),0) as [jan2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2015] end),0) as [feb2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2015] end),0) as [mar2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2015] end),0) as [apr2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2015] end),0) as [may2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2015] end),0) as [jun2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2015] end),0) as [jul2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2015] end),0) as [aug2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2015] end),0) as [sep2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2015] end),0) as [oct2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2015] end),0) as [nov2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2015] end),0) as [dec2015], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2015],0)+ISNULL(b.[Feb 2015],0)+ISNULL(b.[Mar 2015],0)+ISNULL(b.[Apr 2015],0)+ISNULL(b.[May 2015],0)+ISNULL(b.[Jun 2015],0)+ISNULL(b.[Jul 2015],0)+ISNULL(b.[Aug 2015],0)+ISNULL(b.[Sep 2015],0)+ISNULL(b.[Oct 2015],0)+ISNULL(b.[Nov 2015],0)+ISNULL(b.[Dec 2015],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2015]+b.[Feb 2015]+b.[Mar 2015]+b.[Apr 2015]+b.[May 2015]+b.[Jun 2015]+b.[Jul 2015]+b.[Aug 2015]+b.[Sep 2015]+b.[Oct 2015]+b.[Nov 2015]+b.[Dec 2015]) end),0) as [total_2015],
		
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2016] end),0) as [jan2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2016] end),0) as [feb2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2016] end),0) as [mar2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2016] end),0) as [apr2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2016] end),0) as [may2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2016] end),0) as [jun2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2016] end),0) as [jul2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2016] end),0) as [aug2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2016] end),0) as [sep2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2016] end),0) as [oct2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2016] end),0) as [nov2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2016] end),0) as [dec2016], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2016],0)+ISNULL(b.[Feb 2016],0)+ISNULL(b.[Mar 2016],0)+ISNULL(b.[Apr 2016],0)+ISNULL(b.[May 2016],0)+ISNULL(b.[Jun 2016],0)+ISNULL(b.[Jul 2016],0)+ISNULL(b.[Aug 2016],0)+ISNULL(b.[Sep 2016],0)+ISNULL(b.[Oct 2016],0)+ISNULL(b.[Nov 2016],0)+ISNULL(b.[Dec 2016],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2016]+b.[Feb 2016]+b.[Mar 2016]+b.[Apr 2016]+b.[May 2016]+b.[Jun 2016]+b.[Jul 2016]+b.[Aug 2016]+b.[Sep 2016]+b.[Oct 2016]+b.[Nov 2016]+b.[Dec 2016]) end),0) as [total_2016],

		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2017] end),0) as [jan2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2017] end),0) as [feb2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2017] end),0) as [mar2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2017] end),0) as [apr2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2017] end),0) as [may2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2017] end),0) as [jun2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2017] end),0) as [jul2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2017] end),0) as [aug2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2017] end),0) as [sep2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2017] end),0) as [oct2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2017] end),0) as [nov2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2017] end),0) as [dec2017], 
		--ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2017],0)+ISNULL(b.[Feb 2017],0)+ISNULL(b.[Mar 2017],0)+ISNULL(b.[Apr 2017],0)+ISNULL(b.[May 2017],0)+ISNULL(b.[Jun 2017],0)+ISNULL(b.[Jul 2017],0)+ISNULL(b.[Aug 2017],0)+ISNULL(b.[Sep 2017],0)+ISNULL(b.[Oct 2017],0)+ISNULL(b.[Nov 2017],0)+ISNULL(b.[Dec 2017],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2017]+b.[Feb 2017]+b.[Mar 2017]+b.[Apr 2017]+b.[May 2017]+b.[Jun 2017]+b.[Jul 2017]+b.[Aug 2017]+b.[Sep 2017]+b.[Oct 2017]+b.[Nov 2017]+b.[Dec 2017]) end),0) as [total_2017],

		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2018] end),0) as [jan2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2018] end),0) as [feb2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2018] end),0) as [mar2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2018] end),0) as [apr2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2018] end),0) as [may2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2018] end),0) as [jun2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2018] end),0) as [jul2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2018] end),0) as [aug2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2018] end),0) as [sep2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2018] end),0) as [oct2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2018] end),0) as [nov2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2018] end),0) as [dec2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2018],0)+ISNULL(b.[Feb 2018],0)+ISNULL(b.[Mar 2018],0)+ISNULL(b.[Apr 2018],0)+ISNULL(b.[May 2018],0)+ISNULL(b.[Jun 2018],0)+ISNULL(b.[Jul 2018],0)+ISNULL(b.[Aug 2018],0)+ISNULL(b.[Sep 2018],0)+ISNULL(b.[Oct 2018],0)+ISNULL(b.[Nov 2018],0)+ISNULL(b.[Dec 2018],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2018]+b.[Feb 2018]+b.[Mar 2018]+b.[Apr 2018]+b.[May 2018]+b.[Jun 2018]+b.[Jul 2018]+b.[Aug 2018]+b.[Sep 2018]+b.[Oct 2018]+b.[Nov 2018]+b.[Dec 2018]) end),0) as [total_2018],

		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2019] end),0) as [jan2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2019] end),0) as [feb2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2019] end),0) as [mar2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2019] end),0) as [apr2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2019] end),0) as [may2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2019] end),0) as [jun2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2019] end),0) as [jul2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2019] end),0) as [aug2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2019] end),0) as [sep2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2019] end),0) as [oct2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2019] end),0) as [nov2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2019] end),0) as [dec2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2019],0)+ISNULL(b.[Feb 2019],0)+ISNULL(b.[Mar 2019],0)+ISNULL(b.[Apr 2019],0)+ISNULL(b.[May 2019],0)+ISNULL(b.[Jun 2019],0)+ISNULL(b.[Jul 2019],0)+ISNULL(b.[Aug 2019],0)+ISNULL(b.[Sep 2019],0)+ISNULL(b.[Oct 2019],0)+ISNULL(b.[Nov 2019],0)+ISNULL(b.[Dec 2019],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2019]+b.[Feb 2019]+b.[Mar 2019]+b.[Apr 2019]+b.[May 2019]+b.[Jun 2019]+b.[Jul 2019]+b.[Aug 2019]+b.[Sep 2019]+b.[Oct 2019]+b.[Nov 2019]+b.[Dec 2019]) end),0) as [total_2019],
		
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2020] end),0) as [jan2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2020] end),0) as [feb2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2020] end),0) as [mar2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2020] end),0) as [apr2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2020] end),0) as [may2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2020] end),0) as [jun2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2020] end),0) as [jul2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2020] end),0) as [aug2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2020] end),0) as [sep2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2020] end),0) as [oct2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2020] end),0) as [nov2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2020] end),0) as [dec2020], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2020],0)+ISNULL(b.[Feb 2020],0)+ISNULL(b.[Mar 2020],0)+ISNULL(b.[Apr 2020],0)+ISNULL(b.[May 2020],0)+ISNULL(b.[Jun 2020],0)+ISNULL(b.[Jul 2020],0)+ISNULL(b.[Aug 2020],0)+ISNULL(b.[Sep 2020],0)+ISNULL(b.[Oct 2020],0)+ISNULL(b.[Nov 2020],0)+ISNULL(b.[Dec 2020],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2020]+b.[Feb 2020]+b.[Mar 2020]+b.[Apr 2020]+b.[May 2020]+b.[Jun 2020]+b.[Jul 2020]+b.[Aug 2020]+b.[Sep 2020]+b.[Oct 2020]+b.[Nov 2020]+b.[Dec 2020]) end),0) as [total_2020],
	
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2021] end),0) as [jan2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2021] end),0) as [feb2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2021] end),0) as [mar2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2021] end),0) as [apr2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2021] end),0) as [may2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2021] end),0) as [jun2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2021] end),0) as [jul2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2021] end),0) as [aug2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2021] end),0) as [sep2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2021] end),0) as [oct2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2021] end),0) as [nov2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2021] end),0) as [dec2021], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2021],0)+ISNULL(b.[Feb 2021],0)+ISNULL(b.[Mar 2021],0)+ISNULL(b.[Apr 2021],0)+ISNULL(b.[May 2021],0)+ISNULL(b.[Jun 2021],0)+ISNULL(b.[Jul 2021],0)+ISNULL(b.[Aug 2021],0)+ISNULL(b.[Sep 2021],0)+ISNULL(b.[Oct 2021],0)+ISNULL(b.[Nov 2021],0)+ISNULL(b.[Dec 2021],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2021]+b.[Feb 2021]+b.[Mar 2021]+b.[Apr 2021]+b.[May 2021]+b.[Jun 2021]+b.[Jul 2021]+b.[Aug 2021]+b.[Sep 2021]+b.[Oct 2021]+b.[Nov 2021]+b.[Dec 2021]) end),0) as [total_2021],

		/*
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2022] end),0) as [jan2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2022] end),0) as [feb2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2022] end),0) as [mar2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2022] end),0) as [apr2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2022] end),0) as [may2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2022] end),0) as [jun2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2022] end),0) as [jul2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2022] end),0) as [aug2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2022] end),0) as [sep2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2022] end),0) as [oct2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2022] end),0) as [nov2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2022] end),0) as [dec2022], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2022],0)+ISNULL(b.[Feb 2022],0)+ISNULL(b.[Mar 2022],0)+ISNULL(b.[Apr 2022],0)+ISNULL(b.[May 2022],0)+ISNULL(b.[Jun 2022],0)+ISNULL(b.[Jul 2022],0)+ISNULL(b.[Aug 2022],0)+ISNULL(b.[Sep 2022],0)+ISNULL(b.[Oct 2022],0)+ISNULL(b.[Nov 2022],0)+ISNULL(b.[Dec 2022],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2022]+b.[Feb 2022]+b.[Mar 2022]+b.[Apr 2022]+b.[May 2022]+b.[Jun 2022]+b.[Jul 2022]+b.[Aug 2022]+b.[Sep 2022]+b.[Oct 2022]+b.[Nov 2022]+b.[Dec 2022]) end),0) as [total_2022],
		*/
		 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2022] end),0) as [total_2022],
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2023],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2023] end),0) as [total_2023],
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2024],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2024] end),0) as [total_2024],
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2025],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2025] end),0) as [total_2025],
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2026],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2026] end),0) as [total_2026]
from 
		(	select	* 
			from	eeiuser.acctg_csm_base_part_mnemonic
			where	release_id = @release_id
		) a 
		left outer join 
		(	select	* 
			from	eeiuser.acctg_csm_NAIHS 
			where	release_id = @release_id
		) b
		on b.[Mnemonic-Vehicle/Plant] = a.mnemonic 
		and	a.release_id = b.release_id
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
