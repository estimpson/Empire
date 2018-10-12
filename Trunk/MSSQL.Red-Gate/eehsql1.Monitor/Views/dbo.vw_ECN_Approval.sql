SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_ECN_Approval]
AS
SELECT DISTINCT 
                         DATEDIFF(WEEK, '01/01/2013', EEH.dbo.VW_ProgramAPQP.EEHShipDate) + 1 AS WK, EEH.dbo.VW_ProgramAPQP.PEM, EEH.dbo.VW_ProgramAPQP.Part, EEH.dbo.VW_ProgramAPQP.Phase, 
                         EEH.dbo.VW_ProgramAPQP.TransDT, EEH.dbo.VW_ProgramAPQP.Status, EEH.dbo.VW_ProgramAPQP.Comments, EEH.dbo.VW_ProgramAPQP.Engineer, EEH.dbo.VW_ProgramAPQP.ID, 
                         EEH.dbo.VW_ProgramAPQP.WOEngineerID, EEH.dbo.VW_ProgramAPQP.ScheduledShipDateECN, ISNULL(EEH.dbo.VW_ProgramAPQP.ScheduledShipDate, EEH.dbo.VW_ProgramAPQP.ScheduledShipDateECN) 
                         AS ScheduledShipDate, EEH.dbo.VW_ProgramAPQP.EEHShipDate, EEH.dbo.VW_ProgramAPQP.Quantity, EEH.dbo.VW_ProgramAPQP.WOEngineerScheduleDeliveryID, EEH.dbo.VW_ProgramAPQP.RevDT, 
                         EEH.dbo.VW_ProgramAPQP.Team, CASE AnalysisEngineer WHEN '1' THEN 'No Definido' ELSE AnalysisEngineer END AS AnalysisEngineer, 
                         CASE BuildsEngineer WHEN '1' THEN 'No Definido' ELSE BuildsEngineer END AS BuildsEngineer, RTRIM(EEH.dbo.VW_ProgramAPQP.ContainmentStatus) AS ContainmentStatus, 
                         EEH.dbo.VW_ProgramAPQP.QuatilyReject, RTRIM(EEH.dbo.VW_ProgramAPQP.Classification) AS Classification, EEH.dbo.VW_ProgramAPQP.Description, 
                         '\\eehdata1\Ingenieria\DocumentosAPQP\Containment Report\' + EEH.dbo.VW_ProgramAPQP.Part + '\' + EEH.dbo.VW_ProgramAPQP.ContainmentReport AS ContainmentReport, CONVERT(bit, 
                         CASE isnull(ContainmentReport, '') WHEN '' THEN 0 ELSE 1 END) AS ExisteReport, EEH.dbo.VW_ProgramAPQP.VendorCommitmentDate, EEH.dbo.VW_ProgramAPQP.VendorCommitmentQty, 
                         CASE part.class WHEN 'M' THEN VW_ProgramAPQP.Responsible ELSE 'BOM-No Programar' END AS Responsible, CASE isnull(CompMoldeo.Componentes, - 1) 
                         WHEN - 1 THEN 'No' ELSE 'Si' END AS AplicaMoldeo, CASE isnull(CONVERT(bit, ExisteCambio.WOEngineerID), 0) WHEN 0 THEN 0 ELSE 1 END AS ExistenComp, CASE isnull(CONVERT(bit, 
                         ValidadoVI.WOEngineerID), 0) WHEN 0 THEN 0 ELSE 1 END AS StatusVI, EEH.dbo.VW_ProgramAPQP.CommentProduccion, dbo.part.class, 
                         CASE VW_ProgramAPQP.Responsible WHEN 'No Programar' THEN 0 ELSE 1 END AS PKProgramar, EEH.dbo.VW_ProgramAPQP.AplicaMaterial, ISNULL(EEH.dbo.VW_ProgramAPQP.StatusPart, 'Releases') 
                         AS StatusPart
FROM            EEH.dbo.VW_ProgramAPQP LEFT OUTER JOIN
                         EEH.dbo.VW_ProgramAPQP_CSM ON EEH.dbo.VW_ProgramAPQP.BasePart = EEH.dbo.VW_ProgramAPQP_CSM.base_part LEFT OUTER JOIN
                             (SELECT        WOEngineerID, COUNT(*) AS Componentes
                               FROM            EEH.dbo.ENG_WOEngineer_MaterialChange
                               WHERE        (LEFT(Part, 3) IN ('EEM', 'MLD', 'MOL'))
                               GROUP BY WOEngineerID) AS CompMoldeo ON CompMoldeo.WOEngineerID = EEH.dbo.VW_ProgramAPQP.WOEngineerID LEFT OUTER JOIN
                             (SELECT DISTINCT WOEngineerID
                               FROM            EEH.dbo.ENG_WOEngineer_MaterialChange AS ENG_WOEngineer_MaterialChange_2) AS ExisteCambio ON 
                         ExisteCambio.WOEngineerID = EEH.dbo.VW_ProgramAPQP.WOEngineerID LEFT OUTER JOIN
                             (SELECT DISTINCT WOEngineerID
                               FROM            EEH.dbo.ENG_WOEngineer_MaterialChange AS ENG_WOEngineer_MaterialChange_1
                               WHERE        (StatusVI = 1)) AS ValidadoVI ON ValidadoVI.WOEngineerID = EEH.dbo.VW_ProgramAPQP.WOEngineerID LEFT OUTER JOIN
                         dbo.part ON dbo.part.part = EEH.dbo.VW_ProgramAPQP.Part
WHERE        (ISNULL(EEH.dbo.VW_ProgramAPQP.Status, 'In Process') LIKE 'I%') AND (EEH.dbo.VW_ProgramAPQP.Liberado = 1) AND (EEH.dbo.VW_ProgramAPQP.StatusTroy = 'A') AND 
                         (EEH.dbo.VW_ProgramAPQP.Phase = 'ECN-SOP') AND (EEH.dbo.VW_ProgramAPQP.AplicaMaterial IS NULL OR
                         EEH.dbo.VW_ProgramAPQP.AplicaMaterial = 'SI') AND ((CASE isnull(CompMoldeo.Componentes, - 1) WHEN - 1 THEN 'No' ELSE 'Si' END) = 'Si' OR
                         (CASE isnull(CompMoldeo.Componentes, - 1) WHEN - 1 THEN 'No' ELSE 'Si' END) = 'No') AND (EEH.dbo.VW_ProgramAPQP.Responsible = 'Programar') OR
                         (ISNULL(EEH.dbo.VW_ProgramAPQP.Status, 'In Process') LIKE 'I%') AND (EEH.dbo.VW_ProgramAPQP.Liberado = 1) AND (EEH.dbo.VW_ProgramAPQP.StatusTroy = 'A') AND 
                         (EEH.dbo.VW_ProgramAPQP.Phase = 'ECN-SOP') AND (EEH.dbo.VW_ProgramAPQP.AplicaMaterial = 'NO') AND ((CASE isnull(CompMoldeo.Componentes, - 1) WHEN - 1 THEN 'No' ELSE 'Si' END) = 'Si') AND 
                         (EEH.dbo.VW_ProgramAPQP.Responsible = 'Programar')
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
         Begin Table = "VW_ProgramAPQP (EEH.dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 316
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VW_ProgramAPQP_CSM (EEH.dbo)"
            Begin Extent = 
               Top = 6
               Left = 354
               Bottom = 102
               Right = 585
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CompMoldeo"
            Begin Extent = 
               Top = 6
               Left = 623
               Bottom = 102
               Right = 793
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ExisteCambio"
            Begin Extent = 
               Top = 6
               Left = 831
               Bottom = 85
               Right = 1001
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ValidadoVI"
            Begin Extent = 
               Top = 6
               Left = 1039
               Bottom = 85
               Right = 1209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "part"
            Begin Extent = 
               Top = 6
               Left = 1247
               Bottom = 136
               Right = 1491
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
         ', 'SCHEMA', N'dbo', 'VIEW', N'vw_ECN_Approval', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'Width = 1500
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
', 'SCHEMA', N'dbo', 'VIEW', N'vw_ECN_Approval', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_ECN_Approval', NULL, NULL
GO
