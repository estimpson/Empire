SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROC [HN].[RLSP_PS_PrintLabel_Manual](@FieldName varchar(15),
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
