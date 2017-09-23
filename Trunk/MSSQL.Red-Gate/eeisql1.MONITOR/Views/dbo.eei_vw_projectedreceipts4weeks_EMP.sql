SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*SELECT		'MON' as POtype,
					po_detail.vendor_code,
					po_header.terms,
					(CASE WHEN po_header.terms like '%30%' then 30 when po_header.terms like '%45%' then 45 when po_header.terms like '%COD%' then 0 WHEN po_header.terms like '%15%' then 15 WHEN po_header.terms like '%1' then 1 else 30 end) as netdays,
					po_detail.part_number,
					po_detail.date_due as ActualDueDate,
					dateadd(dd, (datepart(dw, (case when po_detail.date_due< getdate() and po_detail.date_due> dateadd(wk,-2,getdate())  THEN getdate()  WHEN po_detail.date_due<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate()) ELSE po_detail.date_due end))-2)*(-1), (case when po_detail.date_due< getdate() and po_detail.date_due> dateadd(wk,-2,getdate())  THEN getdate()  WHEN po_detail.date_due<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate()) ELSE po_detail.date_due end)) as POMondayDuedate,
					(CASE WHEN po_header.terms like '%30%' then 30 when po_header.terms like '%45%' then 45 when po_header.terms like '%COD%' then 0 WHEN po_header.terms like '%15%' then 15 WHEN po_header.terms like '%1' then 1 else 30 end)/7 as dueweeks,
					dateadd(wk,(CASE WHEN po_header.terms like '%30%' then 30 when po_header.terms like '%45%' then 45 when po_header.terms like '%COD%' then 0 WHEN po_header.terms like '%15%' then 15 WHEN po_header.terms like '%1' then 1 else 30 end)/7, dateadd(dd, (datepart(dw, (case when po_detail.date_due< getdate() and po_detail.date_due> dateadd(wk,-2,getdate())  THEN getdate()  WHEN po_detail.date_due<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate()) ELSE po_detail.date_due end))-2)*(-1), (case when po_detail.date_due< getdate() and po_detail.date_due> dateadd(wk,-2,getdate())  THEN getdate()  WHEN po_detail.date_due<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate()) ELSE po_detail.date_due end))) as InvoiceMondayDuedate,
					po_detail.balance,
					po_detail.balance*alternate_price as extended,
					ceiling(isNULL((select max(FABAuthDays) from part_vendor where vendor=po_header.vendor_code and part = po_detail.part_number),28)/7) as FirmWeeks
					
					
					
				
					
FROM			po_detail
INNER JOIN	po_header ON po_detail.po_number = po_header.po_number
WHERE			po_detail.balance>0 and
					po_detail.vendor_code <> 'EEI'


UNION*/
CREATE VIEW [dbo].[eei_vw_projectedreceipts4weeks_EMP]
AS
SELECT     'EMP' AS POtype, dbo.po_headers.buy_vendor, dbo.po_headers.terms, 
                      (CASE WHEN po_headers.terms LIKE '%10%' THEN 10 WHEN po_headers.terms LIKE '%25%' THEN 25 WHEN po_headers.terms LIKE '%60%' THEN 60
                       WHEN po_headers.terms LIKE '%30%' THEN 30 WHEN po_headers.terms LIKE '%45%' THEN 45 WHEN po_headers.terms LIKE '%COD%' THEN 0 WHEN
                       po_headers.terms LIKE '%15%' THEN 15 WHEN po_headers.terms LIKE '%1' THEN 1 ELSE 30 END) AS netdays, dbo.po_items.item, 
                      dbo.po_items.required_date AS ActualDueDate, DATEADD(dd, (DATEPART(dw, (CASE WHEN po_items.required_date < getdate() AND 
                      po_items.required_date > dateadd(wk, - 2, getdate()) THEN getdate() WHEN po_items.required_date <= dateadd(wk, - 2, getdate()) THEN dateadd(wk, - 2, 
                      getdate()) ELSE po_items.required_date END)) - 2) * - 1, (CASE WHEN po_items.required_date < getdate() AND po_items.required_date > dateadd(wk, 
                      - 2, getdate()) THEN getdate() WHEN po_items.required_date <= dateadd(wk, - 2, getdate()) THEN dateadd(wk, - 2, getdate()) 
                      ELSE po_items.required_date END)) AS POMondayDuedate, 
                      (CASE WHEN po_headers.terms LIKE '%10%' THEN 10 WHEN po_headers.terms LIKE '%25%' THEN 25 WHEN po_headers.terms LIKE '%60%' THEN 60
                       WHEN po_headers.terms LIKE '%30%' THEN 30 WHEN po_headers.terms LIKE '%45%' THEN 45 WHEN po_headers.terms LIKE '%COD%' THEN 0 WHEN
                       po_headers.terms LIKE '%15%' THEN 15 WHEN po_headers.terms LIKE '%1' THEN 1 ELSE 30 END) / 7 AS dueweeks, DATEADD(wk, 
                      (CASE WHEN po_headers.terms LIKE '%10%' THEN 10 WHEN po_headers.terms LIKE '%25%' THEN 25 WHEN po_headers.terms LIKE '%60%' THEN 60
                       WHEN po_headers.terms LIKE '%30%' THEN 30 WHEN po_headers.terms LIKE '%45%' THEN 45 WHEN po_headers.terms LIKE '%COD%' THEN 0 WHEN
                       po_headers.terms LIKE '%15%' THEN 15 WHEN po_headers.terms LIKE '%1' THEN 1 ELSE 30 END) / 7, DATEADD(dd, (DATEPART(dw, 
                      (CASE WHEN po_items.required_date < getdate() AND po_items.required_date > dateadd(wk, - 2, getdate()) THEN getdate() 
                      WHEN po_items.required_date <= dateadd(wk, - 2, getdate()) THEN dateadd(wk, - 2, getdate()) ELSE po_items.required_date END)) - 2) * - 1, 
                      (CASE WHEN po_items.required_date < getdate() AND po_items.required_date > dateadd(wk, - 2, getdate()) THEN getdate() 
                      WHEN po_items.required_date <= dateadd(wk, - 2, getdate()) THEN dateadd(wk, - 2, getdate()) ELSE po_items.required_date END))) 
                      AS InvoiceMondayDuedate, dbo.po_items.quantity_ordered - dbo.po_items.quantity_cancelled - dbo.po_items.quantity_received AS balance, 
                      (CASE WHEN po_headers.pay_unit = '12L' THEN (((quantity_ordered - quantity_cancelled) - quantity_received) * price) / isNULL
                          ((SELECT     MAX(exchange_rate)
                              FROM         exchange_rates
                              WHERE     effective_off_date > getdate() AND effective_on_date <= getdate() AND effective_on_date > '2006-01-01'), 19) 
                      ELSE ((quantity_ordered - quantity_cancelled) - quantity_received) * price END) AS extended, 4 AS FirmWeeks, 
                      dbo.po_headers.purchase_order AS PONumber, dbo.po_headers.pay_unit, (CASE WHEN po_headers.pay_unit = '12L' THEN
                          (SELECT     MAX(exchange_rate)
                            FROM          exchange_rates
                            WHERE      effective_off_date > getdate() AND effective_on_date <= getdate() AND effective_on_date > '2006-01-01') ELSE 1 END) AS exchange_rate, 
                      dbo.po_items.ledger_account_code
FROM         dbo.po_items INNER JOIN
                      dbo.po_headers ON dbo.po_items.purchase_order = dbo.po_headers.purchase_order
WHERE     (dbo.po_headers.po_type = 'EMPOWER') AND (ISNULL(dbo.po_items.quantity_ordered, 0) - ISNULL(dbo.po_items.quantity_cancelled, 0) 
                      - ISNULL(dbo.po_items.quantity_received, 0) > 0) AND (dbo.po_headers.fiscal_year > 2005) AND (ISNULL(dbo.po_items.status, 'X') <> 'C') AND 
                      (dbo.po_items.item <> 'ORDER CHANGE') AND (dbo.po_items.required_date IS NOT NULL) AND (dbo.po_items.required_date > DATEADD(mm, - 1, 
                      GETDATE()))
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
         Configuration = "(H (1[50] 2[25] 3) )"
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
         Configuration = "(H (1 [56] 4 [18] 2))"
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
         Begin Table = "po_items"
            Begin Extent = 
               Top = 3
               Left = 404
               Bottom = 118
               Right = 641
            End
            DisplayFlags = 280
            TopColumn = 13
         End
         Begin Table = "po_headers"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 220
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
      RowHeights = 220
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 8805
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
', 'SCHEMA', N'dbo', 'VIEW', N'eei_vw_projectedreceipts4weeks_EMP', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'eei_vw_projectedreceipts4weeks_EMP', NULL, NULL
GO
