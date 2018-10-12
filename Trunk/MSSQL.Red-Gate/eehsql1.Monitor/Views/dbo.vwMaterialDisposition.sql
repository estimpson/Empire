SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vwMaterialDisposition]
as
select	*
from	EEH.dbo.vwMaterialDisposition with (readuncommitted)
GO
