SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SSR_PutSerialOnHold](
		@SSRID varchar(15),
		@SelectSQL varchar(max),		
		@User varchar(10),
		@Note varchar(200),	
		@Part varchar(25),
		@QtyToSort int out,	
		@Result int out) 
as


/*
begin tran

declare	@Result int,
	@Send_Email char(1),
	@User varchar(10),
	@SelectSQL varchar(max),
	@QtyToSort int

set @SelectSQL='select 35059496 union all select 35059498 '

execute	 SSR_PutSerialOnHold
	@SSRID='SSR16-686',
	@SelectSQL=@SelectSQL,		
	@User='MON',
	@Note='Bulb Assembly',	
	@Part='AUT0217-HC00',
	@QtyToSort=@QtyToSort out,	
	@Result=@Result out

SELECT @Result,@QtyToSort

--select *
--from monitor.dbo.object 
--where serial in (35059496)

--select *
--from monitor.dbo.audit_trail 
--where serial in (35059496)

--select * from monitor.dbo.SSR_LogbySerial
--where serial= 35059496

--select * from eehsql1.eeh.dbo.SSR_LogbySerial
--where serial= 35059496

rollback tran

*/
SET nocount on
SET	@Result = 999999

DECLARE	@TranCount smallint,@ProcName sysname
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer

set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

--<Tran Required=Yes AutoCreate=Yes>
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION @ProcName
ELSE
	SAVE TRANSACTION @ProcName
	
declare @TranDT datetime
set @TranDT=getdate()

CREATE TABLE ##SerialToProcess
(
	Serial int
)

declare @InsertSQL varchar(500)
declare @ExecuteSQL varchar(max)

	select @InsertSQL='insert into ##SerialToProcess ( Serial ) '
	set @ExecuteSQL= @InsertSQL + @SelectSQL

	EXECUTE(@ExecuteSQL)
		
	set @Error = @@Error
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error executing function in Temporal Table SerialToProcess', 16, 1)
		rollback tran @ProcName
		return	@Result
	end

if not exists (select	1 from	##SerialToProcess ) begin
	set	@Result = 999999
	RAISERROR ('El archivo seleccionado no posee la data correcta.', 16, 1)
	rollback tran @ProcName
	return	@Result
end

CREATE TABLE #TempDataToProcess
(
	Serial int,
	Status char(1),
	Quantity numeric(18,2),
	Part varchar(25),
	OriginalStatus char(1)
)

	--select	*
	--from	##SerialToProcess SeriesTemp
	--left join	MONITOR.dbo.object ObjectTroy on SeriesTemp.Serial=ObjectTroy.serial 

	if exists (	select	1
					from	##SerialToProcess SeriesTemp
					left join	MONITOR.dbo.object ObjectTroy on SeriesTemp.Serial=ObjectTroy.serial 
					where ObjectTroy.serial is null
				
	)
	begin
		SET	@Result = 999999
		drop table ##SerialToProcess
		ROLLBACK TRAN @ProcName		
		RAISERROR ('En el listado de series ingresado, existen series que ya no estan activas.! ', 16, 1)		
		RETURN	@Result

	end

	insert into #TempDataToProcess (Serial,Status,Quantity,Part,OriginalStatus)
	select	SerialFileUpload.Serial,ObjectTroy.Status,ObjectTroy.Quantity,ObjectTroy.Part,ObjectTroy.status
	from	##SerialToProcess SerialFileUpload
	--where	SerialFileUpload.Serial in ( select serial from eeisql1.Monitor.dbo.object )
	join	dbo.object ObjectTroy on ObjectTroy.serial = SerialFileUpload.Serial

	
	set @Error = @@Error
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error executing function in Temporal Table TempDataToProcess', 16, 1)
		rollback tran @ProcName
		return	@Result
	end
	
	if exists (	select	1
				from	MONITOR.dbo.object ObjectTroy
				join	#TempDataToProcess SeriesTemp on SeriesTemp.Serial=ObjectTroy.serial 
				where	ObjectTroy.shipper is not null
	)
	begin
		SET	@Result = 999999
		drop table #TempDataToProcess
		ROLLBACK TRAN @ProcName
		RAISERROR ('Existen series que ya se encuentran en contenedor de Troy, favor verificar! ', 16, 1)		
		RETURN	@Result

	end

	

		UPDATE dbo.PART_ONLINE 
		SET ON_HAND = ON_HAND - SerialTroy.QtyOnBox 
		from dbo.PART_ONLINE PartOnlineTroy
		join (select QtyOnBox= sum(quantity),part from #TempDataToProcess where Status='A' group by Part ) SerialTroy on SerialTroy.part = PartOnlineTroy.part

		-- Validate the the update of Part_online is not null
		SELECT	@Error = @@Error, @RowCount = @@RowCount
		IF	@Error != 0 begin
			SET	@Result = 300
			ROLLBACK TRAN @ProcName
			RAISERROR ('Error:  Unable to update part online!', 16, 1)
			RETURN	@Result
		END

		if not exists ( select 1 
						from dbo.PART_ONLINE
						where part in (select distinct part from #TempDataToProcess )  )
		begin 
			insert into  dbo.PART_ONLINE (part,on_hand)
			select QtyOnBox= sum(quantity),part 
			from #TempDataToProcess 
			where	Status='A'
					and part not in (select part from Monitor.dbo.PART_ONLINE) 
			group by Part

			SELECT	@Error = @@Error
			IF	@Error != 0 begin
				SET	@Result = 200
				ROLLBACK TRAN @ProcName
				RAISERROR ('Error:  Unable to update part online!', 16, 1)
				RETURN	@Result
			END
		end

		--Update the Object Table Troy with new info.
			UPDATE	dbo.Object
			SET		Last_date = @TranDT, 
					Operator = @User, 
					Status = 'H', 
					Note = @Note, 
					user_defined_status = 'On Hold', 
					Last_Time = @TranDT,
					custom2=@SSRID
			from dbo.Object ObjectTroy
			join #TempDataToProcess SerialProcess on SerialProcess.Serial= ObjectTroy.serial
		

			SELECT	@Error = @@Error
			IF	@Error != 0 begin
				SET	@Result = 300
				ROLLBACK TRAN @ProcName
				RAISERROR ('Error:  Unable to update object!', 16, 1)
				RETURN	@Result
			END

		 -- Insert into audit Trail Troy the record of the transaction 
		INSERT	dbo.audit_trail
		(	serial,	date_stamp,	type,part,quantity,	remarks,
			operator,from_loc,to_loc,lot,weight,status,	unit,
			std_quantity,plant,	notes,	package_type,std_cost,
			user_defined_status,tare_weight,custom2)
		SELECT	object.serial,	object.last_date,'Q',object.part,object.quantity,'Quality',
			object.operator,SerialProcess.Status,'H',object.lot,object.weight,object.status,
			object.unit_measure,object.std_quantity,object.plant,@Note,	object.package_type,
			object.cost,object.user_defined_status,	object.tare_weight,object.custom2
		FROM	dbo.object object
		JOIN  #TempDataToProcess SerialProcess on SerialProcess.Serial= object.serial

		--  Validate if the operation on the Audit Trail is succesfull
		SELECT	@Error = @@Error, @RowCount = @@RowCount
		IF	@Error != 0 begin
			SET	@Result = 300
			ROLLBACK TRAN @ProcName
			RAISERROR ('Error:  Unable to insert audit trail Table!', 16, 1)
			RETURN	@Result
		END

		--IF	@RowCount = 0 begin
		--	SET	@Result = 800
		--	ROLLBACK TRAN @ProcName
		--	RAISERROR ('Error:  No row Inserted on audit trail Table!', 16, 1)
		--	RETURN	@Result
		--END

		--select	@SSRID,Data.Serial,@User,@TranDT ,Data.OriginalStatus,ObjectTroy.Status,audit_trailTroy.ID
		--from	#TempDataToProcess Data
		--join	dbo.Object ObjectTroy on ObjectTroy.serial = Data.Serial
		--join	dbo.audit_trail audit_trailTroy on ObjectTroy.serial = audit_trailTroy.Serial and audit_trailTroy.type='Q' AND audit_trailTroy.custom2=@SSRID
		--where	Data.Serial not in (select Serial from dbo.SSR_LogbySerial where SSR_ID=@SSRID )

		--Insert Log SSR serial	
		insert into dbo.SSR_LogbySerial (SSR_ID,Serial,RegisterUser,RegisterDate,OriginalStatus,NewStatus,AuditTrailID,Quantity)
		select	@SSRID,Data.Serial,@User,@TranDT ,Data.OriginalStatus,ObjectTroy.Status,audit_trailTroy.ID,ObjectTroy.quantity
		from	#TempDataToProcess Data
		join	dbo.Object ObjectTroy on ObjectTroy.serial = Data.Serial
		join	dbo.audit_trail audit_trailTroy on ObjectTroy.serial = audit_trailTroy.Serial and audit_trailTroy.type='Q' AND audit_trailTroy.custom2=@SSRID
		where	Data.Serial not in (select Serial from dbo.SSR_LogbySerial where SSR_ID=@SSRID )

		--  Validate if the operation on the Audit Trail is succesfull
		SELECT	@Error = @@Error, @RowCount = @@RowCount
		IF	@Error != 0 begin
			SET	@Result = 999999
			ROLLBACK TRAN @ProcName
			RAISERROR ('Error:  Unable to insert SSR_LogbySerial Table!', 16, 1)
			RETURN	@Result
		END

		--IF	@RowCount = 0 begin
		--	SET	@Result = 999999
		--	ROLLBACK TRAN @ProcName
		--	RAISERROR ('Error:  No row Inserted on SSR_LogbySerial Table!', 16, 1)
		--	RETURN	@Result
		--END
				
		declare @STDPack numeric(18,2)
		declare @CountSerialBySSR int

		select @STDPack=standard_pack from eehsql1.eeh.dbo.part_inventory where part=@Part
		SELECT @CountSerialBySSR= ISNULL((select CountSerialBySSR=count(*) from dbo.SSR_LogbySerial where SSR_ID=@SSRID group by SSR_ID),0)

		set @QtyToSort =@STDPack*@CountSerialBySSR 

	
		drop table ##SerialToProcess
		drop table  #TempDataToProcess
		
	--DECLARE PutOnHold_Cursos cursor local for

	--select	Serial
	--from	#TempDataToProcess
	
	--open PutOnHold_Cursos
	--fetch next from PutOnHold_Cursos
	--into @Serial

	--while @@FETCH_STATUS =0
	--	begin
	--			--Execute change status in Troy Database				
	--			Exec	eeh.HN.SP_EEI_Change_Object_Status
	--				@Operator = @User,
	--				@lngSerial	= @Serial,
	--				@strUserDefinedStatus='On Hold',
	--				@Note = @Note,
	--				@Result = @Result out	

	--				set	@Error = @@Error
	--				if	@Error != 0 begin
	--					set	@Result = 999999
	--					rollback tran @ProcName
	--					RAISERROR ('Error inserting in historical serial %s ', 16, 1,@Serial)
	--					return @Result
	--				end

	--				if		@Result != 0 begin
	--					set	@Result = 999999
	--					rollback tran @ProcName
	--					RAISERROR ('Procedure SP_EEI_Change_Object_Status execute with error.', 16, 1)
	--					return @Result
	--				end

	--			--Execute save log to SSR
	--			Exec	sistema.dbo.SP_SSR_SaveLogSerial
	--				@SSRID = @SSRID,
	--				@Serial	= @Serial,
	--				@User=@User,
	--				@Result = @Result out	

	--				set	@Error = @@Error
	--				if	@Error != 0 begin
	--					set	@Result = 999999
	--					rollback tran @ProcName
	--					RAISERROR ('Error change status to serial %s ', 16, 1,@Serial)
	--					return @Result
	--				end

	--				if	@Result != 0 begin
	--					set	@Result = 999999
	--					rollback tran @ProcName
	--					RAISERROR ('Procedure SP_SSR_SaveLogSerial execute with error.', 16, 1)
	--					return @Result
	--				end


	--	fetch next from PutOnHold_Cursos
	--	into @Serial
	--END
	--close PutOnHold_Cursos
	--DEALLOCATE PutOnHold_Cursos

	
--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction @ProcName 
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	II.	Return.
set	@Result =0
return	@Result
GO
