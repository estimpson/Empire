SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[BF_Part_ConsumeFromGroups] as
select	*
from	EEH.HN.BF_Part_ConsumeFromGroups with (readuncommitted)
GO
