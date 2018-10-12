SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [HN].[SP_CAL_RPT_MoldingInventoryInWeeks]( @ReportType varchar(10) = 'DETALLE' ) as
	exec  EEH.HN.SP_CAL_RPT_MoldingInventoryInWeeks @ReportType = @ReportType
GO
