SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Compras_InternalReq_Header_Empower]
AS
SELECT Internalpp.NumeroOrden, Internalpp.Comentario, CONVERT(date, Internalpp.FechaCreacion, 103) AS FechaCreacion, CONVERT(date, Internalpp.FechaRequisa, 103) AS FechaRequisa, 
                  CASE WHEN Internalpp.LastdateModify IS NULL AND Internalpp.Estado = 'Open' THEN 'No ha sido visto por el Analista' WHEN Internalpp.LastdateModify IS NULL AND 
                  Internalpp.Estado = 'En Proceso' THEN 'No ha sido visto por el Digitador' ELSE CONVERT(VARCHAR, Internalpp.LastdateModify, 111) END AS LastDate, Internalpp.Estado, DATEDIFF(day, Internalpp.FechaCreacion, 
                  Internalpp.LastdateModify) AS Dias, Internalpp.QH, usuarios.usr_nombre AS Asignado, EmpowerReq.requisition, EmpowerReq.requester, EmpowerReq.document_date, EmpowerReq.PO, 
                  EmpowerReq.document_comments, EmpowerReq.item, EmpowerReq.item_description, EmpowerReq.quantity, EmpowerReq.unit_cost, EmpowerReq.document_amount, EmpowerReq.buy_vendor, 
                  EmpowerReq.Ammount, EmpowerReq.PoClosedDT, EmpowerReq.DiffDias, EmpowerReq.posting_account, EmpowerReq.commodity, EmpowerReq.cost_account
FROM     Sistema.dbo.Compras_InternalReq_Header AS Internalpp LEFT OUTER JOIN
                  EEH.dbo.adm_usr_usuarios AS usuarios ON usuarios.usr_usuario = Internalpp.Asignado LEFT OUTER JOIN
                  dbo.vw_requisitions_dieroom AS EmpowerReq ON EmpowerReq.requisition = Internalpp.QH
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[28] 3) )"
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
         Begin Table = "Internalpp"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 167
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "usuarios"
            Begin Extent = 
               Top = 7
               Left = 333
               Bottom = 167
               Right = 584
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EmpowerReq"
            Begin Extent = 
               Top = 7
               Left = 632
               Bottom = 167
               Right = 869
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
', 'SCHEMA', N'dbo', 'VIEW', N'vw_Compras_InternalReq_Header_Empower', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_Compras_InternalReq_Header_Empower', NULL, NULL
GO
