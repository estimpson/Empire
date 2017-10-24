SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[test] as
Select '1' as test
UNION
Select '2' as test
GO
