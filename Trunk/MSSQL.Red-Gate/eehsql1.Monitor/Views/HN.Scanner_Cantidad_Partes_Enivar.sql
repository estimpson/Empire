SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[Scanner_Cantidad_Partes_Enivar] as
select	*
from	EEH.[HN].[Scanner_Cantidad_Partes_Enivar] with (READUNCOMMITTED)
GO
