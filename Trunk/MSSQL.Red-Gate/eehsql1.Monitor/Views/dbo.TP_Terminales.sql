SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[TP_Terminales] as
	select	* from	Sistema.dbo.TP_Terminales with(readuncommitted)
GO
