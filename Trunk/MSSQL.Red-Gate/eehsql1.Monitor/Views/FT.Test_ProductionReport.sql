SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[Test_ProductionReport] as
select	*
from	EEH.[FT].[Test_ProductionReport] with (READUNCOMMITTED)
GO
