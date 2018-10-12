SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[v_gl_cost_transactions_ImortExport]
AS
SELECT gl_cost_transactions.posting_account AS ledger_account, gl_cost_transactions.ledger_amount AS amount, gl_cost_transactions.document_remarks, gl_cost_transactions.period, gl_cost_transactions.document_id3, 
                  gl_cost_documents.document_date AS transaction_date, gl_cost_transactions.cost_account AS contract_account_id, gl_cost_transactions.changed_user_id, 1 AS quantity, gl_cost_transactions.document_id1, 
                  gl_cost_transactions.document_id2, gl_cost_transactions.document_reference1, GETDATE() AS gl_entry, gl_cost_transactions.cost_account, gl_cost_transactions.changed_date, 
                  RIGHT(gl_cost_transactions.posting_account, 3) AS CenterCost, gl_cost_transactions.document_type, gl_cost_transactions.fiscal_year, gl_cost_transactions.posting_account, 
                  gl_cost_transactions.update_ledger_balances, gl_cost_transactions.ledger_amount, gl_cost_transactions.approved
FROM     dbo.gl_cost_transactions AS gl_cost_transactions INNER JOIN
                  dbo.gl_cost_documents AS gl_cost_documents ON gl_cost_transactions.document_type = gl_cost_documents.document_type AND gl_cost_transactions.document_id1 = gl_cost_documents.document_id1 AND 
                  gl_cost_transactions.document_id2 = gl_cost_documents.document_id2 AND gl_cost_transactions.document_id3 = gl_cost_documents.document_id3
WHERE  (gl_cost_transactions.fiscal_year >= '2000') AND (LEFT(gl_cost_transactions.posting_account, 4) IN ('5040', '5042', '5043', '5045', '5047', '5048', '5051', '5053', '5054', '5059','4030','4031','4050','4051'))


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
         Begin Table = "gl_cost_transactions"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 325
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "gl_cost_documents"
            Begin Extent = 
               Top = 7
               Left = 373
               Bottom = 170
               Right = 636
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
      Begin ColumnWidths = 17
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
', 'SCHEMA', N'dbo', 'VIEW', N'v_gl_cost_transactions_ImortExport', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'v_gl_cost_transactions_ImortExport', NULL, NULL
GO
