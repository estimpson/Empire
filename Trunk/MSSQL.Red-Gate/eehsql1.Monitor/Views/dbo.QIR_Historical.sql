SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[QIR_Historical] as

SELECT        TOP (100) PERCENT QIR_Historical_1.QIRID, QIR_Historical_1.Serie, auditTrail.part, QIR_Historical_1.RegisterDate, QIR_Historical_1.ReportDate, QIR_Historical_1.Contact, QIR_Historical_1.Email, 
                         QIR_Historical_1.Responsibility, QIR_Historical_1.[8D] AS column1, QIR_Historical_1.CleanDate, 
                         CASE QIR_Historical_1.Status WHEN 'O' THEN 'OPEN' WHEN 'C' THEN 'CLOSED' WHEN 'D' THEN 'CANCELED' END AS Expr1, QIR_Historical_1.Comments, QIR_Historical_1.Defect, QIR_Historical_1.Provider, 
                         QIR_Historical_1.Image1, QIR_Historical_1.Image2, QIR_Historical_1.Image3, dbo.po_header.vendor_code, QIR_Historical_1.Status, QIR_Historical_1.IngresadoPor, QIR_Historical_1.UserRegister, Severity = QIR_Historical_1.QIRSeverity
FROM            EEH.dbo.QIR_Historical AS QIR_Historical_1 INNER JOIN
                             (SELECT DISTINCT part, serial, po_number
                               FROM            dbo.audit_trail) AS auditTrail ON auditTrail.serial = QIR_Historical_1.Serie INNER JOIN
                         dbo.po_header ON auditTrail.po_number = dbo.po_header.po_number
ORDER BY QIR_Historical_1.QIRID

GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[51] 4[4] 2[4] 3) )"
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
         Begin Table = "QIR_Historical_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 265
               Right = 219
            End
            DisplayFlags = 280
            TopColumn = 21
         End
         Begin Table = "auditTrail"
            Begin Extent = 
               Top = 6
               Left = 257
               Bottom = 110
               Right = 417
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "po_header"
            Begin Extent = 
               Top = 6
               Left = 455
               Bottom = 125
               Right = 664
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
      Begin ColumnWidths = 29
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
         Append', 'SCHEMA', N'dbo', 'VIEW', N'QIR_Historical', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N' = 1400
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
', 'SCHEMA', N'dbo', 'VIEW', N'QIR_Historical', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'QIR_Historical', NULL, NULL
GO
