SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VW_MAT_HTSCodeShipperDetail]
AS
SELECT EEH.dbo.shipper_detail.shipper, EEH.dbo.shipper_detail.date_shipped, YEAR(EEH.dbo.shipper_detail.date_shipped) AS Year, CONVERT(int, DATEPART(ISO_WEEK, EEH.dbo.shipper_detail.date_shipped)) AS Week, 
                  CONVERT(int, DATEPART(MONTH, EEH.dbo.shipper_detail.date_shipped)) AS Month, EEH.dbo.shipper_detail.part, EEH.dbo.part.HTSCodeUSCustoms, CodeUS.HTSDescription AS HTSUSDescription, 
                  EEH.dbo.part.HTSCodeHNCustoms, CodeHN.HTSDescription AS HTHNSDescription, EEH.dbo.part.CAFTAQualified, EEH.dbo.shipper_detail.qty_packed AS QtyShipout, EEH.dbo.shipper_detail.price
FROM     EEH.dbo.shipper INNER JOIN
                  EEH.dbo.shipper_detail ON EEH.dbo.shipper.id = EEH.dbo.shipper_detail.shipper INNER JOIN
                  EEH.dbo.part ON EEH.dbo.shipper_detail.part = EEH.dbo.part.part LEFT OUTER JOIN
                  EEH.dbo.HTSCode AS CodeUS ON EEH.dbo.part.HTSCodeUSCustoms = CodeUS.HTSCode LEFT OUTER JOIN
                  EEH.dbo.HTSCode AS CodeHN ON EEH.dbo.part.HTSCodeHNCustoms = CodeHN.HTSCode
WHERE  (EEH.dbo.shipper.pro_number IS NOT NULL) AND (SUBSTRING(EEH.dbo.shipper.aetc_number, 1, 1) <> 'A') AND (EEH.dbo.shipper_detail.date_shipped > '1/1/2017') AND (EEH.dbo.shipper.type IS NULL)
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
         Begin Table = "CodeUS"
            Begin Extent = 
               Top = 7
               Left = 1004
               Bottom = 148
               Right = 1202
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CodeHN"
            Begin Extent = 
               Top = 7
               Left = 1250
               Bottom = 148
               Right = 1448
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "shipper (EEH.dbo)"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 323
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "shipper_detail (EEH.dbo)"
            Begin Extent = 
               Top = 7
               Left = 371
               Bottom = 170
               Right = 619
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "part (EEH.dbo)"
            Begin Extent = 
               Top = 7
               Left = 667
               Bottom = 170
               Right = 966
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
      Begin ColumnWidths = 14
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
      ', 'SCHEMA', N'dbo', 'VIEW', N'VW_MAT_HTSCodeShipperDetail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'   Width = 1200
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
', 'SCHEMA', N'dbo', 'VIEW', N'VW_MAT_HTSCodeShipperDetail', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'VW_MAT_HTSCodeShipperDetail', NULL, NULL
GO
