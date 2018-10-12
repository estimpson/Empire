SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[part_characteristics] as
select	* from EEH.dbo.part_characteristics WITH(Readuncommitted)


GO
