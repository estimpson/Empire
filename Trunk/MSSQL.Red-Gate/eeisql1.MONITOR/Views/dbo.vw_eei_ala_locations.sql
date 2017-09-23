SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_ala_locations]
as
Select code  from location where code like '%-%' and  code like 'ALA%' and name not like '%ROW1' and name not like  '%ROW2'
GO
