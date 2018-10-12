SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CP_FG_Order] as
	select	* from sistema.dbo.CP_FG_Order with(readuncommitted)
GO
