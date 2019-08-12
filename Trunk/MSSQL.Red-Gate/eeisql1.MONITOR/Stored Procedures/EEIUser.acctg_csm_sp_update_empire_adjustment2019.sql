SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_update_empire_adjustment2019] 
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
     
     @Jan2019 decimal(16,2), 
     @Feb2019 decimal(16,2), 
     @Mar2019 decimal(16,2), 
     @Apr2019 decimal(16,2), 
     @May2019 decimal(16,2), 
     @Jun2019 decimal(16,2), 
     @Jul2019 decimal(16,2), 
     @Aug2019 decimal(16,2), 
     @Sep2019 decimal(16,2), 
     @Oct2019 decimal(16,2), 
     @Nov2019 decimal(16,2), 
     @Dec2019 decimal(16,2),
     @Total_2019 decimal(16,2),
     
     @Jan2020 decimal(16,2), 
     @Feb2020 decimal(16,2), 
     @Mar2020 decimal(16,2), 
     @Apr2020 decimal(16,2), 
     @May2020 decimal(16,2), 
     @Jun2020 decimal(16,2), 
     @Jul2020 decimal(16,2), 
     @Aug2020 decimal(16,2), 
     @Sep2020 decimal(16,2), 
     @Oct2020 decimal(16,2), 
     @Nov2020 decimal(16,2), 
     @Dec2020 decimal(16,2),
	 @Total_2020 decimal(16,2),

     @Jan2021 decimal(16,2), 
     @Feb2021 decimal(16,2), 
     @Mar2021 decimal(16,2), 
     @Apr2021 decimal(16,2), 
     @May2021 decimal(16,2), 
     @Jun2021 decimal(16,2), 
     @Jul2021 decimal(16,2), 
     @Aug2021 decimal(16,2), 
     @Sep2021 decimal(16,2), 
     @Oct2021 decimal(16,2), 
     @Nov2021 decimal(16,2), 
     @Dec2021 decimal(16,2),
	 @Total_2021 decimal(16,2),

	 /*
     @Jan2022 decimal(16,2), 
     @Feb2022 decimal(16,2), 
     @Mar2022 decimal(16,2), 
     @Apr2022 decimal(16,2), 
     @May2022 decimal(16,2), 
     @Jun2022 decimal(16,2), 
     @Jul2022 decimal(16,2), 
     @Aug2022 decimal(16,2), 
     @Sep2022 decimal(16,2), 
     @Oct2022 decimal(16,2), 
     @Nov2022 decimal(16,2), 
     @Dec2022 decimal(16,2),
	 @Total_2022 decimal(16,2),
     */
     
     @Total_2022 decimal(15,2),
	 @Total_2023 decimal(15,2),
	 @Total_2024 decimal(15,2),
	 @Total_2025 decimal(15,2),
	 @Total_2026 decimal(15,2)
    
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

		/*
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
		*/

		,[Jan 2019] = ISNULL(@Jan2019,0)
		,[Feb 2019] = ISNULL(@Feb2019,0)
		,[Mar 2019] = ISNULL(@Mar2019,0) 
		,[Apr 2019] = ISNULL(@Apr2019,0) 
		,[May 2019] = ISNULL(@May2019,0)  
		,[Jun 2019] = ISNULL(@Jun2019,0)
		,[Jul 2019] = ISNULL(@Jul2019,0)
		,[Aug 2019] = ISNULL(@Aug2019,0) 
		,[Sep 2019] = ISNULL(@Sep2019,0) 
		,[Oct 2019] = ISNULL(@Oct2019,0)
		,[Nov 2019] = ISNULL(@Nov2019,0) 
		,[Dec 2019] = ISNULL(@Dec2019,0)

		,[Jan 2020] = ISNULL(@Jan2020,0)
		,[Feb 2020] = ISNULL(@Feb2020,0)
		,[Mar 2020] = ISNULL(@Mar2020,0) 
		,[Apr 2020] = ISNULL(@Apr2020,0) 
		,[May 2020] = ISNULL(@May2020,0)  
		,[Jun 2020] = ISNULL(@Jun2020,0)
		,[Jul 2020] = ISNULL(@Jul2020,0)
		,[Aug 2020] = ISNULL(@Aug2020,0) 
		,[Sep 2020] = ISNULL(@Sep2020,0) 
		,[Oct 2020] = ISNULL(@Oct2020,0)
		,[Nov 2020] = ISNULL(@Nov2020,0) 
		,[Dec 2020] = ISNULL(@Dec2020,0)

		,[Jan 2021] = ISNULL(@Jan2021,0)
		,[Feb 2021] = ISNULL(@Feb2021,0)
		,[Mar 2021] = ISNULL(@Mar2021,0) 
		,[Apr 2021] = ISNULL(@Apr2021,0) 
		,[May 2021] = ISNULL(@May2021,0)  
		,[Jun 2021] = ISNULL(@Jun2021,0)
		,[Jul 2021] = ISNULL(@Jul2021,0)
		,[Aug 2021] = ISNULL(@Aug2021,0) 
		,[Sep 2021] = ISNULL(@Sep2021,0) 
		,[Oct 2021] = ISNULL(@Oct2021,0)
		,[Nov 2021] = ISNULL(@Nov2021,0) 
		,[Dec 2021] = ISNULL(@Dec2021,0)

		/*
		,[Jan 2022] = ISNULL(@Jan2022,0)
		,[Feb 2022] = ISNULL(@Feb2022,0)
		,[Mar 2022] = ISNULL(@Mar2022,0) 
		,[Apr 2022] = ISNULL(@Apr2022,0) 
		,[May 2022] = ISNULL(@May2022,0)  
		,[Jun 2022] = ISNULL(@Jun2022,0)
		,[Jul 2022] = ISNULL(@Jul2022,0)
		,[Aug 2022] = ISNULL(@Aug2022,0) 
		,[Sep 2022] = ISNULL(@Sep2022,0) 
		,[Oct 2022] = ISNULL(@Oct2022,0)
		,[Nov 2022] = ISNULL(@Nov2022,0) 
		,[Dec 2022] = ISNULL(@Dec2022,0)
		*/

		,[CY 2022] = ISNULL(@Total_2022 ,0) 
		,[CY 2023] = ISNULL(@Total_2023 ,0) 
		,[CY 2024] = ISNULL(@Total_2024 ,0) 
		,[CY 2025] = ISNULL(@Total_2025 ,0) 
		,[CY 2026] = ISNULL(@Total_2026 ,0) 

		where	[mnemonic-vehicle/plant] = @mnemonicvehicleplant 
				and	release_id = @release_id

update eeiuser.acctg_csm_naihs

set		[CY 2015] = (@jan2015+@feb2015+@mar2015+@apr2015+@may2015+@jun2015+@jul2015+@aug2015+@sep2015+@oct2015+@nov2015+@dec2015),
		[CY 2016] = (@jan2016+@feb2016+@mar2016+@apr2016+@may2016+@jun2016+@jul2016+@aug2016+@sep2016+@oct2016+@nov2016+@dec2016),
		[CY 2017] = (@jan2017+@feb2017+@mar2017+@apr2017+@may2017+@jun2017+@jul2017+@aug2017+@sep2017+@oct2017+@nov2017+@dec2017),
		[CY 2018] = (@jan2018+@feb2018+@mar2018+@apr2018+@may2018+@jun2018+@jul2018+@aug2018+@sep2018+@oct2018+@nov2018+@dec2018),
		[CY 2019] = (@jan2019+@feb2019+@mar2019+@apr2019+@may2019+@jun2019+@jul2019+@aug2019+@sep2019+@oct2019+@nov2019+@dec2019),
		[CY 2020] = (@jan2020+@feb2020+@mar2020+@apr2020+@may2020+@jun2020+@jul2020+@aug2020+@sep2020+@oct2020+@nov2020+@dec2020),
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
		[Q1 2019] = (@jan2019+@feb2019+@mar2019),
		[Q2 2019] = (@apr2019+@may2019+@jun2019),
		[Q3 2019] = (@jul2019+@aug2019+@sep2019),
		[Q4 2019] = (@oct2019+@nov2019+@dec2019),
		[Q1 2020] = (@jan2020+@feb2020+@mar2020),
		[Q2 2020] = (@apr2020+@may2020+@jun2020),
		[Q3 2020] = (@jul2020+@aug2020+@sep2020),
		[Q4 2020] = (@oct2020+@nov2020+@dec2020),
		[Q1 2021] = (@jan2021+@feb2021+@mar2021),
		[Q2 2021] = (@apr2021+@may2021+@jun2021),
		[Q3 2021] = (@jul2021+@aug2021+@sep2021),
		[Q4 2021] = (@oct2021+@nov2021+@dec2021),
		--[Q1 2022] = (@jan2022+@feb2022+@mar2022),
		--[Q2 2022] = (@apr2022+@may2022+@jun2022),
		--[Q3 2022] = (@jul2022+@aug2022+@sep2022),
		--[Q4 2022] = (@oct2022+@nov2022+@dec2022),
		[Q1 2022] = (round(@total_2022/4,0)),
		[Q2 2022] = (round(@total_2022/4,0)),
		[Q3 2022] = (round(@total_2022/4,0)),
		[Q4 2022] = (round(@total_2022/4,0)),
		[Q1 2023] = (round(@total_2023/4,0)),
		[Q2 2023] = (round(@total_2023/4,0)),
		[Q3 2023] = (round(@total_2023/4,0)),
		[Q4 2023] = (round(@total_2023/4,0)),
		[Q1 2024] = (round(@total_2024/4,0)),
		[Q2 2024] = (round(@total_2024/4,0)),
		[Q3 2024] = (round(@total_2024/4,0)),
		[Q4 2024] = (round(@total_2024/4,0)),
		[Q1 2025] = (round(@total_2025/4,0)),
		[Q2 2025] = (round(@total_2025/4,0)),
		[Q3 2025] = (round(@total_2025/4,0)),
		[Q4 2025] = (round(@total_2025/4,0)),
		[Q1 2026] = (round(@total_2026/4,0)),
		[Q2 2026] = (round(@total_2026/4,0)),
		[Q3 2026] = (round(@total_2026/4,0)),
		[Q4 2026] = (round(@total_2026/4,0))

where	[mnemonic-vehicle/plant] = @mnemonicvehicleplant
	and release_id = @release_id		 





















GO
