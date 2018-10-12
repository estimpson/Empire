SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create View [dbo].[TP_Estados_Mantenimiento] as 
Select * from Sistema.dbo.TP_Estados_Mantenimiento with (readuncommitted)
GO
