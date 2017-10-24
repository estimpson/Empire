SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_update_empire_factor2] 
	@base_part varchar(30),
     @version varchar(30),
     @release_id varchar(16),
     @mnemonicVehiclePlant varchar(16),  
	 @suggested_take_rate decimal(15,2),   
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
     
     /*
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
     */
     
     @Total_2020 decimal(16,2), 
     @Total_2021 decimal(15,2),
     @Total_2022 decimal(15,2)  
   
    
as

update eeiuser.acctg_csm_NAIHS

set		

		 [Jan 2015] = ISNULL(@Jan2015,0)
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
		,[CY 2015] = ISNULL(@Total_2015,0) 

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
		,[CY 2016] = ISNULL(@Total_2016 ,0)
		 
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
		,[CY 2017] = ISNULL(@Total_2017 ,0)

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
		,[CY 2018] = ISNULL(@Total_2018 ,0)

		,[Jan 2019] = ISNULL(@Jan2019 ,0) 
		,[Feb 2019] = ISNULL(@Feb2019 ,0) 
		,[Mar 2019] = ISNULL(@Mar2019 ,0)  
		,[Apr 2019] = ISNULL(@Apr2019 ,0) 
		,[May 2019] = ISNULL(@May2019 ,0)  
		,[Jun 2019] = ISNULL(@Jun2019 ,0) 
		,[Jul 2019] = ISNULL(@Jul2019 ,0) 
		,[Aug 2019] = ISNULL(@Aug2019 ,0)  
		,[Sep 2019] = ISNULL(@Sep2019 ,0) 
		,[Oct 2019] = ISNULL(@Oct2019 ,0) 
		,[Nov 2019] = ISNULL(@Nov2019 ,0) 
		,[Dec 2019] = ISNULL(@Dec2019 ,0) 
		,[CY 2019] = ISNULL(@Total_2019 ,0) 
		
		/*
		,[Jan 2020] = ISNULL(@Jan2020 ,0) 
		,[Feb 2020] = ISNULL(@Feb2020 ,0) 
		,[Mar 2020] = ISNULL(@Mar2020 ,0)  
		,[Apr 2020] = ISNULL(@Apr2020 ,0) 
		,[May 2020] = ISNULL(@May2020 ,0)  
		,[Jun 2020] = ISNULL(@Jun2020 ,0) 
		,[Jul 2020] = ISNULL(@Jul2020 ,0) 
		,[Aug 2020] = ISNULL(@Aug2020 ,0)  
		,[Sep 2020] = ISNULL(@Sep2020 ,0) 
		,[Oct 2020] = ISNULL(@Oct2020 ,0) 
		,[Nov 2020] = ISNULL(@Nov2020 ,0) 
		,[Dec 2020] = ISNULL(@Dec2020 ,0) 
		*/
		
		,[CY 2020] = ISNULL(@TOTAL_2020 ,0) 
		,[CY 2021] = ISNULL(@TOTAL_2021 ,0)
		,[CY 2022] = ISNULL(@TOTAL_2022 ,0)
		,[CY 2023] = ISNULL(@TOTAL_2022 ,0)
		,[CY 2024] = ISNULL(@TOTAL_2022 ,0)

where	[mnemonic-vehicle/plant] = @mnemonicvehicleplant 
		and	release_id = @release_id
 
			 






GO
