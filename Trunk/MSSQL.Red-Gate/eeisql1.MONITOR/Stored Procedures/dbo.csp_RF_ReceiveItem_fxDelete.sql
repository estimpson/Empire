SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[csp_RF_ReceiveItem_fxDelete]
(	@PONumber integer,
	@PartNumber varchar(25),
	@Operator varchar (5),
	@Quantity numeric (20,6),
	@Objects integer,
	@Shipper varchar (20) = null,
	@LotNumber varchar (20) = null,
	@SerialNumber integer = null output,
	@Result integer output )
as
/*
Arguments:
@PONumber	The po number to check the accum against.
@PartNumber	The partnumber to use in the check.
@Operator	The operator performing the operation.
@Quantity	The quantity to check.
@Objects	The number of objects to create.
@Shipper	The shipper on which the receipt came in on.
@LotNumberNumber	Lot number.
@SerialNumber	The serial number of the object created during the receipt.
@Result		Output result.

Result set:
None

Return values:
0	Success
-1xxx	Error returned by Accum Item receipt procedure.
-2xxx	Error returned by Line Item receipt procedure.

Description:

Example:

Author:
Chris Rogers
Copyright © 2004 Fore-Thought, LLC

Process:
*/

--	.	Get the PO type and call the appropriate procedure.
if exists
(	select	1
	from	po_header
	where	po_number = @PONumber and
		release_control = 'A' )
begin
	exec csp_RF_ReceiveAccum 	@PONumber,	
					@PartNumber,
					@Operator,
					@Quantity,
					@Objects,
					@Shipper,
					@LotNumber,
					@SerialNumber output,
					@Result output
	if @Result != 0
		select @Result = @Result + 1000
end
else
begin
	exec csp_RF_ReceiveLineItem	@PONumber,	
					@PartNumber,
					@Operator,
					@Quantity,
					@Objects,
					@Shipper,
					@LotNumber,
					@SerialNumber output,
					@Result output
	if @Result != 0
		select @Result = @Result + 1000
end

return @Result

GO
