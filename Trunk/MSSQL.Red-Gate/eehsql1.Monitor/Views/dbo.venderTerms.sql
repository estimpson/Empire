SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[venderTerms] as
select	*
from	EEH.[dbo].[venderTerms] with (READUNCOMMITTED)
GO
