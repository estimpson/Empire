SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[sa_partes]
AS
SELECT        Part, Estado, CostoID, Cliente, CapacidadDiaria100, CapacidadDiaria, SupervisorProduccion, SupervisorCalidad, Planta, IngProduccion, IngCalidad, IngControlProduccion, EstatusCalidad, Nave, TiempoEstandarProd, 
                         TiempoEstandar, LCS_NP, LCI_NP, Media_NP, PartesEspeciales, StandardPack, TipoCaja, CrossReferencia, TiempoCorrido, TiempoCiclo1, TiempoCiclo2, Desperdicio1, Desperdicio2, Variacion1, Variacion2, Horas26, Grupo1, 
                         Grupo2, MetaTiempoEstandar, TipoVolumen, TiempoEnsambleCotizado, TiempoProcesosCotizado, TiempoPottingCotizado, TiempoCorteCotizado, TiempoMoldeoCotizado, TiempoProcesoManualCotizado, 
                         TiempoTroqueladoManualCotizado, TiempoAcordadoContencionA, TiempoAcordadoContencionB, AuditorCalidad, NombreCorto, IngAPQP, IngProducto, CoordinadorProduccion, CoordinadorCalidad, DesperdicioASSY, 
                         TiempoASSY, TiempoKomax, TiempoSplice, TiempoTM, DiaArranque, Materialista, IngMoldeoTA, IngMoldeoTB, Cavidades, Molde, TiempoCicloMoldeo, MoldeadoraProduccion, Capacidad_Hora_Instalada, Branson, 
                         LineasComunizadas, TiempoCuelloDeBotella, MaquinaOperacion, TipoParte, Rate, Meta_Hora, HoraCierreTurno, HoraInicio1, HoraFinal1, HoraInicio2, HoraFinal2, HoraInicio3, HoraFinal3, HoraInicio4, HoraFinal4, 
                         PEValidacionSecuencial, PEMaximaAcumulacion, TotalPEEstaciones, PETiempoValidacionMinutos, PEHInicioValidacion, PEEstacionAcumulacion1, PEEstacionAcumulacion2, PEEstacionAcumulacion3, PEEstacionAcumulacion4, 
                         PEEstacionAcumulacion5, PrimeraPiezaRetrazada, PrimeraPiezaRetrazadaMinutos, PrimeraPiezaRetrazadaComentarios, PEEstacionAcumulacion6, PEEstacionAcumulacion7, PEEstacionAcumulacion8, 
                         PEEstacionAcumulacion9, PEEstacionAcumulacion10, RequiredIdLabel, RequiredPrefix, IDLabelInfo, TiempoCuelloDeBotellaRouter, MaquinaCuelloBotellaRTR, TiempoCuelloDeBotellaASM, MaquinaCuelloDeBotellaASM, 
                         IsPremium, Programa, AplicaTiempoLabelPE, QualityComponents, LineaFavorita, UpdateBy, UpdateDT, GerentePlanta
FROM            Sistema.dbo.SA_Partes
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SA_Partes_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 316
            End
            DisplayFlags = 280
            TopColumn = 109
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'sa_partes', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'sa_partes', NULL, NULL
GO
