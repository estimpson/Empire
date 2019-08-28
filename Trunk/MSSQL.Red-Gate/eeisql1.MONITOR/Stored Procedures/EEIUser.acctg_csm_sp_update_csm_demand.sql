SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- exec eeiuser.acctg_csm_sp_update_csm_demand 'STE0512','2019-03','113130433',1,.35,1



CREATE procedure [EEIUser].[acctg_csm_sp_update_csm_demand] 
 ( 
   @base_part varchar(30)
  ,@version varchar(20)
  ,@release_id char(7)
  ,@mnemonicvehicleplant varchar(30)
  ,@platform varchar(255)
  ,@program varchar(255)
  ,@vehicle varchar(255)
  ,@plant varchar(255)
  ,@sop date
  ,@eop date
  ,@qty_per decimal(10,0)
  ,@take_rate decimal(10,2)
  ,@family_allocation decimal(10,2)
  
  ,@jan2018 decimal(10,2)
  ,@feb2018 decimal(10,2)
  ,@mar2018 decimal(10,2)
  ,@apr2018 decimal(10,2)
  ,@may2018 decimal(10,2)
  ,@jun2018 decimal(10,2)
  ,@jul2018 decimal(10,2)
  ,@aug2018 decimal(10,2)
  ,@sep2018 decimal(10,2)
  ,@oct2018 decimal(10,2)
  ,@nov2018 decimal(10,2)
  ,@dec2018 decimal(10,2)
  ,@total_2018 decimal(10,2)
  
  ,@jan2019 decimal(10,2)
  ,@feb2019 decimal(10,2)
  ,@mar2019 decimal(10,2)
  ,@apr2019 decimal(10,2)
  ,@may2019 decimal(10,2)
  ,@jun2019 decimal(10,2)
  ,@jul2019 decimal(10,2)
  ,@aug2019 decimal(10,2)
  ,@sep2019 decimal(10,2)
  ,@oct2019 decimal(10,2)
  ,@nov2019 decimal(10,2)
  ,@dec2019 decimal(10,2)
  ,@total_2019 decimal(10,2)
  
  ,@jan2020 decimal(10,2)
  ,@feb2020 decimal(10,2)
  ,@mar2020 decimal(10,2)
  ,@apr2020 decimal(10,2)
  ,@may2020 decimal(10,2)
  ,@jun2020 decimal(10,2)
  ,@jul2020 decimal(10,2)
  ,@aug2020 decimal(10,2)
  ,@sep2020 decimal(10,2)
  ,@oct2020 decimal(10,2)
  ,@nov2020 decimal(10,2)
  ,@dec2020 decimal(10,2)
  ,@total_2020 decimal(10,2)

  ,@jan2021 decimal(10,2)
  ,@feb2021 decimal(10,2)
  ,@mar2021 decimal(10,2)
  ,@apr2021 decimal(10,2)
  ,@may2021 decimal(10,2)
  ,@jun2021 decimal(10,2)
  ,@jul2021 decimal(10,2)
  ,@aug2021 decimal(10,2)
  ,@sep2021 decimal(10,2)
  ,@oct2021 decimal(10,2)
  ,@nov2021 decimal(10,2)
  ,@dec2021 decimal(10,2)
  ,@total_2021 decimal(10,2)
   
  ,@total_2022 decimal(10,2)
  ,@total_2023 decimal(10,2)
  ,@total_2024 decimal(10,2)
  ,@total_2025 decimal(10,2)
  ,@total_2026 decimal(10,2)
  
  )
  
as

update	eeiuser.acctg_csm_base_part_mnemonic
set		qty_per = @qty_per,
		take_rate = @take_rate,
		family_allocation = @family_allocation
where	BASE_PART = @base_part
	and	release_id = @release_id
	and	mnemonic = @MnemonicVehiclePlant

GO
