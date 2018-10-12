SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_requisitions_dieroom]
AS
SELECT DISTINCT 
                  ReqHeader.requisition, ReqHeader.requester, ReqHeader.document_date, POs.PO, ReqHeader.document_comments, ReqItems.item, ReqItems.item_description, ReqItems.quantity, ReqItems.unit_cost, 
                  ReqHeader.document_amount, ReqItems.buy_vendor, ReqHeader.document_amount AS Ammount, POs.entered_datetime AS PoClosedDT, DATEDIFF(d, ReqHeader.document_date, POs.entered_datetime) AS DiffDias, 
                  ReqItems.posting_account, dbo.items.commodity, gl_cost.cost_account
FROM     dbo.requisitions AS ReqHeader INNER JOIN
                  dbo.requisition_items AS ReqItems ON ReqHeader.requisition = ReqItems.requisition LEFT OUTER JOIN
                      (SELECT requisition, MAX(purchase_order) AS PO, MAX(document_date) AS entered_datetime
                       FROM      dbo.purchase_orders
                       GROUP BY requisition) AS POs ON POs.requisition = ReqHeader.requisition left JOIN
                  dbo.items ON dbo.items.item = ReqItems.item LEFT OUTER JOIN
                      (SELECT DISTINCT cost_account, document_id1
                       FROM      dbo.gl_cost_transactions
                       WHERE   (document_type = 'PO')) AS gl_cost ON gl_cost.document_id1 = ReqItems.document_id1
WHERE  (ReqHeader.document_date >= '01/01/2016')



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
         Begin Table = "ReqHeader"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 167
               Right = 323
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ReqItems"
            Begin Extent = 
               Top = 7
               Left = 371
               Bottom = 167
               Right = 718
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "items"
            Begin Extent = 
               Top = 7
               Left = 1026
               Bottom = 167
               Right = 1401
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "POs"
            Begin Extent = 
               Top = 7
               Left = 766
               Bottom = 145
               Right = 978
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "gl_cost"
            Begin Extent = 
               Top = 7
               Left = 1449
               Bottom = 123
               Right = 1643
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
      Begin ColumnWidths = 11
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Co', 'SCHEMA', N'dbo', 'VIEW', N'vw_requisitions_dieroom', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'lumn = 1440
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
', 'SCHEMA', N'dbo', 'VIEW', N'vw_requisitions_dieroom', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_requisitions_dieroom', NULL, NULL
GO
