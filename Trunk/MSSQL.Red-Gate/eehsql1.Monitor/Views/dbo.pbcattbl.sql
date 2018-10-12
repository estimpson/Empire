SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[pbcattbl] as
select	*
from	EEH.[dbo].[pbcattbl] with (READUNCOMMITTED)
GO
