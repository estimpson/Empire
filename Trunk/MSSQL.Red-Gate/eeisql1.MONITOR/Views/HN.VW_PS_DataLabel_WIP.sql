SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/*
Select	*
from	[HN].[VW_PS_DataLabel_WIP]
where	familia='trw'


Select *
from hn.VW_PS_DataLabel_WIP
where	serial=25602910
*/
CREATE VIEW [HN].[VW_PS_DataLabel_WIP]
AS
SELECT        dbo.object.serial, CONVERT(varchar, dbo.object.serial) AS SetSerial, dbo.object.part AS SetPart, dbo.object.location AS SetLocation, CONVERT(varchar, 
                         CONVERT(integer, dbo.object.quantity)) AS SetQuantity, dbo.object.operator AS SetOperator, ISNULL(dbo.object.lot, '') AS SetLot, CONVERT(varchar, 
                         dbo.object.last_date, 101) AS Setdatetime, CONVERT(varchar, dbo.object.last_date, 101) AS SetCurrentDate, CONVERT(varchar, dbo.object.last_time, 108) AS SetLastTime, CONVERT(varchar, dbo.object.last_time, 108) AS SetCurrentTime, dbo.object.status AS Setstatus, DATEADD(d, 
                         ISNULL(pi.shelf_life_days, 0), dbo.object.start_date) AS SetExpDate, dbo.object.lot AS SetBin_Lote, IDLabels.Part AS SETIDFGPart,
SetFamilia = isnull((Select top 1 Familia='TRW'
			from	ft.xrt
			where	ChildPart=dbo.object.part
				and	toppart like 'trw%'),''),
SetTZ3Date=substring(CONVERT(VARCHAR(12),dbo.object.last_date,112),3,10),
SetTZ3Time=replace(CONVERT(VARCHAR(08),dbo.object.last_date,108),':',''),
setTZ3Bin=substring(dbo.object.custom5,1,5),
SetTZ3PartDescr=substring(dbo.object.custom5,6,len(dbo.object.custom5))
FROM            dbo.object left JOIN
                         dbo.part_inventory AS pi ON pi.part = dbo.object.part LEFT OUTER JOIN
                         HN.BF_IdLabel_WOSerials AS IDLabels ON IDLabels.Serial = dbo.object.serial

--UNION ALL
--Select	serial,
--		Setserial=CONVERT(varchar, serial),
--		SetPart=	a.Part,
--		SetLocation='',
--		SetQuantity=CONVERT(varchar, quantity),
--		SetOperator=a.operator,
--		setLot='',
--		Setdatetime=substring(CONVERT(VARCHAR(12),date_stamp,112),3,10),
--		SetCurrentDate=substring(CONVERT(VARCHAR(12),date_stamp,112),3,10),
--		SetLastTime=replace(CONVERT(VARCHAR(08),date_stamp,108),':',''),
--		SetLastCurrentTime=replace(CONVERT(VARCHAR(08),date_stamp,108),':',''),
--		Setstatus='A',
--		SetExpDate='', SetBin_Lote='', SETIDFGPart= case when a.part like '%4052%' then 'W1121L / PWB SEMI ASSY' when a.part like '%4051%' then 'W1121R / PWB SEMI ASSY' else '' end,
--		SetFamilia=''
--from	eeh.dbo.audit_trail a
--	inner join eeh.dbo.part  p on a.part = p.part
--where	a.part like 'rtr-eeb405%'
--	and date_stamp>='2014-02-14'
--	and a.type='J'



GO
GRANT SELECT ON  [HN].[VW_PS_DataLabel_WIP] TO [APPUser]
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
         Begin Table = "object"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 258
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pi"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 302
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IDLabels"
            Begin Extent = 
               Top = 6
               Left = 296
               Bottom = 136
               Right = 466
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
', 'SCHEMA', N'HN', 'VIEW', N'VW_PS_DataLabel_WIP', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'HN', 'VIEW', N'VW_PS_DataLabel_WIP', NULL, NULL
GO
