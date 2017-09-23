SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE procedure [EEIUser].[acctg_csm_sp_update_selling_prices] 
     @base_part varchar(50),      
	 @release_id varchar(16),
	 @description varchar(500),
     @jan2015 decimal(10,4), 
     @feb2015 decimal(10,4), 
     @mar2015 decimal(10,4), 
     @apr2015 decimal(10,4), 
     @may2015 decimal(10,4), 
     @jun2015 decimal(10,4), 
     @jul2015 decimal(10,4), 
     @aug2015 decimal(10,4), 
     @sep2015 decimal(10,4), 
     @oct2015 decimal(10,4), 
     @nov2015 decimal(10,4), 
     @dec2015 decimal(10,4),
     @Total_2015 decimal(10,4),

     @jan2016 decimal(10,4), 
     @feb2016 decimal(10,4), 
     @mar2016 decimal(10,4), 
     @apr2016 decimal(10,4), 
     @may2016 decimal(10,4), 
     @jun2016 decimal(10,4), 
     @jul2016 decimal(10,4), 
     @aug2016 decimal(10,4), 
     @sep2016 decimal(10,4), 
     @oct2016 decimal(10,4), 
     @nov2016 decimal(10,4), 
     @dec2016 decimal(10,4),
     @Total_2016 decimal(10,4),

	 @jan2017 decimal(10,4), 
     @feb2017 decimal(10,4), 
     @mar2017 decimal(10,4), 
     @apr2017 decimal(10,4), 
     @may2017 decimal(10,4), 
     @jun2017 decimal(10,4), 
     @jul2017 decimal(10,4), 
     @aug2017 decimal(10,4), 
     @sep2017 decimal(10,4), 
     @oct2017 decimal(10,4), 
     @nov2017 decimal(10,4), 
     @dec2017 decimal(10,4),
     @Total_2017 decimal(10,4),

	 @jan2018 decimal(10,4), 
     @feb2018 decimal(10,4), 
     @mar2018 decimal(10,4), 
     @apr2018 decimal(10,4), 
     @may2018 decimal(10,4), 
     @jun2018 decimal(10,4), 
     @jul2018 decimal(10,4), 
     @aug2018 decimal(10,4), 
     @sep2018 decimal(10,4), 
     @oct2018 decimal(10,4), 
     @nov2018 decimal(10,4), 
     @dec2018 decimal(10,4),
     @Total_2018 decimal(10,4),

     @Total_2019 decimal(10,4),
     @Total_2020 decimal(10,4)
as
update	eeiuser.acctg_csm_selling_prices_tabular

set		jan_15 = @jan2015, 
		feb_15 = @feb2015, 
		mar_15 = @mar2015, 
		apr_15 = @apr2015, 
		may_15 = @may2015, 
		jun_15 = @jun2015, 
		jul_15 = @jul2015, 
		aug_15 = @aug2015, 
		sep_15 = @sep2015, 
		oct_15 = @oct2015, 
		nov_15 = @nov2015, 
		dec_15 = @dec2015,

		jan_16 = @jan2016, 
		feb_16 = @feb2016, 
		mar_16 = @mar2016, 
		apr_16 = @apr2016, 
		may_16 = @may2016, 
		jun_16 = @jun2016, 
		jul_16 = @jul2016, 
		aug_16 = @aug2016, 
		sep_16 = @sep2016, 
		oct_16 = @oct2016, 
		nov_16 = @nov2016, 
		dec_16 = @dec2016,

		jan_17 = @jan2017, 
		feb_17 = @feb2017, 
		mar_17 = @mar2017, 
		apr_17 = @apr2017, 
		may_17 = @may2017, 
		jun_17 = @jun2017, 
		jul_17 = @jul2017, 
		aug_17 = @aug2017, 
		sep_17 = @sep2017, 
		oct_17 = @oct2017, 
		nov_17 = @nov2017, 
		dec_17 = @dec2017,

		jan_18 = @jan2018, 
		feb_18 = @feb2018, 
		mar_18 = @mar2018, 
		apr_18 = @apr2018, 
		may_18 = @may2018, 
		jun_18 = @jun2018, 
		jul_18 = @jul2018, 
		aug_18 = @aug2018, 
		sep_18 = @sep2018, 
		oct_18 = @oct2018, 
		nov_18 = @nov2018, 
		dec_18 = @dec2018,

		DEC_19 = @Total_2019,
		DEC_20 = @Total_2020

where	release_id = @release_id
		and base_part = @base_part
		and row_id = 1







GO
