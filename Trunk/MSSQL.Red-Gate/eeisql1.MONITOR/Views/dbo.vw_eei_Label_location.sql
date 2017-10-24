SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_Label_location]
as
select  code, (CASE WHEN SUBSTRING(Code,3,1)='1' THEN 'Down' ELSE 'Up' END) as arrow
From	Location
where type = 'ST' and
		code like '[A-Z]-%'
GO
