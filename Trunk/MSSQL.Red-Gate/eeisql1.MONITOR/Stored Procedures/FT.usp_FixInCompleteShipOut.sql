SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [FT].[usp_FixInCompleteShipOut] (@shipper INT = NULL, @DateStamp DATETIME, @partNumber VARCHAR(25), @LocationCode VARCHAR(25) = NULL)
AS BEGIN


--Exec FT.usp_FixInCompleteShipOut 116726, '2018-03-02', 'NALC274-ASA01', 'ALA-DMCAGE'

--Clear Object Historical Data
--Select * from [HistoricalData].dbo.object_historical
DELETE FROM [HistoricalData].dbo.object_historical
WHERE Time_stamp >= @DateStamp AND Serial IN 
( 
SELECT  object.serial FROM object 
OUTER APPLY ( SELECT TOP 1 serial FROM audit_trail WHERE type = 'S' AND audit_trail.serial = object.serial AND shipper = @shipper ) atShipout
WHERE location LIKE '%'+@LocationCode+'%' AND part!='PALLET' AND   part = @partNumber    AND COALESCE(atShipout.serial,-1)!=dbo.object.serial


)
--Select *  FROM [HistoricalData].dbo.object_historical_daily
DELETE FROM [HistoricalData].dbo.object_historical_daily
WHERE Time_stamp >= @DateStamp AND Serial IN 
( 
SELECT  object.serial FROM object 
OUTER APPLY ( SELECT TOP 1 serial FROM audit_trail WHERE type = 'S' AND audit_trail.serial = object.serial AND shipper = @shipper ) atShipout
WHERE location LIKE '%'+@LocationCode+'%' AND part!='PALLET'  AND part = @partNumber     AND COALESCE(atShipout.serial,-1)!=dbo.object.serial


)

--Associate Shipper to objects
UPDATE OBJECT 
SET
	Shipper =  @shipper
--Select * from Object
WHERE
	serial IN ( 
SELECT  object.serial FROM object 
OUTER APPLY ( SELECT TOP 1 serial FROM audit_trail WHERE type = 'S' AND audit_trail.serial = object.serial AND shipper = @shipper ) atShipout
WHERE location LIKE '%'+@LocationCode+'%' AND part!='PALLET'  AND part = @partNumber    AND COALESCE(atShipout.serial,-1)!=dbo.object.serial


)



--Create Audit_trail shipout records

INSERT	audit_trail (
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
	
	
	SELECT	object.serial,
		@DateStamp,
		ISNULL ( shipper.type, 'S' ),
		object.part,
		ISNULL ( object.quantity, 1),
		(	CASE	shipper.type
				WHEN 'Q' THEN 'Shipping'
				WHEN 'O' THEN 'Out Proc'
				WHEN 'V' THEN 'Ret Vendor'
				ELSE 'Shipping'
			END ),
		ISNULL ( shipper_detail.price, 0 ),
		shipper_detail.salesman,
		destination.customer,
		destination.vendor,
		object.po_number,
		ISNULL ( shipper_detail.operator, '' ),
		LEFT(object.location,10),
		LEFT(destination.destination,10),
		part_online.on_hand,
		object.lot,
		object.weight,
		object.status,
		CONVERT ( VARCHAR, @shipper ),
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
		CONVERT ( VARCHAR, shipper_detail.order_no ),
		LEFT(shipper_detail.release_no,15),
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
	FROM	object
		JOIN shipper ON shipper.id = @shipper
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

	--Fix Shipper_detail

	UPDATE Shipper_detail SET qty_packed = at.at_Qty
FROM dbo.shipper_detail
OUTER APPLY 

( SELECT SUM(quantity) at_Qty, part FROM audit_trail WHERE type = 'S' AND shipper =  CONVERT(VARCHAR(25), shipper_detail.shipper) AND dbo.audit_trail.part =  part_original GROUP BY part ) at
WHERE 
			shipper_detail.qty_packed != at.at_Qty   AND shipper = @shipper

	--Delete Objects 

	DELETE Object WHERE shipper =  @shipper
	

END


GO
