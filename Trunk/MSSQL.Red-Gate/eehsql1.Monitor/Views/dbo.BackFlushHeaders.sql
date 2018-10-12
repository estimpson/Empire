SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[BackFlushHeaders] as 
	select	* from EEH.dbo.BackFlushHeaders with (readuncommitted)

GO
