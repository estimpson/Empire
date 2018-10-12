SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[NetMPS_Comp] as
select	*
from	EEH.[FT].[NetMPS_Comp] with (READUNCOMMITTED)
GO
