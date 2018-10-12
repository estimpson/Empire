SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Calibration_Header] as
	select	* from GAGEMGR6.[dbo].Calibration_Header
GO
