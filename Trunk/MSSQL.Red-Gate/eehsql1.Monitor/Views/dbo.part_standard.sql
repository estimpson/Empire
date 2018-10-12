SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
		
CREATE view [dbo].[part_standard] as
select	* from EEH.dbo.part_standard with (Readuncommitted)
GO
