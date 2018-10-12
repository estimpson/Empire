SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Issued] as
select	*
from	eeh..issued with (readuncommitted)
GO
