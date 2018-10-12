SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[object_historical] as
	select * from eeh.dbo.object_historical with (Readuncommitted)
GO
