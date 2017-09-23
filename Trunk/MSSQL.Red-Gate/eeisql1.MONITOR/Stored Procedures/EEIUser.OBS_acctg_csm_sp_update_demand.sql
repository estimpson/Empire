SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[OBS_acctg_csm_sp_update_demand] 
     @release_id varchar(15),
	 @base_part varchar(30), 
     @mnemonic varchar(50),     
     @qty_per decimal(10,0), 
     @take_rate decimal(10,6), 
     @family_allocation decimal(10,6), 
     @version varchar(30),
     @jan_08 decimal(10,2), 
     @feb_08 decimal(10,2), 
     @mar_08 decimal(10,2), 
     @apr_08 decimal(10,2), 
     @may_08 decimal(10,2), 
     @jun_08 decimal(10,2), 
     @jul_08 decimal(10,2), 
     @aug_08 decimal(10,2), 
     @sep_08 decimal(10,2), 
     @oct_08 decimal(10,2), 
     @nov_08 decimal(10,2), 
     @dec_08 decimal(10,2),
     @Total_2008 decimal(10,2),     
	 @jan_09 decimal(10,2), 
     @feb_09 decimal(10,2), 
     @mar_09 decimal(10,2), 
     @apr_09 decimal(10,2), 
     @may_09 decimal(10,2), 
     @jun_09 decimal(10,2), 
     @jul_09 decimal(10,2), 
     @aug_09 decimal(10,2), 
     @sep_09 decimal(10,2), 
     @oct_09 decimal(10,2), 
     @nov_09 decimal(10,2), 
     @dec_09 decimal(10,2),
     @Total_2009 decimal(10,2),
     @platform varchar(30),
     @program varchar(30),
     @vehicle varchar(30),
     @assembly_plant varchar(30),
     @sop varchar(10),
     @eop varchar(10)
as

update	eeiuser.acctg_csm_base_part_mnemonic 

set		qty_per = @qty_per, 
		take_rate = @take_rate, 
		family_allocation = @family_allocation 

where	base_part = @base_part 
		and mnemonic = @mnemonic 


if		@version = 'Empire'
		begin
			update	eeiuser.acctg_csm_NACSM 
			set		jan_08 = @jan_08, 
					feb_08 = @feb_08, 
					mar_08 = @mar_08, 
					apr_08 = @apr_08, 
					may_08 = @may_08, 
					jun_08 = @jun_08, 
					jul_08 = @jul_08, 
					aug_08 = @aug_08, 
					sep_08 = @sep_08, 
					oct_08 = @oct_08, 
					nov_08 = @nov_08, 
					dec_08 = @dec_08,
					jan_09 = @jan_09, 
					feb_09 = @feb_09, 
					mar_09 = @mar_09, 
					apr_09 = @apr_09, 
					may_09 = @may_09, 
					jun_09 = @jun_09, 
					jul_09 = @jul_09, 
					aug_09 = @aug_09, 
					sep_09 = @sep_09, 
					oct_09 = @oct_09, 
					nov_09 = @nov_09, 
					dec_09 = @dec_09
			where 	mnemonic = @mnemonic
					and version = 'Empire'
					and release_id = @release_id
		end
GO
