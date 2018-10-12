SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[FN_QIRSerial](@Serial int)
returns @Objects table
	(Serial int,
	BreakoutSerial int null,
	OriginalSerial int,
	PONumber int,
	Vendor varchar(20))
--returns int
as 
/*

select	*
from	dbo.FN_QIRSerial(25661812)


*/

begin

insert into @Objects
select	*
from	EEH.dbo.FN_QIRSerial(@Serial)

	return
end
GO
