SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure [HN].[RLSP_CreateWorkOrderForPrePotting]
as
DECLARE @RC int, @Operator varchar(10), @TopPart varchar(25)
DECLARE @Part varchar(25), @Machine varchar(10), @ShiftDate datetime
DECLARE @Shift char(1), @QtyRequired numeric(20,6), @NewWOID int
DECLARE @NewWODID int, @Result int, @Contenedor int

BEGIN TRAN

	--Get next container from the actual
	SELECT	@ShiftDate = Min(FechaEEH)
	FROM	Sistema.dbo.CP_Contenedores
	WHERE	FechaEEH > (SELECT FechaEEH FROM Sistema.dbo.CP_Contenedores WHERE Activo = 1)

	--Get the Container ID
	SELECT	@Contenedor = ContenedorID
	FROM	Sistema.dbo.CP_Contenedores
	WHERE	FechaEEH = @ShiftDate 

	UPDATE	WOHeaders
	SET	Status = 1
	FROM	WOHeaders 
		JOIN WOShift ON WOHeaders.ID = WOShift.WOID
		JOIN WODetails on WODetails.woid = WOHeaders.ID
	WHERE	ShiftDate < @ShiftDate
		AND WODetails.Part like 'PRE-%'
		and WOHeaders.Status = 0
		--and ( (datepart(wk, getdate() ) = 5 and Toppart in (   select  toppart
		--						    from    ft.xrt xrt2
		--							    join part_machine on xrt2.childpart = part_machine.part
		--						    where   machine = 'moldeo' ))
		--    or (datepart(wk, getdate() ) = 6 and Toppart in (   select  toppart
		--						    from    ft.xrt xrt2
		--							    join part_machine on xrt2.childpart = part_machine.part
		--						    where   machine <> 'moldeo' )))

	--Declare a Cursor for parts don't have WorkOrder
	DECLARE Parts_Release CURSOR LOCAL
	FOR	
	SELECT	xrt.TopPart, xrt.ChildPart, Revision1, Part_Machine.Machine
	FROM	FT.XRT XRT 
			INNER JOIN Sistema.dbo.CP_Revisiones_Produccion  CP_Revisiones_Produccion
				ON Xrt.TopPart = CP_Revisiones_Produccion.Part
			INNER JOIN Part_Machine 
				ON Xrt.ChildPart = Part_Machine.Part
			LEFT JOIN (SELECT	DISTINCT WODetails.TopPart, WODetails.Part
								FROM	WODetails INNER JOIN WOShift 
										ON WODetails.WOID = WOShift.WOID
								WHERE	WOShift.ShiftDate = @ShiftDate ) WOs
				ON XRT.TopPart = WOs.TopPart and XRT.ChildPart = WOs.Part
	WHERE	CP_Revisiones_Produccion.ContenedorID = @Contenedor and WOs.Part is null  
			and LEFT(Xrt.ChildPart,4) IN ('PRE-') and Revision1 IS NOT null
		--and ( (datepart(wk, getdate() ) = 5 and CP_Revisiones_Produccion.Part in (  select  toppart
		--									    from    ft.xrt xrt2
		--										    join part_machine on xrt2.childpart = part_machine.part
		--									    where   machine = 'moldeo' ))
		--	or (datepart(wk, getdate() ) = 6 and CP_Revisiones_Produccion.Part in (  select  toppart
		--									    from    ft.xrt xrt2
		--										    join part_machine on xrt2.childpart = part_machine.part
		--									    where   machine <> 'moldeo' )))

	OPEN Parts_Release

	FETCH NEXT FROM	Parts_Release
	INTO @TopPart, @Part, @QtyRequired, @Machine

	SET @Shift = 'A'

	declare	@Status int; set @Status = dbo.udf_GetStatusValue ('WOHeader', 'Active')
	declare	@Type int; set @Type = dbo.udf_GetTypeValue ('WOHeader', 'Firm') | dbo.udf_GetTypeValue ('WOHeader', 'Weekly')

	WHILE @@FETCH_STATUS = 0
	BEGIN

		EXECUTE @RC = [FT].[ftsp_ProdControl_NewJob] 
		   'mon'
		  ,@TopPart
		  ,@Part
		  ,@Machine
		  ,@ShiftDate
		  ,@Shift
		  ,@QtyRequired
		  ,@Status
		  ,@Type
		  ,@NewWOID OUTPUT
		  ,@NewWODID OUTPUT
		  ,@Result OUTPUT

		FETCH NEXT FROM	Parts_Release
		INTO @TopPart, @Part, @QtyRequired, @Machine
	END

	CLOSE Parts_Release
	DEALLOCATE Parts_Release


commit tran
GO
