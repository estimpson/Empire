SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VW_UltimaAprobacion_ECN]
AS
SELECT DISTINCT 
                      TOP (100) PERCENT EEH.dbo.ENG_WOEngineer.WOEngineerID, EEH.dbo.ENG_WOEngineer.DocumentID AS Document, EEH.dbo.ENG_WOEngineer.Part, 
                      LEFT(EEH.dbo.ENG_WOEngineer.RevDT, 12) AS EEHKickoffDate, LEFT(EEH.dbo.ENG_WOEngineer.RevDT + 10, 12) AS [Target Date Circulacion], 
                      EEH.dbo.VW_UltimaAutorizacion_ECN.Description AS UltimaAutorizacion, EEH.dbo.ENG_WOAPQP.AnalysisEngineer
FROM         EEH.dbo.ENG_WOEngineer LEFT OUTER JOIN
                      EEH.dbo.ENG_WOAPQP ON EEH.dbo.ENG_WOEngineer.WOEngineerID = EEH.dbo.ENG_WOAPQP.WOEngineerID LEFT OUTER JOIN
                      EEH.dbo.VW_UltimaAutorizacion_ECN ON EEH.dbo.ENG_WOEngineer.WOEngineerID = EEH.dbo.VW_UltimaAutorizacion_ECN.WOEngineerID LEFT OUTER JOIN
                      EEH.dbo.ENG_DateAuthorized ON EEH.dbo.ENG_WOEngineer.WOEngineerID = EEH.dbo.ENG_DateAuthorized.WOEngineerID LEFT OUTER JOIN
                      EEH.dbo.part ON EEH.dbo.ENG_WOEngineer.Part = EEH.dbo.part.part
WHERE     (EEH.dbo.ENG_WOEngineer.WOType = 'E') AND (EEH.dbo.ENG_WOEngineer.Status = 'A') AND (EEH.dbo.ENG_DateAuthorized.Complete = 0) AND 
                      (EEH.dbo.ENG_WOEngineer.TransDT >= CONVERT(DATETIME, '2011-08-18 00:00:00', 102)) AND (RIGHT(LEFT(EEH.dbo.ENG_WOEngineer.Part, 9), 1) <> 'A') AND 
                      (EEH.dbo.ENG_WOEngineer.Liberado = 1) AND (EEH.dbo.part.product_line NOT LIKE '%PCB%')
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
         Begin Table = "ENG_WOEngineer (EEH.dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENG_WOAPQP (EEH.dbo)"
            Begin Extent = 
               Top = 6
               Left = 259
               Bottom = 125
               Right = 501
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VW_UltimaAutorizacion_ECN (EEH.dbo)"
            Begin Extent = 
               Top = 6
               Left = 539
               Bottom = 95
               Right = 699
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENG_DateAuthorized (EEH.dbo)"
            Begin Extent = 
               Top = 96
               Left = 539
               Bottom = 215
               Right = 737
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "part (EEH.dbo)"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 222
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
   ', 'SCHEMA', N'dbo', 'VIEW', N'VW_UltimaAprobacion_ECN', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'   Begin ColumnWidths = 11
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
', 'SCHEMA', N'dbo', 'VIEW', N'VW_UltimaAprobacion_ECN', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'VW_UltimaAprobacion_ECN', NULL, NULL
GO
