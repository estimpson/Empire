SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[eeisp_ARS_rpt_CompareLastWeekReleasetoCurrent_nonEDI] as
	exec EEH.DBO.eeisp_ARS_rpt_CompareLastWeekReleasetoCurrent_nonEDI
GO
