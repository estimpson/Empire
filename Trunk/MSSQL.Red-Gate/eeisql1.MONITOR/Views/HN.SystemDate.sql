SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create view [HN].[SystemDate] as
	(	select getdate() as SystemDate )
GO
