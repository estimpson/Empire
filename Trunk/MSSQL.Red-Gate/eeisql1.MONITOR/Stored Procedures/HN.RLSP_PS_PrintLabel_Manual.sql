SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
declare @r int,
		@Serial int,
		@Part varchar(25),
		@LabelFormat varchar(50)

Set @Serial=92487402

Select @Part = part
from object
where serial=@Serial

Select @LabelFormat= eehlabel
from part_inventory
where part=@Part

Select Serial = @Serial, Part=@Part, LabelFormat_USA = @LabelFormat, LabelFormat_HN= label_format
from eehsql1.eeh.dbo.part_inventory
where part=@part

exec [HN].[RLSP_PS_PrintLabel_Manual] 'serial',@Serial,'HN.VW_PS_DataLabel_CustomerGeneral',@LabelFormat,@r out
Select @r

/*
	Si LabelFormat_USA <> LabelFormat_HN, ejecutar el JOB que esta en Troy llamado:  "Custom - Update label format information HND-Troy"
		esto se encarga de sincronizar la informacion de HN en USA. El se ejecuta cada hora reloj.
		

	El procedimiento RLSP_PS_PrintLabel_Manual devuelve la cadena ZPL de la etiqueta a imprimir.
	Copiar la codena, luego ir a http://labelary.com/viewer.html
	reemplazar el texto de ejemplo que esta en el sitio, pegar la cadena del paso 1.
	dar click en el boton Redraw.

	La informacion que se imprime en los labels se obtiene de los PO's que crea el depto. de Scheduling.
*/
*/

CREATE PROC [HN].[RLSP_PS_PrintLabel_Manual](@FieldName varchar(15),
		@FieldValue int,
		@LabelFormatView varchar(35),
		@LabelFormatName varchar(15),
		@Result int output)
AS
BEGIN


SET nocount ON
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
	DECLARE	@TranCount SMALLINT
	SET	@TranCount = @@TranCount
	IF	@TranCount = 0 
		BEGIN TRANSACTION RLSP_PS_PrintLabel_Manual
	ELSE
		SAVE TRANSACTION RLSP_PS_PrintLabel_Manual
--</Tran>


Declare		@Print nvarchar(3000)			--Resultado

select	@Print='declare @InfoToPrint nvarchar(3000) select @InfoToPrint = ' + FormatLabel + 
				' from ' +  @LabelFormatView + 				
				' where '+ @FieldName + ' = convert(integer,' + convert(varchar,@FieldValue) +')  select PrintLine=@InfoToPrint'
from	report_library_format
where	name = @LabelFormatName

print @print

exec sp_executeSQL @Print

	IF	@@Error != 0 begin
		SET	@Result = 300
		ROLLBACK TRAN RLSP_PS_PrintLabel_Manual
		RAISERROR ('Error:  Unable to execute Labelformat Procedure!', 16, 1)
		RETURN	@Result
	END

--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION RLSP_PS_PrintLabel_Manual
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
SET	@Result = 0
RETURN	@Result


END
GO
GRANT EXECUTE ON  [HN].[RLSP_PS_PrintLabel_Manual] TO [APPUser]
GO
