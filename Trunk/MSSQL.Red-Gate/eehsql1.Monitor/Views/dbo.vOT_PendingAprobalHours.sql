SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vOT_PendingAprobalHours]
AS
SELECT        OTPG.IdOT AS ID, OTDG.EmpleadoId, RHE.Desplegar, DATENAME(dw, OTPG.FechaOT) AS Dia, OTPG.FechaOT, OTPG.Planta, OTDG.Linea, Programacion.Part AS Linea2, ISNULL(OTPG.Aprobada, 0) AS Aprobada, 
                         OTPG.Tipo, CASE WHEN Tipo = 3 AND OTPG.Planta = 'WIRE HARN-EEH' THEN 'Ingeniero' ELSE 'Gerente' END AS AprobacionPendienteDe, ISNULL(Oficinas.EnteOrgaName, 'N/A') AS Oficina, 
                         OTPG.Planta + ' ' + ISNULL(Oficinas.EnteOrgaName, 'N/A') AS Area, CASE WHEN OTPG.Planta = 'WIRE HARN-EEH' THEN CASE WHEN LEFT(OTDG.Linea, 3) = 'PRE' THEN LEFT(OTDG.Linea, 6) 
                         ELSE LEFT(OTDG.Linea, 3) END ELSE OTPG.Planta END AS Familia, OTPG.Planta + ' ' + CASE WHEN OTPG.Planta = 'WIRE HARN-EEH' THEN CASE WHEN LEFT(OTDG.Linea, 3) = 'PRE' THEN LEFT(OTDG.Linea, 
                         6) ELSE LEFT(OTDG.Linea, 3) END ELSE '' END AS Area2, Programacion.IngProduccion, Programacion.CoordinadorProduccion, 
                         CASE WHEN OTPG.Planta = 'WIRE HARN-EEH' THEN CASE WHEN CoordinadorProduccion IS NULL THEN (CASE WHEN OTDG.Linea LIKE '%-PT' THEN 'Jeane Sibrian' ELSE 'WIRE HARN-EEH' END) 
                         ELSE CoordinadorProduccion + ' / ' + IngProduccion END ELSE Areas.Aprobador END AS Aprobador
FROM            Sistema.dbo.RH_OT_ProduccionGlobal AS OTPG INNER JOIN
                         Sistema.dbo.RH_OT_ProduccionDetalleGlobal AS OTDG ON OTPG.IdOT = OTDG.IdOT INNER JOIN
                         Sistema.dbo.RH_Empleados AS RHE ON OTDG.EmpleadoId = RHE.EmpleadoId INNER JOIN
                             (SELECT        Planta, MAX(Aprobador) AS Aprobador, MAX(Aprobador1) AS Aprobador1
                               FROM            Sistema.dbo.RH_OT_Areas
                               WHERE        (Aprobador IS NOT NULL)
                               GROUP BY Planta) AS Areas ON OTPG.Planta = Areas.Planta LEFT OUTER JOIN
                         ITSmartClock.dbo.Employee AS Emp ON OTDG.EmpleadoId = CONVERT(INT, Emp.EmpIdAlternative) LEFT OUTER JOIN
                         ITSmartClock.dbo.EnterpriseOrganization AS Oficinas ON Emp.EnteOrgaId = Oficinas.EnteOrgaId LEFT OUTER JOIN
                             (SELECT        CASE WHEN LEFT(RPA.Part, 3) = 'PRE' THEN LEFT(REPLACE(RPA.Part, 'PRE-', 'PRE'), 10) ELSE LEFT(RPA.Part, 7) END AS Part, MAX(partes.IngProduccion) AS IngProduccion, 
                                                         MAX(partes.CoordinadorProduccion) AS CoordinadorProduccion
                               FROM            Sistema.dbo.CP_Revisiones_Produccion_Asignacion AS RPA INNER JOIN
                                                         Sistema.dbo.CP_Contenedores AS Contenedores ON RPA.ContenedorID = Contenedores.ContenedorID INNER JOIN
                                                         Sistema.dbo.SA_Partes AS partes ON RPA.Part = partes.Part
                               GROUP BY CASE WHEN LEFT(RPA.Part, 3) = 'PRE' THEN LEFT(REPLACE(RPA.Part, 'PRE-', 'PRE'), 10) ELSE LEFT(RPA.Part, 7) END) AS Programacion ON OTDG.Linea = Programacion.Part
GO
GRANT SELECT ON  [dbo].[vOT_PendingAprobalHours] TO [public]
GO
GRANT VIEW DEFINITION ON  [dbo].[vOT_PendingAprobalHours] TO [public]
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
         Begin Table = "OTPG"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OTDG"
            Begin Extent = 
               Top = 6
               Left = 302
               Bottom = 136
               Right = 499
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RHE"
            Begin Extent = 
               Top = 6
               Left = 537
               Bottom = 136
               Right = 754
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Areas"
            Begin Extent = 
               Top = 6
               Left = 792
               Bottom = 119
               Right = 962
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Emp"
            Begin Extent = 
               Top = 6
               Left = 1000
               Bottom = 136
               Right = 1245
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Oficinas"
            Begin Extent = 
               Top = 6
               Left = 1283
               Bottom = 136
               Right = 1481
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Programacion"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 251
               Right = 255
            End
            DisplayFlags = 280
            ', 'SCHEMA', N'dbo', 'VIEW', N'vOT_PendingAprobalHours', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'TopColumn = 0
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
', 'SCHEMA', N'dbo', 'VIEW', N'vOT_PendingAprobalHours', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vOT_PendingAprobalHours', NULL, NULL
GO
