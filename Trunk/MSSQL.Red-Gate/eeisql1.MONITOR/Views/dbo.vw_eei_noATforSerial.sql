SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_noATforSerial]
as

select  object.serial,object.part, object.last_date, object.location, object.operator, object.quantity from object 
join part on object.part = part.part 
where object.part <> 'RMA'  and part.class = 'P' and part.type = 'R' and serial not in (select serial from audit_trail)
GO
