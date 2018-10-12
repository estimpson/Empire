SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[empire_safety_stock_audit] as
	select * from EEH.dbo.empire_safety_stock_audit with (readuncommitted)
GO
