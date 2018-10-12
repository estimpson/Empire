SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW  [HN].[BF_Part_In_CycleCount] as
	select * from EEH.HN.BF_Part_In_CycleCount with (readuncommitted)
GO
