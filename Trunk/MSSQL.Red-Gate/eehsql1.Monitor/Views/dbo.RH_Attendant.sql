SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_Attendant]
AS
SELECT        employee.EmpIdAlternative, RHEmpleados.Desplegar AS Nombre, Puestos.Nombre_Puesto, ITSmartClock.dbo.EnterpriseOrganization.EnteOrgaName, Attendance.ScHiPeriodType, 
                         Attendance.ScHiPeriodDate AS Fecha, Attendance.ScHiPeriodDate AS Hours, employee.EmplCentCostId AS CentroCostoID, PartTimes.NombreLargo AS CentroCosto, PartTimes.IngProduccion AS Supervisor, 
                         ScheduleHistoryPeriodOutNotMark.ScHiPeriodOutNMarkReason AS MarcajeAutomatico, employee.EmplCentCostId AS CentroSMartClock
FROM            ITSmartClock.dbo.ScheduleHistoryPeriod AS Attendance INNER JOIN
                         ITSmartClock.dbo.Employee AS employee ON Attendance.PersonId = employee.PersonId LEFT OUTER JOIN
                         ITSmartClock.dbo.EnterpriseOrganization ON ITSmartClock.dbo.EnterpriseOrganization.EnteOrgaId = employee.EnteOrgaId INNER JOIN
                         Sistema.dbo.RH_Empleados AS RHEmpleados ON CONVERT(int, RHEmpleados.EmpleadoId) = CONVERT(int, employee.EmpIdAlternative) INNER JOIN
                         Sistema.dbo.RH_Puestos AS Puestos ON Puestos.PuestoID = RHEmpleados.PuestoID LEFT OUTER JOIN
                         ITSmartClock.dbo.ScheduleHistoryPeriodOutNotMark AS ScheduleHistoryPeriodOutNotMark WITH (readuncommitted) ON 
                         ScheduleHistoryPeriodOutNotMark.SchiPeriodId = Attendance.SchiPeriodId LEFT OUTER JOIN
                             (SELECT        NombreCorto, CASE WHEN PartesEspeciales = 1 THEN Part ELSE NombreCorto END AS NombreLargo, MAX(SupervisorProduccion) AS IngProduccion
                               FROM            EEH.dbo.part_times
                               GROUP BY NombreCorto, CASE WHEN PartesEspeciales = 1 THEN Part ELSE NombreCorto END) AS PartTimes ON PartTimes.NombreCorto = employee.EmplCentCostId

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
         Begin Table = "Attendance"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 274
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "employee"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 283
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EnterpriseOrganization (ITSmartClock.dbo)"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RHEmpleados"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Puestos"
            Begin Extent = 
               Top = 270
               Left = 274
               Bottom = 400
               Right = 454
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ScheduleHistoryPeriodOutNotMark"
            Begin Extent = 
               Top = 534
               Left = 38
               Bottom = 664
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PartTimes"
            Begin Extent = 
               Top = 6
               Left = 312
               Bottom = 119
          ', 'SCHEMA', N'dbo', 'VIEW', N'RH_Attendant', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'     Right = 482
            End
            DisplayFlags = 280
            TopColumn = 0
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
', 'SCHEMA', N'dbo', 'VIEW', N'RH_Attendant', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'RH_Attendant', NULL, NULL
GO
