SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[OMANegotiatedFabAuthorizations] as
select	*
from	EEH.[FT].[OMANegotiatedFabAuthorizations] with (READUNCOMMITTED)
GO
