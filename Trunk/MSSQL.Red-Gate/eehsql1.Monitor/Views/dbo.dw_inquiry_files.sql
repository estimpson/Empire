SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dw_inquiry_files] as
select	*
from	EEH.[dbo].[dw_inquiry_files] with (READUNCOMMITTED)
GO
