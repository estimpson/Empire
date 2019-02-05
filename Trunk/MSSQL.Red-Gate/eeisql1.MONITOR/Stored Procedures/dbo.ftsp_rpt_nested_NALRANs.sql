SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[ftsp_rpt_nested_NALRANs]
	@ShipperID INT
,	@OrderNo INT
AS
IF	EXISTS
	(
		SELECT
			*
		FROM
			dbo.shipper s
		WHERE
			s.id = @shipperID
			AND s.destination = '_xxxxNALPARIS'
	) BEGIN
	
	--- <Call>
	DECLARE
		@ProcReturn INT
	,	@ProcName sysname
	,	@CallProcName sysname
	,	@Error INT
	,	@Result INT
	,	@ProcResult INT
	
	SET	@ProcName = USER_NAME(OBJECTPROPERTY(@@procid, 'OwnerId')) + '.' + OBJECT_NAME(@@procid)  -- e.g. dbo.usp_Test
	
	SET	@CallProcName = 'dbo.usp_Shipping_GetNALRans'
	EXECUTE
		@ProcReturn = dbo.usp_Shipping_GetNALRans
		@ShipperID = @shipperID
	,	@OrderNo = @orderNo
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
	
END
ELSE BEGIN
	-- exec  dbo.ftsp_rpt_nested_nalrans 86200, 18558

	DECLARE  
		@OrderDetail TABLE 
	( 
	id INT NOT NULL IDENTITY (1,1) PRIMARY KEY ,
	DueDate DATETIME,
	Quantity NUMERIC (20,6),
	PriorAccum	NUMERIC(20,6),
	Accum NUMERIC(20,6),
	RAN VARCHAR(30) 
	)
		
	INSERT 
		@OrderDetail
	( 
	DueDate ,
	Quantity ,
	RAN
	 )
		
	SELECT
		due_date,
		quantity,
		release_no
	FROM	
		dbo.order_detail
	WHERE
		order_no = @OrderNo
	ORDER BY 
		due_date, release_no, id
			
			
	UPDATE	 od
			SET	Accum = (SELECT SUM(quantity) FROM @OrderDetail WHERE ID <= od.ID ),
				PriorAccum = COALESCE((SELECT SUM(quantity) FROM @OrderDetail WHERE ID < od.ID ),0)
					
	FROM
		@OrderDetail od
			
	 --SELECT	* from		@OrderDetail

	--get Shipper Detail for Order No

	DECLARE  
		@ShipperDetail TABLE 
	( 
	id INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	ShipperID INT,
	DateStamp DATETIME,
	Quantity NUMERIC(20,6),
	PriorAccum NUMERIC (20,6),
	Accum NUMERIC(20,6)
	)
		
	INSERT 
		@ShipperDetail
	( 
	ShipperID ,
	DateStamp ,
	Quantity
	 )
		
	SELECT
		s.id,
		s.date_stamp,
		sd.qty_required
	FROM	
		dbo.shipper s
	JOIN
		shipper_detail sd ON s.id = sd.shipper
	WHERE
		sd.order_no = @OrderNo AND
		s.status IN ('O', 'A', 'S') AND
		s.type IS NULL
	ORDER BY 
		ft.fn_DatePart('Year',date_stamp),ft.fn_DatePart('DayofYear',date_stamp), ft.fn_DatePart('Hour',scheduled_ship_time), ft.fn_DatePart('Minute',scheduled_ship_time), ft.fn_DatePart('Second',scheduled_ship_time) , s.id
		
	UPDATE	 sd
			SET	Accum = (SELECT SUM(quantity) FROM @ShipperDetail WHERE ID <= sd.ID),
				PriorAccum = COALESCE((SELECT SUM(quantity) FROM @shipperDetail WHERE ID < sd.ID),0)
	FROM
		@ShipperDetail sd


	DECLARE
		@ShipperDetailID INT,	
		@ShipperPriorAccum NUMERIC(20,6),
		@ShipperAccum	NUMERIC(20,6),
		@ShipperQty NUMERIC(20,6)
					
	SELECT
		@ShipperDetailID =ShipperID,
		@ShipperPriorAccum = PriorAccum,
		@ShipperAccum = Accum	,
		@ShipperQty = Quantity
	FROM
		@ShipperDetail sd 
	WHERE	
		ShipperID = @shipperID
		
		
	SELECT	
		RAN,
			--ShipperID = @ShipperDetailID,
			--ShipperQty = @ShipperQty,
			--ShipperPriorAccum =@ShipperPriorAccum ,
			--ShipperAccum =@ShipperAccum ,
			--OrderDetailQuantity=od.quantity,
			--OrderDetailPriorAccum=od.priorAccum,
			--OrderDetailAccum=od.accum,
		CalculatedRanQuantity= CASE
			WHEN od.Accum<=@ShipperAccum AND od.PriorAccum>=@ShipperPriorAccum
			THEN od.quantity
			WHEN od.Accum>=@ShipperAccum AND od.PriorAccum<=@ShipperPriorAccum
			THEN @shipperAccum-@ShipperPriorAccum
			WHEN od.Accum>=@ShipperPriorAccum AND od.PriorAccum<=@ShipperPriorAccum
			THEN od.Accum-@ShipperPriorAccum
			WHEN od.Accum>@ShipperPriorAccum AND od.PriorAccum<=@ShipperAccum
			THEN @shipperAccum-od.priorAccum
			ELSE	0
			END
	FROM		
		@OrderDetail od
	WHERE	
		od.Accum>@ShipperPriorAccum AND
		od.PriorAccum<@ShipperAccum
END

GO
