SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [HN].[BF_Report_Production_ScrapNotAutomatic] as
SELECT     WOHeaders.Machine, BackFlushHeaders.PartProduced, CONVERT(date, WOShift.ShiftDate) AS Fecha, SUM(BackFlushHeaders.QtyProduced) 
                      AS Totalprod, WOShift.Shift,InspeccionVisual= SUM(case when defectcode ='InspVisual' then QtyScrapped else 0 end), Variacion=SUM(case when defectcode ='RechazXCFA' then QtyScrapped else 0 end)
FROM         WOHeaders with (readuncommitted, nolock) 
			JOIN WODetails with (readuncommitted, nolock) ON WOHeaders.ID = WODetails.WOID 
			JOIN BackFlushHeaders with (readuncommitted, nolock) on BackFlushHeaders.WODID = WODetails.ID
			join WOShift with (readuncommitted, nolock) ON WOHeaders.ID = WOShift.WOID
			left join Defects with (readuncommitted, nolock) on Defects.WODID = WODetails.ID
WHERE    ( WOHeaders.Machine LIKE 'kom%' OR WOHeaders.Machine LIKE 'Art%')  
GROUP BY WOHeaders.Machine, BackFlushHeaders.PartProduced, CONVERT(date, WOShift.ShiftDate), WOShift.Shift
GO
