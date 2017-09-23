SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ProTransASN_Generate]
(	@ShipperID int = null,
	@Days int = 7,
	@Sent char (1) = null)
/*
begin transaction
execute	FT.ftsp_ProTransASN_Generate

execute	FT.ftsp_ProTransASN_Generate
	@ShipperID = 28667

execute	FT.ftsp_ProTransASN_Generate
	@ShipperID = 28667,
	@Sent = 'Z'

rollback
*/
as
if	@ShipperID is null begin
	select	date_shipped, (select count(1) from audit_trail where audit_trail.shipper = convert (varchar, shipper.id)),type, *
	from	shipper
	where	type = 'T' and
		date_shipped >= getdate () - @Days

	return
end
else if	@Sent = 'Z' begin
	update	shipper
	set	status = 'Z'
	where	id in (@ShipperID)

	select	date_shipped, (select count(1) from audit_trail where audit_trail.shipper = convert (varchar, shipper.id)),type, *
	from	shipper
	where	type = 'T' and
		date_shipped >= getdate () - @Days

	return
end
else	begin
	select	ProTransASNFile = convert (char (2), SiteID) +
		convert (char (30), CustomerID) +
		convert (char(25), PartNumber) +
		convert (char(20), MasterPalletID) +
		convert (char(25), CartonSerial) +
		convert (char(12), QuantityToReceive) +
		convert (char (15), LotID) +
		convert (char (30), PONumber)
	from	
	(
	select	SiteID = 'A9',
		CustomerID = '15986',
		PartNumber = part.cross_ref,
		MasterPalletID = isnull (nullif (audit_trail.parent_serial, 0), audit_trail.serial),
		CartonSerial = audit_trail.serial,
		QuantityToReceive = convert (int, audit_trail.quantity),
		LotID = substring (audit_trail.part, 9, 5),
		PONumber = audit_trail.shipper
	from	audit_trail
		join part on audit_trail.part = part.part
	where	audit_trail.part != 'PALLET' and
		audit_trail.shipper = convert (varchar, @ShipperID) and
		audit_trail.type = 'T' and
		audit_trail.shipper > '' and
		audit_trail.to_loc = 'ELPASO'
	) ProTransASN
	order by
		MasterPalletID,
		CartonSerial

	return
end
GO
