SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EEIUser].[acctg_csm_sp_select_empire_adjustment2] 
  @base_part varchar(30),
  @release_id varchar(30)
as

--exec [EEIUser].[acctg_csm_sp_select_empire_adjustment] 'ALC0134', '2012-01'

select	@base_part as [base_part],
		b.version as [version],
		b.release_id, 
		b.[Mnemonic-Vehicle/Plant] as [MnemonicVehiclePlant], 
		b.platform, 
		b.program, 
		LTRIM(ISNULL(b.brand,'')+' '+b.[nameplate]) as [vehicle], 
		b.plant, 
		b.[sop], 
		b.[eop],  
		'' as [qty_per],
		'' as [take_rate], 
		'' as [family_allocation],
	    ISNULL(b.[jan 2015],0) as [jan2015], 
		ISNULL(b.[feb 2015],0) as [feb2015], 
		ISNULL(b.[mar 2015],0) as [mar2015], 
		ISNULL(b.[apr 2015],0) as [apr2015], 
		ISNULL(b.[may 2015],0) as [may2015], 
		ISNULL(b.[jun 2015],0) as [jun2015], 
		ISNULL(b.[jul 2015],0) as [jul2015], 
		ISNULL(b.[aug 2015],0) as [aug2015], 
		ISNULL(b.[sep 2015],0) as [sep2015], 
		ISNULL(b.[oct 2015],0) as [oct2015], 
		ISNULL(b.[nov 2015],0) as [nov2015], 
		ISNULL(b.[dec 2015],0) as [dec2015], 
		(ISNULL(b.[jan 2015],0)+ISNULL(b.[feb 2015],0)+ISNULL(b.[mar 2015],0)+ISNULL(b.[apr 2015],0)+ISNULL(b.[may 2015],0)+ISNULL(b.[jun 2015],0)+ISNULL(b.[jul 2015],0)+ISNULL(b.[aug 2015],0)+ISNULL(b.[sep 2015],0)+ISNULL(b.[oct 2015],0)+ISNULL(b.[nov 2015],0)+ISNULL(b.[dec 2015],0)) as [total_2015],

		ISNULL(b.[jan 2016],0) as [jan2016], 
		ISNULL(b.[feb 2016],0) as [feb2016], 
		ISNULL(b.[mar 2016],0) as [mar2016], 
		ISNULL(b.[apr 2016],0) as [apr2016], 
		ISNULL(b.[may 2016],0) as [may2016], 
		ISNULL(b.[jun 2016],0) as [jun2016], 
		ISNULL(b.[jul 2016],0) as [jul2016], 
		ISNULL(b.[aug 2016],0) as [aug2016], 
		ISNULL(b.[sep 2016],0) as [sep2016], 
		ISNULL(b.[oct 2016],0) as [oct2016], 
		ISNULL(b.[nov 2016],0) as [nov2016], 
		ISNULL(b.[dec 2016],0) as [dec2016], 
		(ISNULL(b.[jan 2016],0)+ISNULL(b.[feb 2016],0)+ISNULL(b.[mar 2016],0)+ISNULL(b.[apr 2016],0)+ISNULL(b.[may 2016],0)+ISNULL(b.[jun 2016],0)+ISNULL(b.[jul 2016],0)+ISNULL(b.[aug 2016],0)+ISNULL(b.[sep 2016],0)+ISNULL(b.[oct 2016],0)+ISNULL(b.[nov 2016],0)+ISNULL(b.[dec 2016],0)) as [total_2016],

		ISNULL(b.[jan 2017],0) as [jan2017], 
		ISNULL(b.[feb 2017],0) as [feb2017], 
		ISNULL(b.[mar 2017],0) as [mar2017], 
		ISNULL(b.[apr 2017],0) as [apr2017], 
		ISNULL(b.[may 2017],0) as [may2017], 
		ISNULL(b.[jun 2017],0) as [jun2017], 
		ISNULL(b.[jul 2017],0) as [jul2017], 
		ISNULL(b.[aug 2017],0) as [aug2017], 
		ISNULL(b.[sep 2017],0) as [sep2017], 
		ISNULL(b.[oct 2017],0) as [oct2017], 
		ISNULL(b.[nov 2017],0) as [nov2017], 
		ISNULL(b.[dec 2017],0) as [dec2017], 
		(ISNULL(b.[jan 2017],0)+ISNULL(b.[feb 2017],0)+ISNULL(b.[mar 2017],0)+ISNULL(b.[apr 2017],0)+ISNULL(b.[may 2017],0)+ISNULL(b.[jun 2017],0)+ISNULL(b.[jul 2017],0)+ISNULL(b.[aug 2017],0)+ISNULL(b.[sep 2017],0)+ISNULL(b.[oct 2017],0)+ISNULL(b.[nov 2017],0)+ISNULL(b.[dec 2017],0)) as [total_2017],
 
		ISNULL(b.[jan 2018],0) as [jan2018], 
		ISNULL(b.[feb 2018],0) as [feb2018], 
		ISNULL(b.[mar 2018],0) as [mar2018], 
		ISNULL(b.[apr 2018],0) as [apr2018], 
		ISNULL(b.[may 2018],0) as [may2018], 
		ISNULL(b.[jun 2018],0) as [jun2018], 
		ISNULL(b.[jul 2018],0) as [jul2018], 
		ISNULL(b.[aug 2018],0) as [aug2018], 
		ISNULL(b.[sep 2018],0) as [sep2018], 
		ISNULL(b.[oct 2018],0) as [oct2018], 
		ISNULL(b.[nov 2018],0) as [nov2018], 
		ISNULL(b.[dec 2018],0) as [dec2018], 
		(ISNULL(b.[jan 2018],0)+ISNULL(b.[feb 2018],0)+ISNULL(b.[mar 2018],0)+ISNULL(b.[apr 2018],0)+ISNULL(b.[may 2018],0)+ISNULL(b.[jun 2018],0)+ISNULL(b.[jul 2018],0)+ISNULL(b.[aug 2018],0)+ISNULL(b.[sep 2018],0)+ISNULL(b.[oct 2018],0)+ISNULL(b.[nov 2018],0)+ISNULL(b.[dec 2018],0)) as [total_2018],
 
		ISNULL(b.[jan 2019],0) as [jan2019], 
		ISNULL(b.[feb 2019],0) as [feb2019], 
		ISNULL(b.[mar 2019],0) as [mar2019], 
		ISNULL(b.[apr 2019],0) as [apr2019], 
		ISNULL(b.[may 2019],0) as [may2019], 
		ISNULL(b.[jun 2019],0) as [jun2019], 
		ISNULL(b.[jul 2019],0) as [jul2019], 
		ISNULL(b.[aug 2019],0) as [aug2019], 
		ISNULL(b.[sep 2019],0) as [sep2019], 
		ISNULL(b.[oct 2019],0) as [oct2019], 
		ISNULL(b.[nov 2019],0) as [nov2019], 
		ISNULL(b.[dec 2019],0) as [dec2019], 
		(ISNULL(b.[jan 2019],0)+ISNULL(b.[feb 2019],0)+ISNULL(b.[mar 2019],0)+ISNULL(b.[apr 2019],0)+ISNULL(b.[may 2019],0)+ISNULL(b.[jun 2019],0)+ISNULL(b.[jul 2019],0)+ISNULL(b.[aug 2019],0)+ISNULL(b.[sep 2019],0)+ISNULL(b.[oct 2019],0)+ISNULL(b.[nov 2019],0)+ISNULL(b.[dec 2019],0)) as [total_2019],
 
		/*
		ISNULL(b.[jan 2020],0) as [jan2020], 
		ISNULL(b.[feb 2020],0) as [feb2020], 
		ISNULL(b.[mar 2020],0) as [mar2020], 
		ISNULL(b.[apr 2020],0) as [apr2020], 
		ISNULL(b.[may 2020],0) as [may2020], 
		ISNULL(b.[jun 2020],0) as [jun2020], 
		ISNULL(b.[jul 2020],0) as [jul2020], 
		ISNULL(b.[aug 2020],0) as [aug2020], 
		ISNULL(b.[sep 2020],0) as [sep2020], 
		ISNULL(b.[oct 2020],0) as [oct2020], 
		ISNULL(b.[nov 2020],0) as [nov2020], 
		ISNULL(b.[dec 2020],0) as [dec2020], 
		(ISNULL(b.[jan 2020],0)+ISNULL(b.[feb 2020],0)+ISNULL(b.[mar 2020],0)+ISNULL(b.[apr 2020],0)+ISNULL(b.[may 2020],0)+ISNULL(b.[jun 2020],0)+ISNULL(b.[jul 2020],0)+ISNULL(b.[aug 2020],0)+ISNULL(b.[sep 2020],0)+ISNULL(b.[oct 2020],0)+ISNULL(b.[nov 2020],0)+ISNULL(b.[dec 2020],0)) as [total_2020],
		*/
		
		ISNULL(b.[CY 2020] ,0) as [total_2020],
		ISNULL(b.[CY 2021] ,0) as [total_2021], 
		ISNULL(b.[CY 2022] ,0) as [total_2022]
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
			and b.VERSION = 'Empire Adjustment'
 
	




GO
