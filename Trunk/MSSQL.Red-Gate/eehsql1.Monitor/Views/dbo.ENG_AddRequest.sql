SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create view [dbo].[ENG_AddRequest] as
	select *  
	from EEH.dbo.ENG_AddRequest with (READUNCOMMITTED)
GO
