SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [andre].[vw_ars_exception_nonorderstatus] as
select	*
from	EEH.[andre].[vw_ars_exception_nonorderstatus] with (READUNCOMMITTED)
GO
