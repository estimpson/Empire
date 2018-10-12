SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[CSM_MonitorPart]
as
select * from  dbo.fn_CSM_MonitorPart()

GO
