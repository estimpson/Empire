SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[test_label] as

Select    object.part,
		object.serial,
		part.name
from	object
join		part on object.part = part.part
GO
