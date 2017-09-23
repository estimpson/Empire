SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE procedure [EEIUser].[acctg_csm_sp_update_empire_adjustment] 
	@base_part varchar(30),
     @version varchar(30),
     @release_id varchar(16),
     @mnemonicVehiclePlant varchar(16),     
     @platform varchar(30),
     @program varchar(30),
     @vehicle varchar(50),
     @plant varchar(30),
     @sop datetime,
     @eop datetime,   
     @qty_per decimal(15,2), 
     @take_rate decimal(15,2), 
     @family_allocation decimal(15,2),    
  
     @Jan2015 decimal(15,2), 
     @Feb2015 decimal(15,2), 
     @Mar2015 decimal(15,2), 
     @Apr2015 decimal(15,2), 
     @May2015 decimal(15,2), 
     @Jun2015 decimal(15,2), 
     @Jul2015 decimal(15,2), 
     @Aug2015 decimal(15,2), 
     @Sep2015 decimal(15,2), 
     @Oct2015 decimal(15,2), 
     @Nov2015 decimal(15,2), 
     @Dec2015 decimal(15,2),
     @Total_2015 decimal(15,2),
	  
     @Jan2016 decimal(16,2), 
     @Feb2016 decimal(16,2), 
     @Mar2016 decimal(16,2), 
     @Apr2016 decimal(16,2), 
     @May2016 decimal(16,2), 
     @Jun2016 decimal(16,2), 
     @Jul2016 decimal(16,2), 
     @Aug2016 decimal(16,2), 
     @Sep2016 decimal(16,2), 
     @Oct2016 decimal(16,2), 
     @Nov2016 decimal(16,2), 
     @Dec2016 decimal(16,2),
     @Total_2016 decimal(16,2),
	  
     @Jan2017 decimal(16,2), 
     @Feb2017 decimal(16,2), 
     @Mar2017 decimal(16,2), 
     @Apr2017 decimal(16,2), 
     @May2017 decimal(16,2), 
     @Jun2017 decimal(16,2), 
     @Jul2017 decimal(16,2), 
     @Aug2017 decimal(16,2), 
     @Sep2017 decimal(16,2), 
     @Oct2017 decimal(16,2), 
     @Nov2017 decimal(16,2), 
     @Dec2017 decimal(16,2),
     @Total_2017 decimal(16,2),

     @Jan2018 decimal(16,2), 
     @Feb2018 decimal(16,2), 
     @Mar2018 decimal(16,2), 
     @Apr2018 decimal(16,2), 
     @May2018 decimal(16,2), 
     @Jun2018 decimal(16,2), 
     @Jul2018 decimal(16,2), 
     @Aug2018 decimal(16,2), 
     @Sep2018 decimal(16,2), 
     @Oct2018 decimal(16,2), 
     @Nov2018 decimal(16,2), 
     @Dec2018 decimal(16,2),
     @Total_2018 decimal(16,2),

     @Total_2019 decimal(15,2),
     @Total_2020 decimal(15,2) 
   
    
as

update eeiuser.acctg_csm_naihs

set		

		 platform = @platform
		,program = @program
		,Nameplate = @vehicle
		,plant = @plant
		,sop = @sop
		,eop = @eop  
		,[Jan 2015] = ISNULL(@Jan2015,0)
		,[Feb 2015] = ISNULL(@Feb2015,0)
		,[Mar 2015] = ISNULL(@Mar2015,0) 
		,[Apr 2015] = ISNULL(@Apr2015,0) 
		,[May 2015] = ISNULL(@May2015,0)  
		,[Jun 2015] = ISNULL(@Jun2015,0)
		,[Jul 2015] = ISNULL(@Jul2015,0)
		,[Aug 2015] = ISNULL(@Aug2015,0) 
		,[Sep 2015] = ISNULL(@Sep2015,0) 
		,[Oct 2015] = ISNULL(@Oct2015,0)
		,[Nov 2015] = ISNULL(@Nov2015,0) 
		,[Dec 2015] = ISNULL(@Dec2015,0)

		,[Jan 2016] = ISNULL(@Jan2016,0)
		,[Feb 2016] = ISNULL(@Feb2016,0)
		,[Mar 2016] = ISNULL(@Mar2016,0) 
		,[Apr 2016] = ISNULL(@Apr2016,0) 
		,[May 2016] = ISNULL(@May2016,0)  
		,[Jun 2016] = ISNULL(@Jun2016,0)
		,[Jul 2016] = ISNULL(@Jul2016,0)
		,[Aug 2016] = ISNULL(@Aug2016,0) 
		,[Sep 2016] = ISNULL(@Sep2016,0) 
		,[Oct 2016] = ISNULL(@Oct2016,0)
		,[Nov 2016] = ISNULL(@Nov2016,0) 
		,[Dec 2016] = ISNULL(@Dec2016,0)

		,[Jan 2017] = ISNULL(@Jan2017,0)
		,[Feb 2017] = ISNULL(@Feb2017,0)
		,[Mar 2017] = ISNULL(@Mar2017,0) 
		,[Apr 2017] = ISNULL(@Apr2017,0) 
		,[May 2017] = ISNULL(@May2017,0)  
		,[Jun 2017] = ISNULL(@Jun2017,0)
		,[Jul 2017] = ISNULL(@Jul2017,0)
		,[Aug 2017] = ISNULL(@Aug2017,0) 
		,[Sep 2017] = ISNULL(@Sep2017,0) 
		,[Oct 2017] = ISNULL(@Oct2017,0)
		,[Nov 2017] = ISNULL(@Nov2017,0) 
		,[Dec 2017] = ISNULL(@Dec2017,0)

		,[Jan 2018] = ISNULL(@Jan2018,0)
		,[Feb 2018] = ISNULL(@Feb2018,0)
		,[Mar 2018] = ISNULL(@Mar2018,0) 
		,[Apr 2018] = ISNULL(@Apr2018,0) 
		,[May 2018] = ISNULL(@May2018,0)  
		,[Jun 2018] = ISNULL(@Jun2018,0)
		,[Jul 2018] = ISNULL(@Jul2018,0)
		,[Aug 2018] = ISNULL(@Aug2018,0) 
		,[Sep 2018] = ISNULL(@Sep2018,0) 
		,[Oct 2018] = ISNULL(@Oct2018,0)
		,[Nov 2018] = ISNULL(@Nov2018,0) 
		,[Dec 2018] = ISNULL(@Dec2018,0)

		,[Jan 2019] = ISNULL(@Total_2019/12 ,0)
		,[Feb 2019] = ISNULL(@Total_2019/12 ,0)
		,[Mar 2019] = ISNULL(@Total_2019/12 ,0) 
		,[Apr 2019] = ISNULL(@Total_2019/12 ,0)
		,[May 2019] = ISNULL(@Total_2019/12 ,0) 
		,[Jun 2019] = ISNULL(@Total_2019/12 ,0)
		,[Jul 2019] = ISNULL(@Total_2019/12 ,0)
		,[Aug 2019] = ISNULL(@Total_2019/12 ,0)
		,[Sep 2019] = ISNULL(@Total_2019/12 ,0) 
		,[Oct 2019] = ISNULL(@Total_2019/12 ,0)
		,[Nov 2019] = ISNULL(@Total_2019/12 ,0) 
		,[Dec 2019] = ISNULL(@Total_2019/12 ,0)



		,[CY 2019] = ISNULL(@Total_2019 ,0) 
		,[CY 2020] = ISNULL(@Total_2020 ,0) 
		where	[mnemonic-vehicle/plant] = @mnemonicvehicleplant 
				and	release_id = @release_id

update eeiuser.acctg_csm_naihs

set		[CY 2015] = (@jan2015+@feb2015+@mar2015+@apr2015+@may2015+@jun2015+@jul2015+@aug2015+@sep2015+@oct2015+@nov2015+@dec2015),
		[CY 2016] = (@jan2016+@feb2016+@mar2016+@apr2016+@may2016+@jun2016+@jul2016+@aug2016+@sep2016+@oct2016+@nov2016+@dec2016),
		[CY 2017] = (@jan2017+@feb2017+@mar2017+@apr2017+@may2017+@jun2017+@jul2017+@aug2017+@sep2017+@oct2017+@nov2017+@dec2017),
		[CY 2018] = (@jan2018+@feb2018+@mar2018+@apr2018+@may2018+@jun2018+@jul2018+@aug2018+@sep2018+@oct2018+@nov2018+@dec2018),
		[Q1 2015] = (@jan2015+@feb2015+@mar2015),
		[Q2 2015] = (@apr2015+@may2015+@jun2015),
		[Q3 2015] = (@jul2015+@aug2015+@sep2015),
		[Q4 2015] = (@oct2015+@nov2015+@dec2015),	
		[Q1 2016] = (@jan2016+@feb2016+@mar2016),
		[Q2 2016] = (@apr2016+@may2016+@jun2016),
		[Q3 2016] = (@jul2016+@aug2016+@sep2016),
		[Q4 2016] = (@oct2016+@nov2016+@dec2016),
		[Q1 2017] = (@jan2017+@feb2017+@mar2017),
		[Q2 2017] = (@apr2017+@may2017+@jun2017),
		[Q3 2017] = (@jul2017+@aug2017+@sep2017),
		[Q4 2017] = (@oct2017+@nov2017+@dec2017),
		[Q1 2018] = (@jan2018+@feb2018+@mar2018),
		[Q2 2018] = (@apr2018+@may2018+@jun2018),
		[Q3 2018] = (@jul2018+@aug2018+@sep2018),
		[Q4 2018] = (@oct2018+@nov2018+@dec2018),
		[Q1 2019] = (round(@total_2019/4,0)),
		[Q2 2019] = (round(@total_2019/4,0)),
		[Q3 2019] = (round(@total_2019/4,0)),
		[Q4 2019] = (round(@total_2019/4,0)),
		[Q1 2020] = (round(@total_2020/4,0)),
		[Q2 2020] = (round(@total_2020/4,0)),
		[Q3 2020] = (round(@total_2020/4,0)),
		[Q4 2020] = (round(@total_2020/4,0))

where	[mnemonic-vehicle/plant] = @mnemonicvehicleplant
	and release_id = @release_id		 





















GO
