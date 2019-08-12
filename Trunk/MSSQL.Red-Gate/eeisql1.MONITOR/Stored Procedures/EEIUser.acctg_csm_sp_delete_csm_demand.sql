SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- exec eeiuser.acctg_csm_sp_update_csm_demand 'DFN0001','2019-03','111600023',1,0,1



CREATE procedure [EEIUser].[acctg_csm_sp_delete_csm_demand] 
 ( @base_part varchar(30)
  ,@release_id char(7)
  ,@MnemonicVehiclePlant varchar(30)
  )
  
as

delete from	eeiuser.acctg_csm_base_part_mnemonic
where	mnemonic = @MnemonicVehiclePlant
	and BASE_PART = @base_part
	and release_id = @release_id

GO
