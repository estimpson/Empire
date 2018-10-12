SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[SA_BillMaterialData] as  
select *  
from EEH.HN.SA_BillMaterialData with (READUNCOMMITTED)
GO
