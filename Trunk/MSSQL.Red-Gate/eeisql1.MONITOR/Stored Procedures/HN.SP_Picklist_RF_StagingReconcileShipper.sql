SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
begin tran

exec [HN].[SP_Picklist_RF_StagingReconcileShipper] 105456,0
rollback
*/

CREATE procedure [HN].[SP_Picklist_RF_StagingReconcileShipper]
(	@ShipperID integer,
	@Result integer = 0 output)
as
BEGIN

SET nocount ON
set	@Result = 999999
DECLARE @ProcName  sysname

set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test


--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer


set nocount on
--	1. Ensure shipper is not closed.
if exists (
	select	1
	  from	shipper
	 where	id = @ShipperID and
		( status = 'C' or status = 'Z' ) )
		return -2

--	2. Ensure shipper exists.
if not exists (
	select	1
	  from	shipper
	 where	id = @ShipperID )
	return -1

--	3. Ensure no invalid parts are staged to this shipper.
if exists (
	select	1
	  from	object
	 where	shipper = @ShipperID and
		type is null and
		part not in (
		select	part_original
		  from	shipper_detail
		 where	shipper = @ShipperID ) )
		return -3

--	4. Reconcile quantity and standard quantity staged to shipper.
--<Tran Required=Yes AutoCreate=Yes>
	DECLARE	@TranCount SMALLINT
	SET	@TranCount = @@TranCount
	IF	@TranCount = 0 
		BEGIN TRANSACTION @ProcName
	ELSE
		SAVE TRANSACTION @ProcName
--</Tran>

update	
	sd
set
	sd.qty_packed = coalesce(box.qty_packed, 0)
,	sd.alternative_qty = coalesce(box.alternative_qty, 0)
,	sd.boxes_staged = coalesce(box.boxes_staged, 0)
from
	dbo.shipper_detail sd
	left join (
		select	sum ( o.quantity ) as qty_packed
			,	sum ( o.std_quantity ) as alternative_qty
			,	count ( 1 ) as boxes_staged
			,	o.part
			,	isnull ( o.suffix, 0 ) as suffix
		from	
			dbo.object o
		where	
			o.type is null and
			o.shipper = @ShipperID
		group by 
			o.part
		,	isnull ( o.suffix, 0 ) ) as box
	on  sd.part_original = box.part
	and isnull ( sd.suffix, 0 ) = box.suffix
where	
	sd.shipper = @ShipperID

--	5. Refresh shipper container information.
delete	shipper_container
 where	shipper = @ShipperID


insert	shipper_container (
		shipper,
		container_type,
		quantity,
		weight,
		group_flag )
select	shipper,
	package_type,
	count ( 1 ),
	null,
	null
  from	object
 where	shipper = @ShipperID and
	package_type > ''
group by shipper,
	package_type

--	6. Set boxes and pallets staged fields in shipper detail and shipper header.
update	shipper
   set	staged_objs = (
   		select	count ( 1 )
		  from	object box
		 where	box.type is null and
				box.shipper = @ShipperID ),
	staged_pallets = (
		select	count ( 1 )
		  from	object pallet
		 where	pallet.type = 's' and
			pallet.shipper = @ShipperID )
 where	id = @ShipperID

--	7. Set the status of the shipper to (S)taged or (O)pen.
update	shipper
   set	status = isnull ( (
   		select	max ( 'O' )
		  from	shipper_detail sd
			left outer join order_detail od on sd.order_no = od.order_no and
				sd.part_original = od.part_number and
				isnull ( sd.suffix, 0 ) = isnull ( od.suffix, 0 )
			left outer join part_packaging pp on pp.part = sd.part_original
				and pp.code = od.packaging_type
		 where	sd.shipper = @ShipperID and
		 	(	(	isnull ( alternative_qty, 0 ) < qty_required and
					isnull ( pp.stage_using_weight, 'N' ) <> 'Y' ) or
				(	isnull ( gross_weight, 0 ) < qty_required and
					pp.stage_using_weight = 'Y' ) ) ), 'S' )
 where	id = @ShipperID

--	8. Set quantity original and quantity required on Quick, RTV, or Outside shippers.
update	shipper_detail
   set	qty_required = qty_packed,
   	qty_original = qty_packed
  from	shipper
 where	shipper = @ShipperID and
 	id = shipper and
 	( shipper.type = 'V' or shipper.type = 'Q' or shipper.type = 'O' )

--	9. Remove shipper detail with no quantity required.
delete	shipper_detail
where	qty_required = 0
  
--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION @ProcName
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Reconciled.
SET	@Result = 0
RETURN	@Result
END
GO
