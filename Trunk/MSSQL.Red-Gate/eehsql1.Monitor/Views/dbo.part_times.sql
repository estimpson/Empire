SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [dbo].[part_times] as
--select	* from Sistema.dbo.SA_Partes with (readuncommitted)

select	[Part] ,[Estado],[CostoID],[Cliente]
      ,[CapacidadDiaria100],[CapacidadDiaria]
      ,[SupervisorProduccion],[Planta],[SupervisorCalidad],[IngProduccion]
      ,[IngCalidad],[IngControlProduccion],[EstatusCalidad]
      ,[Nave],[TiempoEstandarProd],[TiempoEstandar]
      ,[LCS_NP],[LCI_NP],[Media_NP],[PartesEspeciales]
      ,[StandardPack],[TipoCaja],[CrossReferencia] ,[TiempoCorrido]
      ,[TiempoCiclo1],[TiempoCiclo2] ,[Desperdicio1],[Desperdicio2]
      ,[Variacion1],[Variacion2],[Horas26]
      ,[Grupo1] ,[Grupo2] ,[MetaTiempoEstandar] ,[TipoVolumen]
      ,[TiempoEnsambleCotizado],[TiempoProcesosCotizado]
      ,[TiempoPottingCotizado],[TiempoCorteCotizado],[TiempoMoldeoCotizado]
      ,[TiempoProcesoManualCotizado],[TiempoTroqueladoManualCotizado]
      ,[TiempoAcordadoContencionA],[TiempoAcordadoContencionB] ,[AuditorCalidad],[NombreCorto]
      ,[IngAPQP],[IngProducto],[CoordinadorProduccion]
      ,[CoordinadorCalidad],[DesperdicioASSY]
      ,[TiempoASSY],[TiempoKomax],[TiempoSplice]
      ,[TiempoTM],[DiaArranque],[Materialista]
      ,[IngMoldeoTA]  ,[IngMoldeoTB],[Cavidades],[Molde]
      ,[TiempoCicloMoldeo],[MoldeadoraProduccion]
      ,[Capacidad_Hora_Instalada],[Branson]
      ,[LineasComunizadas],[TiempoCuelloDeBotella],[MaquinaOperacion]
from Sistema.dbo.SA_Partes with (readuncommitted)

GO
