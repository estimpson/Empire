SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vendoerTerms] as
select	*
from	EEH.[dbo].[vendoerTerms] with (READUNCOMMITTED)
GO
