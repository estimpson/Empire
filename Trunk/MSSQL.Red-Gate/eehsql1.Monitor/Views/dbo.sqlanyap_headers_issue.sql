SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sqlanyap_headers_issue] as
select	*
from	EEH.[dbo].[sqlanyap_headers_issue] with (READUNCOMMITTED)
GO
