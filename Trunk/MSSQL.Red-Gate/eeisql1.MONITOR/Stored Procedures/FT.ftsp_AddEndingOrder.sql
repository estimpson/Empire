SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_AddEndingOrder] (
	@Operator varchar (5),
	@ProgramID int,
	@PartCode varchar (25),
	@CustomerCode varchar (10),
	@EndingQty numeric (20,6)
--<Debug>
	, @Debug integer = 0
--</Debug>
)
as
/*
Arguments:
PartCode
CustomerCode
Ending Qty

Result set:
None

Description:
Adds an Ending Orders.

Example:
execute	FT.ftsp_AddEndingOrder
	@PartCode = 'Test',
	@CustomerCode = 'Test',
	@EndingQty = 0
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
--		D.	Quantity must be zero or more.
--	II.	Create ending order.
*/

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	select	@StartDT = GetDate ( )
	select	@ProcStartDT = GetDate ( )
	print	'AddEndingOrder START.   ' + Convert ( varchar (50), @ProcStartDT )
end
--</Debug>

--<Tran>
if @@TranCount = 0 begin
	begin transaction AddEndingOrder
end
save transaction AddEndingOrder
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
	from	EndingOrders
	where	Operator = @Operator and
		ProgramID = @ProgramID and
		PartCode = @PartCode and
		CustomerCode = @CustomerCode ) begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'PartCode-CustomerCode must not already exist.'
	end
--</Debug>
	rollback tran AddEndingOrder
	return -100
end

--		D.	Quantity must be zero or more.
--<Debug>
if @Debug & 1 = 1 begin
	print	'	D.	Quantity must be zero or more..'
end
--</Debug>
if IsNull ( @EndingQty, -1 ) < 0 begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'Quantity must be zero or more..'
	end
--</Debug>
	rollback tran AddEndingOrder
	return -100
end

--	II.	Create ending order.
--<Debug>
if @Debug & 1 = 1 begin
	print	'II.	Create ending order.'
end
--</Debug>
insert	EndingOrders
(	Operator,
	ProgramID,
	PartCode,
	CustomerCode,
	EndingQty )
select	@Operator,  @ProgramID, @PartCode, @CustomerCode, @EndingQty

--<Error Handling>
select	@Error = @@Error
if @Error != 0 begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'Error creating ending order.'
		print	'Error: (' + Convert ( varchar, @Error ) + ')'
	end
--</Debug>
	rollback tran AddEndingOrder
	return -100
end
--</Error Handling>

--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate ( ) ) ) + ' ms'
end
--</Debug>
GO
