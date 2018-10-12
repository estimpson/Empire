SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[FlowRouter_ProcessInputs] as 
select	* 
from	EEH.FT.FlowRouter_ProcessInputs
with (readuncommitted)
GO
