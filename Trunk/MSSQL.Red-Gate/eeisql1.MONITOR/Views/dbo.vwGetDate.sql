SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vwGetDate]
as
select	CurrentDatetime = GetDate ()
GO
