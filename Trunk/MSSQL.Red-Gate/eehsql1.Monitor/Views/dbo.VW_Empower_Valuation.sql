SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[VW_Empower_Valuation] as
SELECT        item_transactions.item, '''' + item_transactions.item AS ItemFormat, item_transactions.location, item_transactions.serial_number, dbo.locations.location_description, dbo.items.item_description, 
                         dbo.items.commodity, dbo.items.inactive, dbo.items.inventory_uom, dbo.item_locations.location_section, SUM(item_transactions.amount * item_transactions.multiplier) AS item_serial_amount, 
                         sum(item_transactions.quantity * item_transactions.multiplier) as item_serial_quantity, on_hand_quantity , dbo.gl_cost_documents.gl_date
FROM            dbo.item_transactions AS item_transactions INNER JOIN
						 dbo.gl_cost_documents ON item_transactions.document_type = dbo.gl_cost_documents.document_type AND item_transactions.document_id1 = dbo.gl_cost_documents.document_id1 AND 
                         item_transactions.document_id2 = dbo.gl_cost_documents.document_id2 AND item_transactions.document_id3 = dbo.gl_cost_documents.document_id3 INNER JOIN
                         dbo.locations ON item_transactions.location = dbo.locations.location INNER JOIN
                         dbo.items ON item_transactions.item = dbo.items.item INNER JOIN
						 	monitor.dbo.vr_item_balances vr_item on vr_item.item = dbo.items.item inner join
                         dbo.item_locations ON item_transactions.item = dbo.item_locations.item AND item_transactions.location = dbo.item_locations.location INNER JOIN
                         dbo.units ON item_transactions.unit = dbo.units.unit
GROUP BY item_transactions.item, item_transactions.location, item_transactions.serial_number, dbo.items.item_description, dbo.items.commodity, dbo.items.inactive, dbo.items.inventory_uom, 
                         dbo.locations.location_description, dbo.item_locations.location_section, on_hand_quantity, dbo.gl_cost_documents.gl_date
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[2] 2[39] 3) )"
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
         Begin Table = "item_transactions"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "gl_cost_documents"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 278
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "locations"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "items"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 367
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "item_locations"
            Begin Extent = 
               Top = 534
               Left = 38
               Bottom = 664
               Right = 347
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "units"
            Begin Extent = 
               Top = 666
               Left = 38
               Bottom = 796
               Right = 231
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
      Begin ColumnWidths = 12
         Column ', 'SCHEMA', N'dbo', 'VIEW', N'VW_Empower_Valuation', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'= 1440
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
', 'SCHEMA', N'dbo', 'VIEW', N'VW_Empower_Valuation', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'VW_Empower_Valuation', NULL, NULL
GO
