SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[CP_Revisiones_Produccion] as
	select	* from Sistema.dbo.CP_Revisiones_Produccion with (readuncommitted)
GO
