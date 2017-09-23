SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_RemoveEndingOrder] (
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
Removes an Ending Orders.

Example:
execute	FT.ftsp_RemoveEndingOrder
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
--	II.	Remove ending order.
*/

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	print	'RemoveEndingOrder START.   ' + Convert ( varchar (50), @StartDT )
	select	@ProcStartDT = GetDate ( )
end
--</Debug>

--<Tran>
if @@TranCount = 0 begin
	begin transaction RemoveEndingOrder
end
save transaction RemoveEndingOrder
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
--		A.	PartCode-CustomerCode must exist.
--<Debug>
if @Debug & 1 = 1 begin
	print	'	A.	PartCode-CustomerCode must exist.'
end
--</Debug>
if not exists
(	select	1
	from	EndingOrders
	where	Operator = @Operator and
		ProgramID = @ProgramID and
		PartCode = @PartCode and
		CustomerCode = @CustomerCode ) begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'PartCode-CustomerCode must already exist.'
	end
--</Debug>
	rollback tran RemoveEndingOrder
	return -100
end

--	II.	Remove ending order.
--<Debug>
if @Debug & 1 = 1 begin
	print	'II.	Remove ending order.'
end
--</Debug>
delete	EndingOrders
where	Operator = @Operator and
	ProgramID = @ProgramID and
	PartCode = @PartCode and
	CustomerCode = @CustomerCode

--<Error Handling>
select	@Error = @@Error
if @Error != 0 begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'Error removing ending order.'
		print	'Error: (' + Convert ( varchar, @Error ) + ')'
	end
--</Debug>
	rollback tran RemoveEndingOrder
	return -100
end
--</Error Handling>

--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate ( ) ) ) + ' ms'
end
--</Debug>
GO
