SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [HN].[SA_Partes_ElPaso] as
select	*
from	EEH.HN.SA_Partes_ElPaso with (readuncommitted)
GO
