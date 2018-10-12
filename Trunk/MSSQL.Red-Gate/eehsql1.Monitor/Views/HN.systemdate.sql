SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[systemdate] as
SELECT     GETDATE() AS SystemDate
GO
