SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[PO_Detail_historical] as 
	select * from EEH.dbo.PO_Detail_historical with(readuncommitted)
GO
