SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[KB_Revisiones_Produccion] as
select	*
from	EEH.[dbo].[KB_Revisiones_Produccion] with (READUNCOMMITTED)
GO
