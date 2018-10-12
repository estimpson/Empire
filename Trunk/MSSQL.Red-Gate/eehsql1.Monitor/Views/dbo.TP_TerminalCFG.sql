SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[TP_TerminalCFG] as
	select	* from	Sistema.dbo.TP_TerminalCFG with(readuncommitted)
GO
