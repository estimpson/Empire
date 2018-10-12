SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[SetupLocation_characteristics] as
select	*
from	EEH.dbo.SetupLocation_characteristics with (readuncommitted)
GO
