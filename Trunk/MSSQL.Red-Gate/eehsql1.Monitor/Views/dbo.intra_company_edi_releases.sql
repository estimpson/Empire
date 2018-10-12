SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[intra_company_edi_releases] as
select	*
from	EEH.[dbo].[intra_company_edi_releases] with (READUNCOMMITTED)
GO
