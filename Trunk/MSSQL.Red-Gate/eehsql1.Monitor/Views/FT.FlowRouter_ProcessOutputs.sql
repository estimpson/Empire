SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[FlowRouter_ProcessOutputs] as
select	*
from	EEH.[FT].[FlowRouter_ProcessOutputs] with (READUNCOMMITTED)
GO
