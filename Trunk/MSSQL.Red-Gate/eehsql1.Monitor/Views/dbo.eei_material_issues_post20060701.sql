SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[eei_material_issues_post20060701] as
select	*
from	EEH.[dbo].[eei_material_issues_post20060701] with (READUNCOMMITTED)
GO
