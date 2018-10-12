SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[csm_base_part_mnemonic] as
	select	* from	EEH.dbo.csm_base_part_mnemonic with (readuncommitted)
GO
