SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[gage_master] as
	select * from  GAGEMGR6.[dbo].gage_master
GO
