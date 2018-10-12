SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[VW_SPC_CalculoDesviacion] as

select distinct Desviacion = stdev(dato), Resultados.SPCID, Resultados.CharacteristictID, Turno   
					from EEH.HN.SPC_Resultados Resultados inner join EEH.hn.SPC_Characteristic_Details Details on Resultados.CharacteristictID = Details.CharacteristictID
					Where Details.Status =1
					group by Resultados.SPCID, Resultados.CharacteristictID, Turno
GO
