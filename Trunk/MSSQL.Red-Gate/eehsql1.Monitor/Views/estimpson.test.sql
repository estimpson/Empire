SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [estimpson].[test] as
select	*
from	EEH.[estimpson].[test] with (READUNCOMMITTED)
GO
