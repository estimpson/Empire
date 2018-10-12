SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[FlowRouter] as
select	*
from	EEH.[FT].[FlowRouter] with (READUNCOMMITTED)
GO
