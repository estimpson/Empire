SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[KB_Fifo_Partes_No_Usuar_BOM] as
select	*
from	EEH.[dbo].[KB_Fifo_Partes_No_Usuar_BOM] with (READUNCOMMITTED)
GO
