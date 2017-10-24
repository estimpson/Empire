SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ResetEndingOrders] (
	@Operator varchar (5),
	@ProgramID int
--<Debug>
	, @Debug integer = 0
--</Debug>
)
as
/*
Arguments:
None

Result set:
None

Description:
Deletes all Ending Orders.

Example:
execute	FT.ftsp_ResetEndingOrders
--<Debug>
	@Debug = 1
--</Debug>

Author:
Eric Stimpson
Copyright © 2004 Fore-Thought, LLC

Process:
--	I.	Delete all Ending Orders.
*/

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	print	'ResetEndingOrders START.   ' + Convert ( varchar (50), @StartDT )
	select	@ProcStartDT = GetDate ( )
end
--</Debug>

--<Tran>
if @@TranCount = 0 begin
	begin transaction ResetEndingOrders
end
save transaction ResetEndingOrders
--</Tran>

--	Declarations:
declare	@ProcResult integer,
	@Error integer

--	I.	Delete all Ending Orders.
--<Debug>
if @Debug & 1 = 1 begin
	print	'I.	Delete all Ending Orders.'
end
--</Debug>
delete	EndingOrders
where	Operator = @Operator and
	ProgramID = @ProgramID


--<Error Handling>
select	@Error = @@Error
if @Error != 0 begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'Error removing Ending Orders.'
		print	'Error: (' + Convert ( varchar, @Error ) + ')'
	end
--</Debug>
	rollback tran ResetEndingOrders
	return -100
end
--</Error Handling>

--	II.	Delete all Raw Parts.
--<Debug>
if @Debug & 1 = 1 begin
	print	'II.	Delete all Raw Parts.'
end
--</Debug>
delete	EndingofProgramRawParts
where	Operator = @Operator and
	ProgramID = @ProgramID


--<Error Handling>
select	@Error = @@Error
if @Error != 0 begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'Error removing Raw Parts.'
		print	'Error: (' + Convert ( varchar, @Error ) + ')'
	end
--</Debug>
	rollback tran ResetEndingOrders
	return -100
end
--</Error Handling>

--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate ( ) ) ) + ' ms'
end
--</Debug>
GO
