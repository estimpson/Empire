SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwMPS] as
select	*
from	EEH.[FT].[vwMPS] with (READUNCOMMITTED)
GO
