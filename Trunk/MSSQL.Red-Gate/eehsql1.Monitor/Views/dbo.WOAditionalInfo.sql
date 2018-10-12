SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[WOAditionalInfo] as
select	*
from	EEH.dbo.WOAditionalInfo with (Readuncommitted)
GO
