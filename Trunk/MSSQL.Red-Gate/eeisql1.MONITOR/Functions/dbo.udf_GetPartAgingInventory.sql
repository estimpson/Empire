SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




Create FUNCTION [dbo].[udf_GetPartAgingInventory]
(
	
)
RETURNS @Objects TABLE
(
	Serial INT
,	Part VARCHAR(25)
,	PartName VARCHAR(100)
,	PartType VARCHAR(25)
,	Quantity NUMERIC (20, 6)
,	UOM VARCHAR(10)
,	UnitCost NUMERIC(20,6)
,	ExtendedCost NUMERIC(20,6)
,	BreakoutSerial INT NULL
,	FirstDT DATETIME NULL
,	Agingperiod VARCHAR(25)
)
AS
BEGIN
--- <Body>
	INSERT
		@Objects
	(
		Serial
	,	part
	,	PartName
	,	PartType
	,	Quantity
	,	UOM
	,	UnitCost
	,	ExtendedCost
	,	BreakoutSerial
	)
	SELECT
		Serial = o.serial
	,	Part = MIN(o.part)
	,	PartName =  MIN(p.name)
	,	PartType = MIN( CASE WHEN p.type IN ( 'T', 'W') THEN 'WIP'
											 WHEN p.type = 'R' THEN 'RAW'
											 WHEN p.type = 'F' THEN 'FINISH'
											 ELSE 'OTHER'
											 END)
	,	Quantity = MIN(o.std_quantity)
	,	UOM = MIN(piv.standard_unit)
	,	UnitCost =  MIN(COALESCE(ps.cost_cum,0))
	,	ExtendedCost = MIN(COALESCE(ps.cost_cum,0)*o.std_quantity)
	,	BreakoutSerial = MIN(CONVERT (INT, Breakout.from_loc))
	FROM
		dbo.object o
	JOIN
		dbo.part p ON p.part =o.part
	JOIN
		dbo.part_standard ps ON ps.part = o.part
	JOIN
		dbo.part_inventory piv ON piv.part = o.part
		LEFT JOIN audit_trail BreakOut ON
			o.serial = BreakOut.serial
			AND
				Breakout.type = 'B' AND
				ISNUMERIC(REPLACE(REPLACE(Breakout.from_loc, 'D', 'X'), 'E', 'Z')) = 1 
		WHERE o.Part != 'PALLET' AND
						o.std_quantity >0 
	--WHERE
	--	o.part = @Part
	--	AND
	--		o.Status = 'A'
	GROUP BY
		o.serial

		DECLARE @AuditTrailBreakOuts TABLE
		(	Serial INT,
			BreakOutSerial  INT
		)
		
		INSERT @AuditTrailBreakOuts
		        ( Serial, BreakOutSerial )
		
		SELECT
					Serial
				,	BreakoutSerial = MIN(CONVERT(INT, Breakout.from_loc))
				FROM
					audit_trail BreakOut
				WHERE
					type = 'B'
					AND
						part != 'PALLET'
					AND
						serial IN (SELECT BreakoutSerial FROM @Objects WHERE BreakoutSerial > 0)
					AND
						ISNUMERIC(REPLACE(REPLACE(Breakout.from_loc, 'D', 'X'), 'E', 'Z')) = 1 
				GROUP BY
					serial
	
	WHILE
		@@rowcount > 0 BEGIN
		UPDATE
			o
		SET
			BreakoutSerial = Breakout.BreakoutSerial
		FROM
			@Objects o
			JOIN
			(
				SELECT * FROM @AuditTrailBreakOuts
			) Breakout ON
			o.BreakoutSerial = Breakout.Serial
	END

	DECLARE @AuditTrailInventoryOrigin TABLE

	(	Serial INT,
		[start_date] DATETIME,
		date_stamp DATETIME
	)

	INSERT @AuditTrailInventoryOrigin
	        ( Serial, start_date, date_stamp )

	SELECT 
		Serial,
		[start_date],
		date_stamp
	FROM
		dbo.audit_trail
	WHERE 
		[type] IN ('A', 'R', 'J') AND (serial IN (SELECT Serial FROM @Objects) OR Serial IN (SELECT BreakoutSerial FROM @Objects))


	UPDATE
		@Objects
	SET
		FirstDT = (SELECT MIN(COALESCE(start_date, date_stamp)) FROM @AuditTrailInventoryOrigin at Where at.serial = COALESCE (o.BreakoutSerial, o.Serial))
	FROM
		@Objects o

	UPDATE
		@Objects
	SET
		Agingperiod =
			CASE WHEN DATEDIFF ( DAY, FirstDT,GETDATE() ) <=30 THEN '(1) 0-30'
					  WHEN  DATEDIFF ( DAY, FirstDT,GETDATE() ) BETWEEN 31 AND 60  THEN '(2) 31-60'
					   WHEN  DATEDIFF ( DAY, FirstDT,GETDATE() ) BETWEEN 61 AND 90  THEN '(3) 61-90'
					   WHEN  DATEDIFF ( DAY, FirstDT,GETDATE() ) BETWEEN 91 AND 180  THEN '(4) 91-180'
					   WHEN  DATEDIFF ( DAY, FirstDT,GETDATE() ) BETWEEN 181 AND 364  THEN '(5) 181-364'
					   WHEN  DATEDIFF ( DAY, FirstDT,GETDATE() ) BETWEEN 365 AND 728  THEN '(6) 365-728'
					   WHEN  DATEDIFF ( DAY, FirstDT,GETDATE() ) > 728 THEN '(7) 729+'
					   ELSE 'UNKOWN'
					   END
	FROM
		@Objects o
--- </Body>

---	<Return>
	RETURN
END



GO
