SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_RemoveEndofProgramRawPart] (
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
Removes a raw part from the End of Program calculation.

Example:
execute	FT.ftsp_RemoveEndofProgramRawPart
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
--		A.	PartCode-CustomerCode must exist.
--	II.	Remove raw part.
*/

declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	print	'RemoveEndofProgramRawPart START.   ' + Convert ( varchar (50), @StartDT )
	select	@ProcStartDT = GetDate ( )
end
--</Debug>

--<Tran>
if @@TranCount = 0 begin
	begin transaction RemoveEndofProgramRawPart
end
save transaction RemoveEndofProgramRawPart
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
--	A.	PartCode-CustomerCode must exist.
--<Debug>
if @Debug & 1 = 1 begin
	print	'	A.	PartCode-CustomerCode must exist.'
end
--</Debug>
if not exists
(	select	1
	from	EndofProgramRawPart
	where	PartCode = @PartCode and
		CustomerCode = @CustomerCode ) begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'PartCode-CustomerCode must already exist.'
	end
--</Debug>
	rollback tran RemoveEndofProgramRawPart
	return -100
end

--	II.	Remove raw part.
--<Debug>
if @Debug & 1 = 1 begin
	print	'II.	Remove raw part.'
end
--</Debug>
delete	EndofProgramRawParts
where	PartCode = @PartCode and
	CustomerCode = @CustomerCode

--<Error Handling>
select	@Error = @@Error
if @Error != 0 begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'Error removing raw part.'
		print	'Error: (' + Convert ( varchar, @Error ) + ')'
	end
--</Debug>
	rollback tran RemoveEndofProgramRawPart
	return -100
end
--</Error Handling>

--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate ( ) ) ) + ' ms'
end
--</Debug>
GO
