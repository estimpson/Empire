SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Leswin Melgar>
-- Create date: <2018-04-19>
-- Description:	<Se utiliza para insertar elementos del Checklist en Wharehouse Picklist en formulacion Putaway-Cycle Count >
-- Solicitado por Dorian Cano
-- =============================================

CREATE PROCEDURE [HN].[SP_Putaway_InsertDetail_Log](
		@Locacion VARCHAR(20),
		@Operator varchar(50),
		@SelectDatos varchar(MAX),
		@Result int out

		/*
		EJEMPLO
		DECLARE @SelectSQL VARCHAR(MAX)
		SET @SelectSQL='SELECT Caracteristica=''Daño en Tarima'', Resultado=''Y'' union all SELECT Caracteristica=''Rotulacion Correcta'', Resultado=''Y'''

		BEGIN TRAN
			exec [HN].[SP_Putaway_InsertDetail_Log] 'AL-B-3-19','cody',@SelectSQL,0

		ROLLBACK
			--COMMIT TRAN
		*/
)
AS
BEGIN
	SET NOCOUNT ON

	SET   @Result = 999999

	DECLARE @TranCount  SMALLINT
	DECLARE @id_Putaway_log INTEGER
	DECLARE @InsertSQL1 VARCHAR(500)
	DECLARE @InsertSQL2 VARCHAR(500)
	DECLARE @ExecuteSQL VARCHAR(MAX)
	DECLARE @SelectId VARCHAR(MAX)


	DECLARE @ProcReturn INTEGER, @ProcResult INTEGER 
	DECLARE @Error INTEGER, @RowCount INTEGER,@ProcName SYSNAME
	SET    @ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

	----<Tran Required=Yes AutoCreate=Yes>

	--SET   @TranCount = @@TranCount
	--IF    @TranCount = 0 
	--	  BEGIN TRANSACTION @ProcName
	--ELSE
	--	  SAVE TRANSACTION @ProcName

	--</Tran Required=Yes AutoCreate=Yes>

	--Se cargan los datos en tabla Temporal
	CREATE TABLE #TempLog(			Caracteristica VARCHAR(200),
									Resultado VARCHAR(200)
								) 

	SELECT @InsertSQL1='INSERT INTO  #TempLog (Caracteristica, Resultado)'



	SET   @ExecuteSQL= @InsertSQL1 + @SelectDatos

	EXECUTE(@ExecuteSQL)
		SET    @Error = @@Error
					IF     @Error != 0 
					BEGIN
						SET    @Result = 999999
						RAISERROR ('Error en %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error)
		    			ROLLBACK TRAN [SP_Putaway_InsertDetail_Log]
						RETURN	@Result
					END

	--Se obtiene el valor del Id de la tabla Putaway_log
	SET @id_Putaway_log= (SELECT TOP 1 id FROM HN.Putaway_log WHERE operator=@Operator and Location=@Locacion ORDER BY id DESC)

	--Se agrega el valor del id a la consulta
	SET @SelectId =  'SELECT id_Putaway_log=' + convert (varchar, @id_Putaway_log) +', * FROM #TempLog'


	--Se inserta a la tabla oficial
	SELECT @InsertSQL2='INSERT INTO  HN.Putaway_log_Details (id_Putaway_log, Caracteristica, Resultado)'
	SET   @ExecuteSQL= @InsertSQL2 + @SelectId

	EXECUTE(@ExecuteSQL)
	SET    @Error = @@Error
					IF     @Error != 0 
					BEGIN
						SET    @Result = 999999
						RAISERROR ('Error en %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error)
		    			ROLLBACK TRAN [SP_Putaway_InsertDetail_Log]
						RETURN	@Result
					END


	UPDATE HN.Putaway_log SET Status='Completed', DateEnd=GETDATE() WHERE id=@id_Putaway_log
	SET    @Error = @@Error
					IF     @Error != 0 
					BEGIN
						SET    @Result = 999999
						RAISERROR ('Error en %s.  Error: %d while updating row to table', 16, 1, @ProcName, @Error)
		    			ROLLBACK TRAN [SP_Putaway_InsertDetail_Log]
						RETURN	@Result
					END

	DROP TABLE #TempLog

	--     II.    Return.
	SET    @Result = 0
	RETURN @Result

END





GO
