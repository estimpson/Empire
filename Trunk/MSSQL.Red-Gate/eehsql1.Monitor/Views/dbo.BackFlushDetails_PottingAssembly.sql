SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[BackFlushDetails_PottingAssembly] as
select	*
from	EEH..BackFlushDetails_PottingAssembly with (readuncommitted)
GO
