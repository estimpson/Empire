SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE procedure [EEIUser].[acctg_csm_sp_insert_new_base_part_mnemonic] 
@release_id varchar(25),
@mnemonic varchar(25),
@base_part varchar(25),
@qty_per decimal(10,0),
@Family_allocation decimal(10,6),
@take_rate decimal(10,6)


as 

-- 1. Insert CSM Mnemonic Row

INSERT INTO eeiuser.acctg_csm_base_part_mnemonic

        ( RELEASE_ID,
		  FORECAST_ID ,
          MNEMONIC ,
          BASE_PART ,
          QTY_PER ,
          TAKE_RATE ,
          FAMILY_ALLOCATION 
        )
VALUES  ( @release_id,
          'C' , -- FORECAST_ID - varchar(15)
          @mnemonic , -- MNEMONIC - varchar(50)
          @base_part , -- BASE_PART - varchar(30)
          @qty_per, -- QTY_PER - decimal
          @take_rate , -- TAKE_RATE - decimal
          @family_allocation -- FAMILY_ALLOCATION - decimal
        )



GO
