SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [HN].[Inventario_Used_by_ARS] AS
	select	time_stamp, serial, part, location, last_date, Quantity,operator, status from EEHars.HN.Inventario_Used_by_ARS with (readuncommitted)

GO
