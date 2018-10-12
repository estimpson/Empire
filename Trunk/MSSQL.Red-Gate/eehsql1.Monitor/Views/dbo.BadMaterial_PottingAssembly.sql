SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[BadMaterial_PottingAssembly] as
select	*
from	EEH..BadMaterial_PottingAssembly with (readuncommitted)
GO
