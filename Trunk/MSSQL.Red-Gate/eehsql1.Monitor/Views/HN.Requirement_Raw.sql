SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [HN].[Requirement_Raw]
AS
SELECT     contenedores.FechaEEH AS Fecha, xrt.ChildPart AS Part, dbo.part.commodity, SUM(ISNULL(Futuros.Contenedor1, 0) * xrt.XQty) AS qtyReq, COUNT(*) AS Expr1
FROM         Sistema.dbo.CP_Contenedores AS contenedores INNER JOIN
                      Sistema.dbo.CP_Contenedores_Futuros AS Futuros ON contenedores.ContenedorID = Futuros.ContenedorID INNER JOIN
                      FT.XRt AS xrt ON xrt.TopPart = Futuros.Part INNER JOIN
                      dbo.part ON dbo.part.part = xrt.ChildPart
WHERE     (xrt.BOMLevel > 0) AND (contenedores.Activo = 1)
GROUP BY contenedores.FechaEEH, xrt.ChildPart, dbo.part.commodity

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
         Begin Table = "contenedores"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 347
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Futuros"
            Begin Extent = 
               Top = 164
               Left = 340
               Bottom = 283
               Right = 528
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "xrt"
            Begin Extent = 
               Top = 31
               Left = 463
               Bottom = 150
               Right = 639
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "part"
            Begin Extent = 
               Top = 137
               Left = 38
               Bottom = 256
               Right = 238
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
      Begin ColumnWidths = 12
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
   ', 'SCHEMA', N'HN', 'VIEW', N'Requirement_Raw', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'End
End
', 'SCHEMA', N'HN', 'VIEW', N'Requirement_Raw', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'HN', 'VIEW', N'Requirement_Raw', NULL, NULL
GO
