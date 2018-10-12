SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[BackflushRunner] as 
select	* from EEH.DBO.BackflushRunner with (readuncommitted)
GO
