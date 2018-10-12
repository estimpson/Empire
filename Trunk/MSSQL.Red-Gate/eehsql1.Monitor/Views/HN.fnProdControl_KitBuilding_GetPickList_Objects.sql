SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [HN].[fnProdControl_KitBuilding_GetPickList_Objects]
AS
SELECT     TOP (100) PERCENT Shorts.Materialist, Shorts.Component AS Part, Shorts.Color, Shorts.QtyShort, dbo.object.serial, dbo.object.location, dbo.object.std_quantity, 
                      Shorts.Machine
FROM         EEH.HN.fn_ProdControl_KITBuilding_GetPicklist_byWareHouse(NULL) AS Shorts INNER JOIN
                      dbo.object WITH (readuncommitted) ON Shorts.Component = dbo.object.part AND dbo.object.status = 'A'
WHERE     (dbo.object.location IN
                          (SELECT     code
                            FROM          dbo.location
                            WHERE      (group_no IN ('corte-komax', 'Corte-Sonica-Kits', 'Corte-Troqmanual-Kits', 'Bodega - Corte', 'BODEGA-SPL')))) AND (Shorts.QtyShort > 0) AND 
                      EXISTS
                          (SELECT     1 AS Expr1
                            FROM          dbo.object AS obj WITH (readuncommitted) INNER JOIN
                                                   dbo.location AS location_1 ON obj.location = location_1.code
                            WHERE      (location_1.group_no IN ('corte-komax', 'Corte-Sonica-Kits', 'Corte-Troqmanual-Kits', 'Bodega - Corte', 'BODEGA-SPL')) AND (obj.part = Object.part) AND 
                                                   (obj.serial <= Object.Serial) AND (obj.status = 'A')
                            HAVING      (SUM(obj.std_quantity) <= Shorts.QtyShort + Object.std_quantity))
ORDER BY Part
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[27] 4[15] 2[41] 3) )"
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
         Begin Table = "Shorts"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 198
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "object"
            Begin Extent = 
               Top = 30
               Left = 560
               Bottom = 149
               Right = 767
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
      Begin ColumnWidths = 11
         Column = 2025
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
', 'SCHEMA', N'HN', 'VIEW', N'fnProdControl_KitBuilding_GetPickList_Objects', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'HN', 'VIEW', N'fnProdControl_KitBuilding_GetPickList_Objects', NULL, NULL
GO
