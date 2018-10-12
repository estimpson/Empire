SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [HN].[RLSP_MAT_GetInfoByLocation](@Location varchar(15))
as 
	exec eeh.HN.RLSP_MAT_GetInfoByLocation @location
GO
