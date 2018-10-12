SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [FT].[newKitHeader] as
select	*
from	eeh.ft.newKitHeaders
with (readuncommitted)

GO
