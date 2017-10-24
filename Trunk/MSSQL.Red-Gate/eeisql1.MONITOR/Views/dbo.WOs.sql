SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dbo].[WOs]
AS
SELECT	dbo.WODetails.ID, dbo.WODetails.WOID, dbo.WODetails.Part, dbo.WOHeaders.Machine, 
		dbo.WOHeaders.Status, dbo.WOHeaders.Type, dbo.WOShift.ShiftDate, 
		dbo.WOShift.Shift, dbo.WODetails.QtyRequired, dbo.WODetails.QtyCompleted, 
		dbo.WOHeaders.CreateDT, dbo.WOHeaders.Tool, dbo.WODetails.SourceType,
		'' as StdPack, '' as Bin
		--dbo.WODetails.StdPack, dbo.WODetails.BIN
FROM         dbo.WODetails INNER JOIN
                      dbo.WOHeaders ON dbo.WODetails.WOID = dbo.WOHeaders.ID INNER JOIN
                      dbo.WOShift ON dbo.WOShift.WOID = dbo.WODetails.WOID






GO
GRANT SELECT ON  [dbo].[WOs] TO [APPUser]
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
         Begin Table = "WODetails"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 123
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "WOHeaders"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 123
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "WOShift"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 228
               Right = 198
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
', 'SCHEMA', N'dbo', 'VIEW', N'WOs', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'WOs', NULL, NULL
GO
