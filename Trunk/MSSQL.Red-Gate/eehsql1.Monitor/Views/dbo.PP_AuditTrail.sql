SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
		
		
create view [dbo].[PP_AuditTrail] as
	select * from sistema.dbo.PP_AuditTrail with (readuncommitted)
	
	
GO
