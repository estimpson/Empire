SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create View [dbo].[TP_Troquel] as 
Select * from Sistema.dbo.TP_Troquel with (readuncommitted)
GO
