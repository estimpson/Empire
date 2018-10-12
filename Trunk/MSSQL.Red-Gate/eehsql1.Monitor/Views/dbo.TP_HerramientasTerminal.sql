SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[TP_HerramientasTerminal] as
	select	* from	Sistema.dbo.TP_HerramientasTerminal with(readuncommitted)
GO
