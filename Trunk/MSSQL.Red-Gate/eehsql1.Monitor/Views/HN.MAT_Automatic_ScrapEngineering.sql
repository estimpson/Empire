SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create view [HN].[MAT_Automatic_ScrapEngineering] as
	select	* from	eeh.HN.MAT_Automatic_ScrapEngineering with (readuncommitted)
GO
