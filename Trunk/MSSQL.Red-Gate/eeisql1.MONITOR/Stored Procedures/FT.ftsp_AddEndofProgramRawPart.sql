SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_AddEndofProgramRawPart] (
	@Operator varchar (5),
	@ProgramID int,
	@PartCode varchar (25),
	@CustomerCode varchar (10)
--<Debug>
	, @Debug integer = 0
--</Debug>
)
as
/*
Arguments:
PartCode
CustomerCode

Result set:
None

Description:
Adds a raw part to the End of Program calculation.

Example:
execute	FT.ftsp_AddEndofProgramRawPart
	@PartCode = 'Test',
	@CustomerCode = 'Test'
--<Debug>
	, @Debug = 1
--</Debug>

Author:
Eric Stimpson
Copyright © 2004 Fore-Thought, LLC

Process:
--	I.	Validate parameters.
--		A.	PartCode must be valid.
--		B.	CustomerCode must be valid.
--		C.	PartCode-CustomerCode must not already exist.
--	II.	Create end of program raw part.
*/

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	print	'AddEndofProgramRawPart START.   ' + Convert ( varchar (50), @StartDT )
	select	@ProcStartDT = GetDate ( )
end
--</Debug>

--<Tran>
if @@TranCount = 0 begin
	begin transaction AddEndofProgramRawPart
end
save transaction AddEndofProgramRawPart
--</Tran>

--	Declarations:
declare	@ProcResult integer,
	@Error integer

--	I.	Validate parameters.
--<Debug>
if @Debug & 1 = 1 begin
	print	'I.	Validate parameters.'
end
--</Debug>
--		A.	PartCode must be valid.
--<Debug>
if @Debug & 1 = 1 begin
	print	'	A.	PartCode must be valid.'
end
--</Debug>
--		B.	CustomerCode must be valid.
--<Debug>
if @Debug & 1 = 1 begin
	print	'	B.	CustomerCode must be valid.'
end
--</Debug>
--		C.	PartCode-CustomerCode must not already exist.
--<Debug>
if @Debug & 1 = 1 begin
	print	'	C.	PartCode-CustomerCode must not already exist.'
end
--</Debug>
if exists
(	select	1
	from	EndofProgramRawParts
	where	Operator = @Operator and
		ProgramID = @ProgramID and
		PartCode = @PartCode and
		CustomerCode = @CustomerCode ) begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'PartCode-CustomerCode must not already exist.'
	end
--</Debug>
	rollback tran AddEndofProgramRawPart
	return -100
end

--	II.	Create end of program raw part.
--<Debug>
if @Debug & 1 = 1 begin
	print	'II.	Create end of program raw part.'
end
--</Debug>
insert	EndofProgramRawParts
(	Operator,
	ProgramID,
	PartCode,
	CustomerCode )
select	@Operator,  @ProgramID, @PartCode, @CustomerCode

--<Error Handling>
select	@Error = @@Error
if @Error != 0 begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'Error creating end of program raw part.'
		print	'Error: (' + Convert ( varchar, @Error ) + ')'
	end
--</Debug>
	rollback tran AddEndofProgramRawPart
	return -100
end
--</Error Handling>

--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate ( ) ) ) + ' ms'
end
--</Debug>
GO
