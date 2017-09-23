SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[ftvwePart]
(	Part,
	Description )
as
--	Description:
--	Exceptions are parts marked as obsolete.
select	Part = part.part,
	Description = 'The part ' + part.part + ' is marked as obsolete.'
from	dbo.part
where	part.type = 'O'
GO
