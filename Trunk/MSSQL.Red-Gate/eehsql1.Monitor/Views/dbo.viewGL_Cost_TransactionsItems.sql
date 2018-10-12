SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[viewGL_Cost_TransactionsItems]
AS
SELECT        gl_cost_transactions.posting_account AS ledger_account, gl_cost_transactions.ledger_amount AS amount, gl_cost_transactions.document_reference1, gl_cost_transactions.document_reference2, 
                         gl_cost_transactions.document_remarks, gl_cost_transactions.period, gl_cost_transactions.document_id3, gl_cost_documents.document_date AS transaction_date, 
                         gl_cost_transactions.cost_account AS contract_account_id, gl_cost_transactions.changed_user_id, 1 AS quantity, gl_cost_transactions.document_id1, gl_cost_transactions.document_id2, GETDATE() AS gl_entry, 
                         gl_cost_transactions.cost_account, gl_cost_transactions.changed_date, RIGHT(gl_cost_transactions.posting_account, 3) AS CenterCost, gl_cost_documents.gl_date, gl_cost_documents.journal_entry, 
                         gl_cost_transactions.document_type, gl_cost_transactions.posting_account, gl_cost_transactions.update_ledger_balances, ItemTransactions.dr_posting_account,
                             (SELECT        MAX(account_description) AS Expr1
                               FROM            dbo.chart_of_account_items AS coa
                               WHERE        (LEFT(ItemTransactions.dr_posting_account, LEN(account)) = account) AND (gl_cost_transactions.fiscal_year = fiscal_year) AND (coa = 'EEI MASTER')) AS dr_posting_account_name
							   , gl_cost_transactions.Fiscal_Year
FROM            EEH_Empower.dbo.gl_cost_transactions AS gl_cost_transactions INNER JOIN
                         EEH_Empower.dbo.gl_cost_documents AS gl_cost_documents ON gl_cost_transactions.document_type = gl_cost_documents.document_type AND gl_cost_transactions.document_id1 = gl_cost_documents.document_id1 AND 
                         gl_cost_transactions.document_id2 = gl_cost_documents.document_id2 AND gl_cost_transactions.document_id3 = gl_cost_documents.document_id3 LEFT OUTER JOIN
                         EEH_Empower.dbo.vw_item_transactions AS ItemTransactions ON gl_cost_transactions.document_type = ItemTransactions.document_type AND gl_cost_transactions.document_id1 = ItemTransactions.document_id1 AND 
                         gl_cost_transactions.document_id2 = ItemTransactions.document_id2 AND gl_cost_transactions.document_id3 = ItemTransactions.document_id3 AND 
                         gl_cost_documents.journal_entry = ItemTransactions.journal_entry
WHERE        (gl_cost_transactions.fiscal_year >= '2000') AND (gl_cost_transactions.update_ledger_balances = '1')


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
               Top = 6
               Left = 38
               Bottom = 136
               Right = 274
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "gl_cost_documents"
            Begin Extent = 
               Top = 6
               Left = 312
               Bottom = 136
               Right = 536
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ItemTransactions"
            Begin Extent = 
               Top = 6
               Left = 574
               Bottom = 136
               Right = 780
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
         Width = 1500
         Width = 1500
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
', 'SCHEMA', N'dbo', 'VIEW', N'viewGL_Cost_TransactionsItems', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'viewGL_Cost_TransactionsItems', NULL, NULL
GO
