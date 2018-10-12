SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[csm_q_RawMaterial_FG_forcast]
AS
SELECT csmData.version, xrt.ChildPart AS Part, dbo.part.name AS description, dbo.part_standard.cost AS PurchasePrice, dbo.part_online.default_vendor AS Supplier,
	 xrt.TopPart AS FGPart, xrt.XQty AS BOMQty, 
                  PurcarseAverage.AVG_Purcharse * 4.3 AS AVG_Purcharse, csmData.base_part, csmData.assembly_plant, 
				  csmData.manufacturer, csmData.program, csmData.badge, csmData.eop, csmData.sop,
                  csmData.Jan_17_TOTALdemand AS FGjan_17_TOTALdemand, csmData.Feb_17_TOTALdemand AS FGfeb_17_TOTALdemand, csmData.Mar_17_TOTALdemand AS FGmar_17_TOTALdemand, 
                  csmData.Apr_17_TOTALdemand AS FGapr_17_TOTALdemand, csmData.May_17_TOTALdemand AS FGmay_17_TOTALdemand, csmData.Jun_17_TOTALdemand AS FGjun_17_TOTALdemand, 
                  csmData.Jul_17_TOTALdemand AS FGjul_17_TOTALdemand, csmData.Aug_17_TOTALdemand AS FGaug_17_TOTALdemand, csmData.Sep_17_TOTALdemand AS FGsep_17_TOTALdemand, 
                  csmData.Oct_17_TOTALdemand AS FGoct_17_TOTALdemand, csmData.Nov_17_TOTALdemand AS FGnov_17_TOTALdemand, csmData.Dec_17_TOTALdemand AS FGdec_17_TOTALdemand, 
                  csmData.Jan_18_TOTALdemand AS FGjan_18_TOTALdemand, csmData.Feb_18_TOTALdemand AS FGfeb_18_TOTALdemand, csmData.Mar_18_TOTALdemand AS FGmar_18_TOTALdemand, 
                  csmData.Apr_18_TOTALdemand AS FGapr_18_TOTALdemand, csmData.May_18_TOTALdemand AS FGmay_18_TOTALdemand, csmData.Jun_18_TOTALdemand AS FGjun_18_TOTALdemand, 
                  csmData.Jul_18_TOTALdemand AS FGjul_18_TOTALdemand, csmData.Aug_18_TOTALdemand AS FGaug_18_TOTALdemand, csmData.Sep_18_TOTALdemand AS FGsep_18_TOTALdemand, 
                  csmData.Oct_18_TOTALdemand AS FGoct_18_TOTALdemand, csmData.Nov_18_TOTALdemand AS FGnov_18_TOTALdemand, csmData.Dec_18_TOTALdemand AS FGdec_18_TOTALdemand, 
                  csmData.Jan_19_TOTALdemand AS FGjan_19_TOTALdemand, csmData.Feb_19_TOTALdemand AS FGfeb_19_TOTALdemand, csmData.Mar_19_TOTALdemand AS FGmar_19_TOTALdemand, 
                  csmData.Apr_19_TOTALdemand AS FGapr_19_TOTALdemand, csmData.May_19_TOTALdemand AS FGmay_19_TOTALdemand, csmData.Jun_19_TOTALdemand AS FGjun_19_TOTALdemand, 
                  csmData.Jul_19_TOTALdemand AS FGjul_19_TOTALdemand, csmData.Aug_19_TOTALdemand AS FGaug_19_TOTALdemand, csmData.Sep_19_TOTALdemand AS FGsep_19_TOTALdemand, 
                  csmData.Oct_19_TOTALdemand AS FGoct_19_TOTALdemand, csmData.Nov_19_TOTALdemand AS FGnov_19_TOTALdemand, csmData.Dec_19_TOTALdemand AS FGdec_19_TOTALdemand, 
                  csmData.Jan_20_TOTALdemand AS FGjan_20_TOTALdemand, csmData.Feb_20_TOTALdemand AS FGfeb_20_TOTALdemand, csmData.Mar_20_TOTALdemand AS FGmar_20_TOTALdemand, 
                  csmData.Apr_20_TOTALdemand AS FGapr_20_TOTALdemand, csmData.May_20_TOTALdemand AS FGmay_20_TOTALdemand, csmData.Jun_20_TOTALdemand AS FGjun_20_TOTALdemand, 
                  csmData.Jul_20_TOTALdemand AS FGjul_20_TOTALdemand, csmData.Aug_20_TOTALdemand AS FGaug_20_TOTALdemand, csmData.Sep_20_TOTALdemand AS FGsep_20_TOTALdemand, 
                  csmData.Oct_20_TOTALdemand AS FGoct_20_TOTALdemand, csmData.Nov_20_TOTALdemand AS FGnov_20_TOTALdemand, csmData.Dec_20_TOTALdemand AS FGdec_20_TOTALdemand, 
                  xrt.XQty * csmData.Jan_17_TOTALdemand AS RAWQty_jan_17_TOTALdemand, xrt.XQty * csmData.Feb_17_TOTALdemand AS RAWQty_feb_17_TOTALdemand, 
                  xrt.XQty * csmData.Mar_17_TOTALdemand AS RAWQty_mar_17_TOTALdemand, xrt.XQty * csmData.Apr_17_TOTALdemand AS RAWQty_apr_17_TOTALdemand, 
                  xrt.XQty * csmData.May_17_TOTALdemand AS RAWQty_may_17_TOTALdemand, xrt.XQty * csmData.Jun_17_TOTALdemand AS RAWQty_jun_17_TOTALdemand, 
                  xrt.XQty * csmData.Jul_17_TOTALdemand AS RAWQty_jul_17_TOTALdemand, xrt.XQty * csmData.Aug_17_TOTALdemand AS RAWQty_aug_17_TOTALdemand, 
                  xrt.XQty * csmData.Sep_17_TOTALdemand AS RAWQty_sep_17_TOTALdemand, xrt.XQty * csmData.Oct_17_TOTALdemand AS RAWQty_oct_17_TOTALdemand, 
                  xrt.XQty * csmData.Nov_17_TOTALdemand AS RAWQty_nov_17_TOTALdemand, xrt.XQty * csmData.Dec_17_TOTALdemand AS RAWQty_dec_17_TOTALdemand, 
                  xrt.XQty * csmData.Jan_18_TOTALdemand AS RAWQty_jan_18_TOTALdemand, xrt.XQty * csmData.Feb_18_TOTALdemand AS RAWQty_feb_18_TOTALdemand, 
                  xrt.XQty * csmData.Mar_18_TOTALdemand AS RAWQty_mar_18_TOTALdemand, xrt.XQty * csmData.Apr_18_TOTALdemand AS RAWQty_apr_18_TOTALdemand, 
                  xrt.XQty * csmData.May_18_TOTALdemand AS RAWQty_may_18_TOTALdemand, xrt.XQty * csmData.Jun_18_TOTALdemand AS RAWQty_jun_18_TOTALdemand, 
                  xrt.XQty * csmData.Jul_18_TOTALdemand AS RAWQty_jul_18_TOTALdemand, xrt.XQty * csmData.Aug_18_TOTALdemand AS RAWQty_aug_18_TOTALdemand, 
                  xrt.XQty * csmData.Sep_18_TOTALdemand AS RAWQty_sep_18_TOTALdemand, xrt.XQty * csmData.Oct_18_TOTALdemand AS RAWQty_oct_18_TOTALdemand, 
                  xrt.XQty * csmData.Nov_18_TOTALdemand AS RAWQty_nov_18_TOTALdemand, xrt.XQty * csmData.Dec_18_TOTALdemand AS RAWQty_dec_18_TOTALdemand, 
                  xrt.XQty * csmData.Jan_19_TOTALdemand AS RAWQty_jan_19_TOTALdemand, xrt.XQty * csmData.Feb_19_TOTALdemand AS RAWQty_feb_19_TOTALdemand, 
                  xrt.XQty * csmData.Mar_19_TOTALdemand AS RAWQty_mar_19_TOTALdemand, xrt.XQty * csmData.Apr_19_TOTALdemand AS RAWQty_apr_19_TOTALdemand, 
                  xrt.XQty * csmData.May_19_TOTALdemand AS RAWQty_may_19_TOTALdemand, xrt.XQty * csmData.Jun_19_TOTALdemand AS RAWQty_jun_19_TOTALdemand, 
                  xrt.XQty * csmData.Jul_19_TOTALdemand AS RAWQty_jul_19_TOTALdemand, xrt.XQty * csmData.Aug_19_TOTALdemand AS RAWQty_aug_19_TOTALdemand, 
                  xrt.XQty * csmData.Sep_19_TOTALdemand AS RAWQty_sep_19_TOTALdemand, xrt.XQty * csmData.Oct_19_TOTALdemand AS RAWQty_oct_19_TOTALdemand, 
                  xrt.XQty * csmData.Nov_19_TOTALdemand AS RAWQty_nov_19_TOTALdemand, xrt.XQty * csmData.Dec_19_TOTALdemand AS RAWQty_dec_19_TOTALdemand, 
                  xrt.XQty * csmData.Jan_20_TOTALdemand AS RAWQty_jan_20_TOTALdemand, xrt.XQty * csmData.Feb_20_TOTALdemand AS RAWQty_feb_20_TOTALdemand, 
                  xrt.XQty * csmData.Mar_20_TOTALdemand AS RAWQty_mar_20_TOTALdemand, xrt.XQty * csmData.Apr_20_TOTALdemand AS RAWQty_apr_20_TOTALdemand, 
                  xrt.XQty * csmData.May_20_TOTALdemand AS RAWQty_may_20_TOTALdemand, xrt.XQty * csmData.Jun_20_TOTALdemand AS RAWQty_jun_20_TOTALdemand, 
                  xrt.XQty * csmData.Jul_20_TOTALdemand AS RAWQty_jul_20_TOTALdemand, xrt.XQty * csmData.Aug_20_TOTALdemand AS RAWQty_aug_20_TOTALdemand, 
                  xrt.XQty * csmData.Sep_20_TOTALdemand AS RAWQty_sep_20_TOTALdemand, xrt.XQty * csmData.Oct_20_TOTALdemand AS RAWQty_oct_20_TOTALdemand, 
                  xrt.XQty * csmData.Nov_20_TOTALdemand AS RAWQty_nov_20_TOTALdemand, xrt.XQty * csmData.Dec_20_TOTALdemand AS RAWQty_dec_20_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Jan_17_TOTALdemand AS cost_jan_17_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Feb_17_TOTALdemand AS cost_feb_17_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Mar_17_TOTALdemand AS cost_mar_17_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Apr_17_TOTALdemand AS cost_apr_17_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.May_17_TOTALdemand AS cost_may_17_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Jun_17_TOTALdemand AS cost_jun_17_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Jul_17_TOTALdemand AS cost_jul_17_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Aug_17_TOTALdemand AS cost_aug_17_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Sep_17_TOTALdemand AS cost_sep_17_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Oct_17_TOTALdemand AS cost_oct_17_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Nov_17_TOTALdemand AS cost_nov_17_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Dec_17_TOTALdemand AS cost_dec_17_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Jan_18_TOTALdemand AS cost_jan_18_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Feb_18_TOTALdemand AS cost_feb_18_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Mar_18_TOTALdemand AS cost_mar_18_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Apr_18_TOTALdemand AS cost_apr_18_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.May_18_TOTALdemand AS cost_may_18_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Jun_18_TOTALdemand AS cost_jun_18_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Jul_18_TOTALdemand AS cost_jul_18_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Aug_18_TOTALdemand AS cost_aug_18_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Sep_18_TOTALdemand AS cost_sep_18_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Oct_18_TOTALdemand AS cost_oct_18_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Nov_18_TOTALdemand AS cost_nov_18_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Dec_18_TOTALdemand AS cost_dec_18_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Jan_19_TOTALdemand AS cost_jan_19_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Feb_19_TOTALdemand AS cost_feb_19_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Mar_19_TOTALdemand AS cost_mar_19_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Apr_19_TOTALdemand AS cost_apr_19_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.May_19_TOTALdemand AS cost_may_19_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Jun_19_TOTALdemand AS cost_jun_19_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Jul_19_TOTALdemand AS cost_jul_19_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Aug_19_TOTALdemand AS cost_aug_19_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Sep_19_TOTALdemand AS cost_sep_19_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Oct_19_TOTALdemand AS cost_oct_19_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Nov_19_TOTALdemand AS cost_nov_19_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Dec_19_TOTALdemand AS cost_dec_19_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Jan_20_TOTALdemand AS cost_jan_20_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Feb_20_TOTALdemand AS cost_feb_20_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Mar_20_TOTALdemand AS cost_mar_20_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Apr_20_TOTALdemand AS cost_apr_20_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.May_20_TOTALdemand AS cost_may_20_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Jun_20_TOTALdemand AS cost_jun_20_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Jul_20_TOTALdemand AS cost_jul_20_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Aug_20_TOTALdemand AS cost_aug_20_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Sep_20_TOTALdemand AS cost_sep_20_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Oct_20_TOTALdemand AS cost_oct_20_TOTALdemand, 
                  xrt.XQty * dbo.part_standard.cost * csmData.Nov_20_TOTALdemand AS cost_nov_20_TOTALdemand, xrt.XQty * dbo.part_standard.cost * csmData.Dec_20_TOTALdemand AS cost_dec_20_TOTALdemand, 
                  xrt.XQty * csmData.Total_2017_TOTALdemand AS RAWQty_Total_2017, xrt.XQty * csmData.Total_2018_TOTALdemand AS RAWQty_Total_2018, xrt.XQty * csmData.Total_2019_TOTALdemand AS RAWQty_Total_2019, 
                  xrt.XQty * csmData.Total_2020_TOTALdemand AS RAWQty_Total_2020
FROM     dbo.part INNER JOIN
                  dbo.part_standard ON dbo.part.part = dbo.part_standard.part INNER JOIN
                  dbo.part_online ON dbo.part.part = dbo.part_online.part INNER JOIN
                  FT.XRt AS xrt ON xrt.ChildPart = dbo.part.part INNER JOIN
                  EEH.dbo.CSM_MonitorPart AS Future ON xrt.TopPart = Future.Part INNER JOIN
                  EEH.dbo.csm_NACSM AS csmData ON Future.BasePart = csmData.base_part LEFT OUTER JOIN
                      (SELECT part, SUM(qnty) / 4 AS AVG_Purcharse
                       FROM      dbo.master_prod_sched
                       WHERE   (due < DATEADD(WEEK, 5, GETDATE())) AND (type = 'P')
                       GROUP BY part) AS PurcarseAverage ON PurcarseAverage.part = dbo.part.part
WHERE  (xrt.BOMLevel > 0) AND (dbo.part.type = 'R')

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
         Begin Table = "part"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 347
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "part_standard"
            Begin Extent = 
               Top = 175
               Left = 48
               Bottom = 338
               Right = 296
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "part_online"
            Begin Extent = 
               Top = 343
               Left = 48
               Bottom = 506
               Right = 291
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "xrt"
            Begin Extent = 
               Top = 511
               Left = 48
               Bottom = 674
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Future"
            Begin Extent = 
               Top = 679
               Left = 48
               Bottom = 798
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "csmData"
            Begin Extent = 
               Top = 798
               Left = 48
               Bottom = 961
               Right = 328
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PurcarseAverage"
            Begin Extent = 
               Top = 7
               Left = 395
               Bottom = 126
               Right = 589
            End
            DisplayFlags', 'SCHEMA', N'dbo', 'VIEW', N'csm_q_RawMaterial_FG_forcast', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N' = 280
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
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'csm_q_RawMaterial_FG_forcast', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'csm_q_RawMaterial_FG_forcast', NULL, NULL
GO
