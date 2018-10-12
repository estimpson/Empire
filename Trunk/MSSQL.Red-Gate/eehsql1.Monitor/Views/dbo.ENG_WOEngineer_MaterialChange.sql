SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
		
create	view [dbo].[ENG_WOEngineer_MaterialChange] as
	select	* from	EEH.dbo.ENG_WOEngineer_MaterialChange with (readuncommitted)
GO
