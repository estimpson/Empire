SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[WODMaterialAllocations] as
select	* from EEH.DBO.wodmaterialallocations with (readuncommitted)
GO
