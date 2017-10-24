SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[ftsp_RFPutAway_ProgressInquiry]
(	@SerialPutAway int)
as
/*
execute	FT.ftsp_RFPutAway_ProgressInquiry
	@SerialPutAway = 5522958
*/
declare	@SerialFirstBox int,
	@QtyContainer int,
	@QtyPutAway int,
	@TranLocation varchar (10)

select	@QtyContainer = count (Quantity),
	@SerialFirstBox = min (Serial)
from	FT.CommonSerialShipLog
where	Shipper =
	(	select	max (Shipper)
		from	FT.CommonSerialShipLog
		where	Serial = @SerialPutAway or
			PalletSerial = @SerialPutAway)

select	@TranLocation = to_loc
from	audit_trail
where	serial = @SerialFirstBox and
	type = 'R'

select	@QtyPutAway = @QtyContainer -
	coalesce (
	(	select	count (std_quantity)
		from	object
		where	location = @TranLocation), 0)

select	TranLocation = @TranLocation,
	QtyContainer = @QtyContainer,
	QtyPutAway = @QtyPutAway
GO
