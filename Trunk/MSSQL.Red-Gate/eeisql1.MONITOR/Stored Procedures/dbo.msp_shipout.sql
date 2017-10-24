SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[msp_shipout]
	@shipper INTEGER,
	@invdate DATETIME = NULL
AS
SET ANSI_WARNINGS OFF
--set nocount ON
---------------------------------------------------------------------------------------
--	This procedure performs a ship out on a shipper.
--
--	Modifications:	01 MAR 1999, Harish P. Gubbi	Original.
--			08 JUL 1999, Eric E. Stimpson	Reformatted.
--			04 AUG 1999, Eric E. Stimpson	Removed operator and pronumber from parameters.
--			11 AUG 1999, Eric E. Stimpson	Modified audit_trail generation to include pallets.
--			26 SEP 1999, Eric E. Stimpson	Added where condition to #3 to prevent data loss.
--			06 JAN 2000, Eric E. Stimpson	Add EDI shipout procedure.
--			08 JAN 2000, Eric E. Stimpson	Add result set for success.
--			25 JAN 2000, Eric E. Stimpson	Rewrite invoice number assigning to prevent lockup.
--			11 MAY 2000, Chris B. Rogers	added 6a.
--			08 AUG 2002, Harish G P		Included date as an argument and used the same in the script
--			08 AUG 2002, Harish G P		Commented out release dt & no updation on shipper detail
--			02 JAN 2003, Harish G P		Made changes to bill of lading updation
--			25 JUL 2012, Andre S. Boulanger	Added procedure call [dbo].[ftsp_AuditAccumsPerShipper]; Procedure e-mails users in event accum on current shipper is incorrect
--			2  May 2013, Hiran Coello		Prevent make shipout to preceed the date_stamp for a receipt
--			04 MAR 2014, Andre S. Boulanger Update object.shipper for any objects on a pallet that is staged to the shipper where object.shipper != @shipper
--			31 OCT 2016, Andre S. Boulanger - 	8.	Relieve order requirements. ( added check for order_header in this section..users deleting order header causing an issue )
--
--	Parameters:	@shipper	Mandatory
--
--	Returns:	0	success
--			100	shipper not staged
--
--	Process:
--	1.	Declare all the required local variables.
--	1a. Update object.shipper with @shipper for objects on pallet staged to @shipper where object.shipper != @shipper
--	2.	Update shipper header to show shipped status and date and time shipped.
--	3.	Update shipper detail with date shipped and week no. and release date and no.
--	4.	Generate audit trail records for inventory to be relieved.
--	5.	Call EDI shipout procedure.
--	6.	Relieve inventory.
--	6a.	Update part_vendor table for outside processed part
--	7.	Adjust part online quantities for inventory.
--	8.	Relieve order requirements.
--	9.	Close bill of lading.
--	10.	Assign invoice number.
--	11. Call procedure [dbo].[ftsp_AuditAccumsPerShipper]
---------------------------------------------------------------------------------------
/*

	Exec
	msp_shipout  50566, NULL
		
*/
--	1.	Declare all the required local variables.
DECLARE	@returnvalue INTEGER,
				@Result	INTEGER,
	@invoicenumber	INTEGER,
	@cnt		INTEGER,
	@bol		INTEGER,
	@MinNALShipper INTEGER
	
	--<Error Handling>
DECLARE	@ProcReturn INTEGER,
	@ProcResult INTEGER,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	1a.	Update object.shipper with @shipper for objects on pallet staged to @shipper where object.shipper != @shipper
--		This is required due to a process in Alabama where serials are added to a Pallet after the pallet is staged to the shipper; shipper reconciliation does not fix the data issue.

Update
	object
Set
	shipper = @shipper
where
	coalesce(shipper,0) != @shipper
and exists
	(	select 1 
		from 
		object o2 
		where o2.part = 'PALLET' and 
		o2.shipper  = @shipper and 
		o2.serial = object.parent_serial
		)



-- 1(aa) Begin . Determine if this is a NAL shipment out of scheduled order. If true, return -1 [Andre S. Boulanger Fore-Thought, LLC 2011-08-27]
declare
	@OrderNos 
table 
	(	OrderNo int primary key	)
insert
	@OrderNos 
select	
	distinct Order_No 
from 
	shipper_detail 
where 
	shipper = @Shipper


if	exists(	select	1
			from	(	select	object.Serial, FirstTranDT =  Min(date_stamp)
						from	audit_Trail
								join object on audit_Trail.Serial = object.serial
						where	object.shipper = @shipper
						group by object.serial ) SerialsInShipper
			where	FirstTranDT > isnull((select date_shipped from shipper where ID = @shipper ), getdate()) ) begin
		RAISERROR (N'There are serials where Ship date preceed the receipt date.', -- Message text.
           16, -- Severity,
           1 -- State
           )
          return -1
end

if exists 
(	select 1 
	from 
		shipper_detail sd
	join	
		shipper  s on sd.shipper = s.id
	where 
		order_no in (select OrderNo from @OrderNos) and 
		part_original like 'NAL%' and
		status in ('O', 'A', 'S')
	group  by order_no
	having count(1) >1
)
begin
Declare  
	@ShipperDetail table 
( 
	id int not null Identity (1,1) primary key,
	ShipperID int
)
	
insert 
	@ShipperDetail
( 
ShipperID
 )
	
select
	s.id
from	
	dbo.shipper s
join
	shipper_detail sd on s.id = sd.shipper
where
	sd.order_no in  (select OrderNo from @OrderNos) and
	s.status in ('O', 'A', 'S') and
	s.type is NULL
order by 
	ft.fn_DatePart('Year',date_stamp),ft.fn_DatePart('DayofYear',date_stamp), ft.fn_DatePart('Hour',scheduled_ship_time), ft.fn_DatePart('Minute',scheduled_ship_time), ft.fn_DatePart('Second',scheduled_ship_time) , s.id
	
	select	
		@MinNALShipper = ShipperID 
	from		
		@ShipperDetail SD
	where	
		SD.id = 1 
		
		declare	@MinNALShipperString varchar(10)
		select		@MinNALShipperString = convert(varchar(10), @MinNALShipper)
	
	if @MinNALShipper!=@shipper begin
		RAISERROR (N'This NAL Shipper is shipped out of order. Please ship Shipper ID %s.', -- Message text.
           16, -- Severity,
           1, -- State,
           @MinNALShipperString
           )
          return -1
		end
end

--1(a) End

-- 1(b) Begin . Determine if any objects exist that are not 'Approved' or in a 'PREOBJECT' Location. If So, return -1

Declare @ShipmentAlert table
		(	Shipper int,
			Serial int,
			PalletSerial int,
			Part varchar(25),
			Location varchar(25),
			Status varchar(15)
		)

Insert	@ShipmentAlert
	
	Select	object.Shipper,
			Serial,
			coalesce(parent_serial,0),
			object.part,
			object.location,
			object.status
	From	object
	LEFT JOIN
		shipper ON shipper.id = object.shipper
	Where	Part != 'PALLET' and
			(Object.Status != 'A' or Object.location = 'PREOBJECT') and
			shipper = @shipper AND
			COALESCE(shipper.type,'X') != 'V'

if exists ( Select 1 from @ShipmentAlert ) begin

		DECLARE @tableHTMLA  NVARCHAR(MAX) ;

SET @tableHTMLA =
    N'<H1>PreObjects or On Hold Inventory on Shipper</H1>' +
    N'<table border="1">' +
    N'<tr><th>ShipperID</th>' +
    N'<th>Serial</th><th>PalletSerial</th><th>Part</th>' +
    N'<th>Location</th><th>Status</th></tr>' +
    CAST ( ( SELECT td = eo.Shipper, '',
                    td = eo.Serial, '',
                    td = eo.PalletSerial, '',
                    td = eo.Part, '',
                    td = eo.Location, '',
					td = eo.Status
              FROM @ShipmentAlert  eo
            order by 5,1 desc 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients ='aboulanger@fore-thought.com;dwest@empireelect.com', 
	@copy_recipients = 'Mcalix@empireelect.com;Shipping@empireelect.com',
    @subject = N'PreObjects or On Hold Inventory on Shipper', -- nvarchar(255)
    @body = @TableHTMLA, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)
		
		declare		@ShipperString varchar(10)
		select		@ShipperString = convert(varchar(10), @shipper)
		
		RAISERROR (N'Non Approved Inventory or PreObjects Exist on this Shipper %s.', -- Message text.
           16, -- Severity,
           1, -- State,
           @ShipperString
           )
          return -1

		  
		end


--1(b) End

--	2.	Update shipper header to show shipped status and date and time shipped.
--if	@invdate is null 
	select	@invdate = GetDate ()
	
update	shipper
set	status = 'C',
	date_shipped = @invdate,
	time_shipped = @invdate,
	posted = 'N'
where	id = @shipper and
	status = 'S'

if @@rowcount = 0
	Return -1
	


--	3.	Update shipper detail with date shipped and week no. and release date and no.
/*
update	shipper_detail
set	date_shipped = shipper.date_shipped,
	week_no = datepart ( wk, shipper.date_shipped ),
	release_date = order_detail.due_date,
	release_no = order_detail.release_no
from	shipper_detail
	join shipper on shipper_detail.shipper = shipper.id
	left outer join order_detail on shipper_detail.order_no = order_detail.order_no and
		shipper_detail.part_original = order_detail.part_number and
		IsNull ( shipper_detail.suffix, 0 ) = IsNull ( order_detail.suffix, 0 ) and
		order_detail.due_date = (
			select	Min ( od2.due_date )
			from	order_detail od2
			where	shipper_detail.order_no = od2.order_no and
				shipper_detail.part_original = od2.part_number and
				IsNull ( shipper_detail.suffix, 0 ) = IsNull ( od2.suffix, 0 ) )
where	shipper = @shipper
*/

update	shipper_detail
set	date_shipped = shipper.date_shipped,
	week_no = datepart ( wk, shipper.date_shipped )
from	shipper_detail
	join shipper on shipper_detail.shipper = shipper.id
where	shipper = @shipper

--	4.	Generate audit trail records for inventory to be relieved.
insert	audit_trail (
	serial,
	date_stamp,
	type,
	part,
	quantity,
	remarks,
	price,
	salesman,
	customer,
	vendor,
	po_number,
	operator,
	from_loc,
	to_loc,
	on_hand,
	lot,
	weight,
	status,
	shipper,
	unit,
	workorder,
	std_quantity,
	cost,
	custom1,
	custom2,
	custom3,
	custom4,
	custom5,
	plant,
	notes,
	gl_account,
	package_type,
	suffix,
	due_date,
	group_no,
	sales_order,
	release_no,
	std_cost,
	user_defined_status,
	engineering_level,
	parent_serial,
	destination,
	sequence,
	object_type,
	part_name,
	start_date,
	field1,
	field2,
	show_on_shipper,
	tare_weight,
	kanban_number,
	dimension_qty_string,
	dim_qty_string_other,
	varying_dimension_code )
	select	object.serial,
		shipper.date_shipped,
		IsNull ( shipper.type, 'S' ),
		object.part,
		IsNull ( object.quantity, 1),
		(	case	shipper.type
				when 'Q' then 'Shipping'
				when 'O' then 'Out Proc'
				when 'V' then 'Ret Vendor'
				else 'Shipping'
			end ),
		IsNull ( shipper_detail.price, 0 ),
		shipper_detail.salesman,
		destination.customer,
		destination.vendor,
		object.po_number,
		IsNull ( shipper_detail.operator, '' ),
		left(object.location,10),
		left(destination.destination,10),
		part_online.on_hand,
		object.lot,
		object.weight,
		object.status,
		convert ( varchar, @shipper ),
		object.unit_measure,
		object.workorder,
		object.std_quantity,
		object.cost,
		object.custom1,
		object.custom2,
		object.custom3,
		object.custom4,
		object.custom5,
		object.plant,
		shipper_detail.note,
		shipper_detail.account_code,
		object.package_type,
		object.suffix,
		object.date_due,
		shipper_detail.group_no,
		convert ( varchar, shipper_detail.order_no ),
		left(shipper_detail.release_no,15),
		object.std_cost,
		object.user_defined_status,
		object.engineering_level,
		object.parent_serial,
		shipper.destination,
		object.sequence,
		object.type,
		object.name,
		object.start_date,
		object.field1,
		object.field2,
		object.show_on_shipper,
		object.tare_weight,
		object.kanban_number,
		object.dimension_qty_string,
		object.dim_qty_string_other,
		object.varying_dimension_code
	from	object
		join shipper on shipper.id = @shipper
		LEFT OUTER JOIN shipper_detail ON shipper_detail.shipper = @shipper AND
			OBJECT.part = shipper_detail.part_original AND
			COALESCE ( OBJECT.suffix, (
				SELECT	MIN ( sd.suffix )
				FROM	shipper_detail sd
				WHERE	sd.shipper = @shipper AND
					object.part = sd.part_original ), 0 ) = ISNULL ( shipper_detail.suffix, 0 )
		JOIN destination ON shipper.destination = destination.destination
		LEFT OUTER JOIN part_online ON OBJECT.part = part_online.part
	WHERE	object.shipper = @shipper

--	5.	Call EDI shipout procedure.
EXECUTE edi_msp_shipout @shipper

--	6.	Relieve inventory.
DELETE	object
FROM	object
	JOIN shipper ON object.shipper = shipper.id
WHERE	object.shipper = @shipper AND
	ISNULL ( shipper.type, '' ) <> 'O'

UPDATE	object
SET	location = shipper.destination,
	destination = shipper.destination,
	status = 'P'
FROM	object
	JOIN shipper ON object.shipper = shipper.id
WHERE	object.shipper = @shipper AND
	shipper.type = 'O'

--	6a.	Update part_vendor table for outside processed part
UPDATE	part_vendor
SET	accum_shipped = ISNULL(accum_shipped,0) + 
			ISNULL((SELECT	SUM ( object.std_quantity ) 
				FROM	object
				WHERE	object.shipper = @shipper AND
					object.part = pv.part ),0)
FROM	part_vendor pv,
	shipper s,
	destination d
WHERE	s.id = @shipper AND
	s.type = 'O' AND
	d.destination = s.destination AND
	pv.vendor = d.vendor

--	7.	Adjust part online quantities for inventory.
UPDATE	part_online
SET	on_hand = (
		SELECT	SUM ( std_quantity )
		FROM	object
		WHERE	part_online.part = object.part AND
			object.status = 'A' )
FROM	part_online
	JOIN shipper_detail ON shipper_detail.shipper = @shipper AND
		shipper_detail.part_original = part_online.part

--	8.	Relieve order requirements.
IF	EXISTS
		(SELECT
			1
		FROM
			dbo.shipper s
			JOIN customer c ON c.customer = s.customer
			Join shipper_detail sd on sd.shipper = @shipper
			Join order_header oh on oh.order_no = sd.order_no
		WHERE
			s.id = @shipper
			AND ( c.customer LIKE '%NAL%' OR c.customer LIKE '%AUTOLIV%')
			UNION
			SELECT 1 FROM shipper_detail 
			join order_header on order_header.order_no = shipper_detail.order_no
			WHERE shipper_detail.shipper =  @shipper AND shipper_detail.customer_po LIKE 'Spot%' )
-- 2012-10-18 AB: Modified procedure to join on customer in order to pull all destinations for NAL
-- 2013-11-12 AB: Added Autoliv to the condition
-- 2016-10-31 AB: Added check to see if order_header exists

	 BEGIN
	
	DECLARE
		@TranDT DATETIME
	
	--- <Error Handling>
	DECLARE
		@CallProcName sysname
	,	@TableName sysname
	,	@ProcName sysname

	SET	@ProcName = USER_NAME(OBJECTPROPERTY(@@procid, 'OwnerId')) + '.' + OBJECT_NAME(@@procid)  -- e.g. dbo.usp_Test
	--- </Error Handling>

	--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
	DECLARE
		@TranCount SMALLINT

	SET	@TranCount = @@TranCount
	IF	@TranCount = 0 BEGIN
		BEGIN TRAN @ProcName
	END
	ELSE BEGIN
		SAVE TRAN @ProcName
	END
	SET	@TranDT = COALESCE(@TranDT, GETDATE())
	--- </Tran>

	--- <Call>	
	SET	@CallProcName = 'dbo.usp_Shipping_ShipoutReleiveOrders'
	EXECUTE
		@ProcReturn = dbo.usp_Shipping_ShipoutReleiveOrders
		@ShipperID = @shipper
	,	@TranDT = @TranDT OUT
	,	@Result = @ProcResult OUT
	,	@Debug = 0
	
	SET	@Error = @@Error
	IF	@Error != 0 BEGIN
		SET	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END
	IF	@ProcReturn != 0 BEGIN
		SET	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END
	IF	@ProcResult != 0 BEGIN
		SET	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END
	--- </Call>
	
	IF	@TranCount = 0 BEGIN
		COMMIT TRAN @ProcName
	END
END
ELSE BEGIN
	EXECUTE @returnvalue = msp_update_orders @shipper

	IF @returnvalue < 0
		RETURN @returnvalue
END

--	9.	Close bill of lading.
SELECT	@bol = bill_of_lading_number
FROM	shipper
WHERE	id = @shipper

SELECT	@cnt = COUNT(1)
FROM	shipper
WHERE	bill_of_lading_number = @bol AND
	(ISNULL(status,'O') <> 'C' OR ISNULL(status,'S') <> 'C')

IF ISNULL(@cnt,0) = 0
	UPDATE	bill_of_lading
	SET	status = 'C'
	FROM	bill_of_lading
		JOIN shipper ON shipper.id = @shipper AND
		bill_of_lading.bol_number = shipper.bill_of_lading_number

--	10.	Assign invoice number.
BEGIN TRANSACTION -- (1T)

UPDATE	parameters
SET	next_invoice = next_invoice + 1

SELECT	@invoicenumber = next_invoice - 1
FROM	parameters

WHILE EXISTS (
	SELECT	invoice_number
	FROM	shipper
	WHERE	invoice_number = @invoicenumber )
BEGIN -- (1B)
	SELECT	@invoicenumber = @invoicenumber + 1

END -- (1B)

UPDATE	parameters
SET	next_invoice = @invoicenumber + 1

UPDATE	shipper
SET	invoice_number = @invoicenumber
WHERE	id = @shipper

EXEC dbo.ftsp_AuditAccumsPerShipper @shipper

COMMIT TRANSACTION -- (1T)

SELECT 0
RETURN 0















GO
