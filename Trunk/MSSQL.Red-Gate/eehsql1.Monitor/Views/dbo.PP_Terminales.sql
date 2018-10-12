SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[PP_Terminales] as
	select * from sistema.dbo.PP_Terminales with (readuncommitted)
GO
