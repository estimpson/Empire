SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_update_csm_demand] 
 ( @base_part varchar(30)
  ,@release_id char(7)
  ,@MnemonicVehiclePlant varchar(30)
  ,@qty_per decimal(10,2)
  ,@take_rate decimal(10,2)
  ,@family_allocation decimal(10,2)
  )
  
as

update	eeiuser.acctg_csm_base_part_mnemonic
set		qty_per = @qty_per,
		take_rate = @take_rate,
		family_allocation = @family_allocation
where	mnemonic = @MnemonicVehiclePlant
	and BASE_PART = @base_part
GO
