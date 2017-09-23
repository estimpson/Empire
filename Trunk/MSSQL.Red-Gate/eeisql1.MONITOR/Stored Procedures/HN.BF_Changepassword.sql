SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE PROCEDURE [HN].[BF_Changepassword] 
	(@UserWeb varchar(25),
	@UserMonitor varchar(25),
	@Password varchar(25),
	@Result integer = 0 output)
AS
/*
begin tran
declare	@Result int

exec	[HN].[BF_Changepassword] 
			@UserWeb = '436',
			@UserMonitor = '436',
			@Password = 'empire2016',
			@Result = @Result out

select	@Result
--commit
rollback			

*/

SET nocount ON
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount SMALLINT
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION BF_Changepassword
ELSE
	SAVE TRANSACTION BF_Changepassword
--</Tran>

--<Error Handling>

DECLARE @Error integer,	@RowCount integer
--</Error Handling>


update adm_usr_usuarios
set usr_password=monitor.dbo.dkrpt(@Password,'E'),
	usr_operator_code=(Select operator_code 
						from monitor.dbo.employee 
						where EmployeeID =  (Select usr_Codigo_Empleado 
											 from  adm_usr_usuarios
											 where	usr_usuario= @UserWeb)),
	NextChangePassword=DATEADD(d,360,GETDATE())
where usr_usuario=@UserWeb

SELECT	@Error = @@Error, @RowCount = @@RowCount
IF	@Error != 0 begin
	SET	@Result = 100
	ROLLBACK TRAN BF_Changepassword
	RAISERROR ('Error:  Can not change Password Inventory, try again!', 16, 1)
	RETURN	@Result
END

IF	@RowCount = 0 begin
	SET	@Result = 200
	ROLLBACK TRAN BF_Changepassword
	RAISERROR ('Information impossible update Inventory!', 16, 1)
	RETURN	@Result
END


UPDATE	employee 
SET		npassword = convert(varbinary(255), pwdencrypt (@Password)) 
WHERE	EmployeeID = (Select usr_Codigo_Empleado 
						from  adm_usr_usuarios
						where	usr_usuario= @UserWeb) 

SELECT	@Error = @@Error, @RowCount = @@RowCount
IF	@Error != 0 begin
	SET	@Result = 300
	ROLLBACK TRAN BF_Changepassword
	RAISERROR ('Error:  Can not change Password monitor, try again!', 16, 1)
	RETURN	@Result
END

IF	@RowCount = 0 begin
	SET	@Result = 400
	ROLLBACK TRAN BF_Changepassword
	RAISERROR ('Information impossible update Monitor!', 16, 1)
	RETURN	@Result
END


--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION BF_Changepassword
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
SET	@Result = 0
RETURN	@Result
GO
GRANT EXECUTE ON  [HN].[BF_Changepassword] TO [APPUser]
GO
