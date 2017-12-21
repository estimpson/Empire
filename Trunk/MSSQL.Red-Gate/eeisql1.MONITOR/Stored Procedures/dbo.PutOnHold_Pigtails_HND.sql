SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[PutOnHold_Pigtails_HND] (
		@Result integer = 0 output) 
As

/*
begin tran

DECLARE @Result int
declare @TranDT datetime
set @TranDT=GETDATE()

	exec dbo.PutOnHold_Pigtails_HND
		@Result=@Result out


rollback tran

*/

SET nocount ON
SET   @Result = 999999

DECLARE     @TranCount smallint,@ProcName sysname

set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

--<Tran Required=Yes AutoCreate=Yes>
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
--</Tran Required=Yes AutoCreate=Yes>
      
--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer 
DECLARE @Error integer, @RowCount integer
--</Error Handling> 
declare @TranDT datetime
declare @CurrentYear int
DECLARE @strNewStatus  varchar(1)
declare @strNewStatusName varchar(30)
declare @Note varchar(150)

set @TranDT=GETDATE()

SELECT @strNewStatus=Type,@strNewStatusName=display_name FROM user_defined_status WHERE Display_Name = 'On Hold' 
set @Note='OnHold by master list of pigtails in HND, by 2 months in warehouse'

--select	obj.*,qtymonth=datediff(month,obj.ObjectBirthday,GETDATE())
--from	monitor.dbo.object obj
--join	monitor.dbo.location location on location.code = obj.location 
--join	monitor.dbo.vw_HND_MasterList_Pigtails Pigtails on Pigtails.Linea=left(obj.part,7)
--		and location.group_no ='EEI WAREHOUSE' 
--		and location.secured_location='N' 
--		and location.Type='ST' 
--		and location.plant='EEI'
--where	obj.status='A' and datediff(month,obj.ObjectBirthday ,GETDATE())>=2


if exists (	select	1
			from	monitor.dbo.object obj
			join	monitor.dbo.location location on location.code = obj.location 
			join	monitor.dbo.vw_HND_MasterList_Pigtails Pigtails on Pigtails.Linea=left(obj.part,7)
					and location.group_no ='EEI WAREHOUSE' 
					and location.secured_location='N' 
					and location.Type='ST' 
					and location.plant='EEI'
			where	obj.status='A' and datediff(month,obj.ObjectBirthday ,GETDATE())>=2 
)begin

	--Update the Object Table with new info.
	UPDATE	Object
	SET		Last_date =@TranDT, 
			Operator = 'MON', 
			Status = @strNewStatus, 
			Note = @Note, 
			user_defined_status = @strNewStatusName, 
			Last_Time = @TranDT
	from	Object obj
	join	monitor.dbo.location location on location.code = obj.location 
	join	monitor.dbo.vw_HND_MasterList_Pigtails Pigtails on Pigtails.Linea=left(obj.part,7)
			and location.group_no ='EEI WAREHOUSE' 
			and location.secured_location='N' 
			and location.Type='ST' 
			and location.plant='EEI'
	where	obj.status='A' and datediff(month,obj.ObjectBirthday ,GETDATE())>=2 
	
	SELECT	@Error = @@Error
	IF	@Error != 0 begin
		SET	@Result = 300
		ROLLBACK TRAN HCSP_Change_Object_Status
		RAISERROR ('Error:  Unable to update object!', 16, 1)
		RETURN	@Result
	END

	-- Insert into audit Trail the record of the transaction 
	INSERT	audit_trail
	(	serial,
		date_stamp,
		type,
		part,
		quantity,
		remarks,
		operator,
		from_loc,
		to_loc,
		lot,
		weight,
		status,
		unit,
		std_quantity,
		plant,
		notes,
		package_type,
		std_cost,
		user_defined_status,
		tare_weight)
	SELECT	object.serial,
		object.last_date,
		'Q',
		object.part,
		object.quantity,
		'Quality',
		object.operator,
		'A',
		@strNewStatus,
		object.lot,
		object.weight,
		object.status,
		object.unit_measure,
		object.std_quantity,
		object.plant,
		@Note,
		object.package_type,
		object.cost,
		object.user_defined_status,
		object.tare_weight
	FROM	object object
	WHERE	object.Note = @Note and object.status=@strNewStatus
				and object.Last_date =@TranDT
				and object.Last_Time = @TranDT
				and object.Operator='MON'

--  Validate if the operation on the Audit Trail is succesfull
	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 300
		ROLLBACK TRAN HCSP_Change_Object_Status
		RAISERROR ('Error:  Unable to update audit_trail Table!', 16, 1)
		RETURN	@Result
	END

	IF	@RowCount = 0 begin
		SET	@Result = 800
		ROLLBACK TRAN HCSP_Change_Object_Status
		RAISERROR ('Error:  No row Updated on audit_trail Table!', 16, 1)
		RETURN	@Result
	END

end

	----Envio de correo de partes que se colocaron con RI Anual.
	--declare @subject varchar(500)
	--set @subject = 'Listado de partes con RI Anual. Rango de fecha: ' + convert(varchar,convert(date,@TranDT)) + ' - ' + convert(varchar,convert(date,dateadd(day,7,@TranDT))) + '.'
	----PRINT @subject
	--exec	HN.SP_ADM_SendEmail
	--	@recipients = 'RecevingInspection@empire.hn',
	--	@subject = @subject,
	--	@Body = '50 Partes fueron seteadas para realizar RI Anual.',
	--	@SQL ='	select Part from eeh.HN.PartRI_AnnualRILog where convert(date,StartDate)= convert(date,GETDATE())  '



IF	@TranCount = 0 
BEGIN
	COMMIT TRANSACTION @ProcName
END

SET @Result	= 0
RETURN	@Result
       
GO
