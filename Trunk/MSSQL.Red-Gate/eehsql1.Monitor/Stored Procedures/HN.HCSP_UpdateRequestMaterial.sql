SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [HN].[HCSP_UpdateRequestMaterial]
	(
		@Serial int, 
		@Toloc varchar(10) = NULL, 
		@Result integer = 0 output,
--<Debug>
		@Debug integer = 0
--</Debug>
) 
AS


--Request 3104 Solicitado por Milton
--Anteriormente el procedimiento le habian agregado un 1 en el nombre del procedimiento 
--31-05-2018
	
	SET NOCOUNT ON;
	SET @Result = 999999
    -- Insert statements for procedure here
	--<Tran Required=Yes AutoCreate=Yes>
	DECLARE	@TranCount SMALLINT

	DECLARE @ProcReturn integer, @ProcResult integer
	DECLARE @RowCount integer
	DECLARE @Error INT = 0

	declare	@Part varchar(25),
			@Qty  int,
			@Maq varchar(50),
			@Commodity varchar(50)

	select	@Part = object.Part, @Qty=quantity,
			@Commodity = part.commodity
	from	object with (readuncommitted)
			join part (readuncommitted) on object.part= part.part
	where	serial= @Serial


	--Pokayoke de Barriles para Delivery 
	if	exists(select	1 from	location where	code = @Toloc and group_no ='CORTE-KOMAX') 
			and upper(@Commodity ) = 'WIRE'  begin
	
		select @Maq = Replace(@Toloc,'W','')	

		if (	select count(*) 
				from	eeh.dbo.object Obj with (readuncommitted) 
						inner join eeh.dbo.part part on Obj.part=part.part 
				where location in (@Maq,@Maq+'W') and part.commodity='WIRE' ) > 5  begin 
				set	@Result = 102004
				--	rollback tran KITBuilding_DeliverSerial
					RAISERROR ('Favor retirar Barriles con Disposicion.', 16, 1, @Maq)
					return	@Result	
		end
	end 
----

	--Validar hay Request 
	if	not exists(	select	1
					from	Sistema.dbo.CAL_Piece_Request_Material Material with (readuncommitted)
							join object on Material.Part = object.part 
									and object.serial = @Serial
									and Received = 0
									and machine like '%' + REPLACE(Replace(UPPER(@Toloc),'W',''),'T','') + '%') begin
			set	@Result = 102004
			--rollback tran HCSP_UpdateRequestMaterial
			RAISERROR ('La serie %i no esta en el pedido de %s, o ya transfirio el Requerimiento.', 16, 1, @Serial, @Toloc)
			return	@Result
	end							

	SET		@TranCount = @@TranCount

	IF	@TranCount = 0 
		BEGIN TRANSACTION HCSP_UpdateRequestMaterial
	ELSE
		SAVE TRANSACTION HCSP_UpdateRequestMaterial
	--<Error Handling>


	--Hacer Update de Delivery/Receiving
	if	exists(select	1 from	eeh.dbo.location with (readuncommitted)
						  where	code = @Toloc
						 and group_no ='CORTE-KOMAX' and code like '%w%')
		begin
					update	Sistema.dbo.CAL_Piece_Request_Material
						set		QtyDelivery = isnull(QtyDelivery,0) + @Qty,
								Received = case when isnull(QtyDelivery,0) + @Qty >= Qty then 1 else 0 end,
								CloseDT = case when isnull(QtyDelivery,0) + @Qty >= Qty then GETDATE() else null end
						where	machine = @Toloc  
								and part = @Part
								and Received = 0
				
					select	@Error = @@error,
						@RowCount = @@rowcount
						if	@Error != 0
						begin
							set	@Result = 20003
							rollback tran	HCSP_UpdateRequestMaterial
							raiserror( 'No se logro actualizar Los Estados',16,1)
							return @Result
						end
		end
	ELSE
		BEGIN
				update	Sistema.dbo.CAL_Piece_Request_Material
						set		QtyDelivery = isnull(QtyDelivery,0) + @Qty,
								Received = case when isnull(QtyDelivery,0) + @Qty >= Qty then 1 else 0 end,
								CloseDT = case when isnull(QtyDelivery,0) + @Qty >= Qty then GETDATE() else null end
						where	machine = SUBSTRING(@Toloc,2,LEN(@Toloc)) + 'W'  
								and part = @Part
								and Received = 0
			
					select	@Error = @@error,
						@RowCount = @@rowcount
						if	@Error != 0
						begin
							set	@Result = 20003
							rollback tran	HCSP_UpdateRequestMaterial
							raiserror( 'No se logro actualizar Los Estados',16,1)
							return @Result
						end
		END


	



--	II.	Success.
--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction HCSP_UpdateRequestMaterial
end
--</CloseTran Required=Yes AutoCreate=Yes>

set	@Result = 0
return	@Result

GO
