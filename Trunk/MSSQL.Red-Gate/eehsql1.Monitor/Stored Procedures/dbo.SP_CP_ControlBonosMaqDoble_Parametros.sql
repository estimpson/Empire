SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Elvis Alas>
-- Create date: <23-02-2017>
-- Description:	< >
-- =============================================
CREATE PROCEDURE [dbo].[SP_CP_ControlBonosMaqDoble_Parametros] 
@Contenedor int,
@FechaContenedor datetime,
@ValorBono int,
@AsociacionKomax int ,
@AsociacionMoldeo int,
@CreateBy varchar(25),
@CreateDt datetime,
@Status int,
@Result INT OUT	

AS

Declare @ProcName sysname

Set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
		SET NOCOUNT ON;
		SET @Result = 999999

		DECLARE	@TranCount SMALLINT
		SET		@TranCount = @@TranCount
		
		IF	@TranCount = 0 
			BEGIN TRANSACTION @ProcName
		ELSE
			SAVE TRANSACTION @ProcName
	
	DECLARE @ProcReturn integer, @ProcResult integer
	DECLARE @RowCount integer
	DECLARE @Error INT = 0


BEGIN

	INSERT INTO Sistema.dbo.CP_ControlBono_MaqDoble_Parametros
			   ([Contenedor]
			   ,[FechaContenedor]
			   ,[Valorbono]
			   ,[AsociacionKomax]
			   ,[AsociacionMoldeo]
			   ,[Status]
			   ,[CreateBY]
			   ,[CreateDT])
		 VALUES
			   (@Contenedor,@FechaContenedor,@ValorBono,@AsociacionKomax,@AsociacionMoldeo,@Status,@CreateBy,@CreateDt)


	SELECT	@Error = @@Error
				IF	@Error != 0 begin
					SET	@Result = 99999
					ROLLBACK TRAN @ProcName
					RAISERROR ('Error:  Error al momento de insertar el encabezado de la Score Card', 16, 1)
					RETURN	@Result
				END


END

IF	@TranCount = 0 
BEGIN
	COMMIT TRANSACTION @ProcName
END

SET	@Result = 0
RETURN	@Result
GO
