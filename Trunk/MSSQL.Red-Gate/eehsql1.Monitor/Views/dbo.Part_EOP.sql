SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[Part_EOP] as 
select	csm.BASE_PART, EOP = Max(csm.eop)
from	csm_NACSM csm
		join csm_base_part_mnemonic mnemonic on mnemonic.MNEMONIC = csm.MNEMONIC
group by csm.BASE_PART

/*
--where	Release_id = eeh.dbo.fn_ReturnLatestCSMRelease('EMPIRE')
Condicion removida el 2018-09-26, Reportado por Rodolfo Henerndez, ya que en la tabla de CSM el campo Release_id dejo de exisir
Realizado por Robert Larios
*/

GO
