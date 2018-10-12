SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CP_Contenedores] as
select	*
from	sistema.dbo.CP_Contenedores with (readuncommitted)
GO
