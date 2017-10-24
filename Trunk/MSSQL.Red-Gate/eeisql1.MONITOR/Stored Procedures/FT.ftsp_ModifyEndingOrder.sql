SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ModifyEndingOrder] (
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
Modifys an Ending Orders.

Example:
execute	FT.ftsp_ModifyEndingOrder
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
--		C.	PartCode-CustomerCode must exist.
--		D.	Quantity must be zero or more.
--	II.	Modify ending order.
*/

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	print	'ModifyEndingOrder START.   ' + Convert ( varchar (50), @StartDT )
	select	@ProcStartDT = GetDate ( )
end
--</Debug>

--<Tran>
if @@TranCount = 0 begin
	begin transaction ModifyEndingOrder
end
save transaction ModifyEndingOrder
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
--		C.	PartCode-CustomerCode must exist.
--<Debug>
if @Debug & 1 = 1 begin
	print	'	C.	PartCode-CustomerCode must exist.'
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

--		D.	Quantity must be zero or more.
--<Debug>
if @Debug & 1 = 1 begin
	print	'	D.	Quantity must be zero or more.'
end
--</Debug>
if IsNull ( @EndingQty, -1 ) < 0 begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'Quantity must be zero or more.'
	end
--</Debug>
	rollback tran ModifyEndingOrder
	return -100
end

--	II.	Modify ending order.
--<Debug>
if @Debug & 1 = 1 begin
	print	'II.	Modify ending order.'
end
--</Debug>
update	EndingOrders
set	EndingQty = @EndingQty
where	Operator = @Operator and
	ProgramID = @ProgramID and
	PartCode = @PartCode and
	CustomerCode = @CustomerCode

--<Error Handling>
select	@Error = @@Error
if @Error != 0 begin
--<Debug>
	if @Debug & 1 = 1 begin
		print	'Error modifying ending order.'
		print	'Error: (' + Convert ( varchar, @Error ) + ')'
	end
--</Debug>
	rollback tran ModifyEndingOrder
	return -100
end
--</Error Handling>

--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate ( ) ) ) + ' ms'
end
--</Debug>
GO
