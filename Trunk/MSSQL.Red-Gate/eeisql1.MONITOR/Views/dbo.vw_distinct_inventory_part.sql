SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
create view [dbo].[vw_distinct_inventory_part] as
select distinct part from object
GO
