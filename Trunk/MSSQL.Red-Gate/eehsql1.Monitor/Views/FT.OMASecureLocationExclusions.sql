SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[OMASecureLocationExclusions] as
select	*
from	EEH.[FT].[OMASecureLocationExclusions] with (READUNCOMMITTED)
GO
