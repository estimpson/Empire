SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vw_eei_ala_locations_row2]
as
Select code  from location where code like '%-%' and  code like 'ALA%' and name like '%ROW2'
GO
