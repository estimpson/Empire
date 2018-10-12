SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Purchasing_NetoutWIPOnHand_byContainer]
as select * from eeh..Purchasing_NetoutWIPOnHand_byContainer with (readuncommitted)
GO
