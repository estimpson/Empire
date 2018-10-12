SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create	view [dbo].[WODToolingAllocations] as
	select	* from	EEH.dbo.WODToolingAllocations with (readuncommitted)
GO
