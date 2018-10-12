SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
		
CREATE view [dbo].[part_standard_historical_daily] as
select	* from EEH.dbo.part_standard_historical_daily with (Readuncommitted)
GO
