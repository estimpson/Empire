SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[OBS_acctg_csm_sp_update_material_cost2018] 
     @base_part varchar(50),     
	 @release_id varchar(15),
     @partusedforcost varchar(50),

	 @jan2017 decimal(10,6), 
     @feb2017 decimal(10,6), 
     @mar2017 decimal(10,6), 
     @apr2017 decimal(10,6), 
     @may2017 decimal(10,6), 
     @jun2017 decimal(10,6), 
     @jul2017 decimal(10,6), 
     @aug2017 decimal(10,6), 
     @sep2017 decimal(10,6), 
     @oct2017 decimal(10,6), 
     @nov2017 decimal(10,6), 
     @dec2017 decimal(10,6),
	 @total_2017 decimal(10,6),

	 @jan2018 decimal(10,6), 
     @feb2018 decimal(10,6), 
     @mar2018 decimal(10,6), 
     @apr2018 decimal(10,6), 
     @may2018 decimal(10,6), 
     @jun2018 decimal(10,6), 
     @jul2018 decimal(10,6), 
     @aug2018 decimal(10,6), 
     @sep2018 decimal(10,6), 
     @oct2018 decimal(10,6), 
     @nov2018 decimal(10,6), 
     @dec2018 decimal(10,6),
	 @total_2018 decimal(10,6),
	 
	 @jan2019 decimal(10,6), 
     @feb2019 decimal(10,6), 
     @mar2019 decimal(10,6), 
     @apr2019 decimal(10,6), 
     @may2019 decimal(10,6), 
     @jun2019 decimal(10,6), 
     @jul2019 decimal(10,6), 
     @aug2019 decimal(10,6), 
     @sep2019 decimal(10,6), 
     @oct2019 decimal(10,6), 
     @nov2019 decimal(10,6), 
     @dec2019 decimal(10,6),
	 @total_2019 decimal(10,6),
	 
	 @jan2020 decimal(10,6), 
     @feb2020 decimal(10,6), 
     @mar2020 decimal(10,6), 
     @apr2020 decimal(10,6), 
     @may2020 decimal(10,6), 
     @jun2020 decimal(10,6), 
     @jul2020 decimal(10,6), 
     @aug2020 decimal(10,6), 
     @sep2020 decimal(10,6), 
     @oct2020 decimal(10,6), 
     @nov2020 decimal(10,6), 
     @dec2020 decimal(10,6),
	 @total_2020 decimal(10,6),
	 @total_2021 decimal(10,6),
	 @total_2022 decimal(10,6),
	 @total_2023 decimal(10,6),
	 @total_2024 decimal(10,6),
	 @total_2025 decimal(10,6)

as
update	eeiuser.acctg_csm_material_cost_tabular

set		partusedforcost = @partusedforcost,

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

		jan_19 = @jan2019, 
		feb_19 = @feb2019, 
		mar_19 = @mar2019, 
		apr_19 = @apr2019, 
		may_19 = @may2019, 
		jun_19 = @jun2019, 
		jul_19 = @jul2019, 
		aug_19 = @aug2019, 
		sep_19 = @sep2019, 
		oct_19 = @oct2019, 
		nov_19 = @nov2019, 
		dec_19 = @dec2019,

		jan_20 = @jan2020, 
		feb_20 = @feb2020, 
		mar_20 = @mar2020, 
		apr_20 = @apr2020, 
		may_20 = @may2020, 
		jun_20 = @jun2020, 
		jul_20 = @jul2020, 
		aug_20 = @aug2020, 
		sep_20 = @sep2020, 
		oct_20 = @oct2020, 
		nov_20 = @nov2020, 
		dec_20 = @dec2020

where	base_part = @base_part
		and release_id = @release_id
		and row_id = 1
GO
