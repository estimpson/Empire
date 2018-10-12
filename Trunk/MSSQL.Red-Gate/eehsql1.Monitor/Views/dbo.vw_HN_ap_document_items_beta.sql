SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_HN_ap_document_items_beta]
AS
Select	Document.*, 
		CheckInformation.check_number,
		CheckAppliedDate = CheckInformation.AppliedDate, 
		CheckGLDate= CheckInformation.gl_date
From (
SELECT        dbo.ap_document_items.buy_vendor, dbo.ap_document_items.ap_document, dbo.ap_document_items.document_type, dbo.ap_document_items.document_line, dbo.ap_document_items.sort_line, 
                         dbo.ap_document_items.line_type, dbo.ap_document_items.purchase_order, dbo.ap_document_items.purchase_order_release, dbo.ap_document_items.purchase_order_document_line, 
                         dbo.ap_document_items.por_purchase_order, dbo.ap_document_items.por_purchase_order_release, dbo.ap_document_items.por_shipping_advice, dbo.ap_document_items.por_document_type, 
                         dbo.ap_document_items.por_document_line, dbo.ap_document_items.quantity, dbo.ap_document_items.quantity_uom, dbo.ap_document_items.unit_cost, dbo.ap_document_items.unit_cost_uom, 
                         dbo.ap_document_items.document_amount, dbo.ap_document_items.posting_account, dbo.ap_document_items.cost_account, dbo.ap_documents.buy_vendor_name, dbo.ap_documents.document_date, 
                         dbo.ap_documents.pay_vendor, dbo.ap_documents.pay_vendor_name, dbo.ap_documents.approved, dbo.ap_documents.received_date, dbo.ap_documents.ledger_amount
FROM            dbo.ap_document_items INNER JOIN
                         dbo.ap_documents ON dbo.ap_document_items.buy_vendor = dbo.ap_documents.buy_vendor AND dbo.ap_document_items.ap_document = dbo.ap_documents.ap_document AND 
                         dbo.ap_document_items.document_type = dbo.ap_documents.document_type) Document
	left join (Select bank_account, check_number, document_type, currency, document_amount, AppliedDate= document_date, gl_date,ledger_amount, pay_vendor
				from [dbo].bank_account_checks) CheckInformation
			on Document.ledger_amount = CheckInformation.ledger_amount
				and Document.buy_vendor = CheckInformation.pay_vendor 


GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[14] 2[28] 3) )"
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
         Begin Table = "ap_document_items"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 295
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ap_documents"
            Begin Extent = 
               Top = 6
               Left = 333
               Bottom = 136
               Right = 561
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
', 'SCHEMA', N'dbo', 'VIEW', N'vw_HN_ap_document_items_beta', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_HN_ap_document_items_beta', NULL, NULL
GO
