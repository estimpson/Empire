SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[SP_BF_PrintLabel](@FieldValue int, @LabelFormatName varchar(15) = null, @Result int output)
AS
BEGIN
/*
BEGIN TRAN
declare	@Result int,
		@Serial int

set		@Serial= 34944553

exec	HN.SP_BF_PrintLabel
			@FieldValue = @Serial,
			@LabelFormatName = '',
			@Result = @Result out
			
SELECT	@Result 

ROLLBACK
*/

SET nocount ON
set	@Result = 999999
DECLARE @ProcName  sysname

set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

--<Tran Required=Yes AutoCreate=Yes>
	DECLARE	@TranCount SMALLINT
	SET	@TranCount = @@TranCount
	IF	@TranCount = 0 
		BEGIN TRANSACTION @ProcName
	ELSE
		SAVE TRANSACTION @ProcName
--</Tran>


Declare @FieldID varchar(15),			--Nombre del Campo para buscar informacion
		@LabelFormatView varchar(35),	--Vista/Tabla en la cual debo buscar  
		@Print nvarchar(4000),			--Resultado
		@Copies int

Select	@LabelFormatName=isnull(@LabelFormatName,''),
		@FieldID=case	when 	@LabelFormatName like 'MOLD%' then 'WOID'
						when	@LabelFormatName like 'SPL_LABEL_IDEN' then 'ID'
						when	@LabelFormatName like 'SAMPLEMOLDING' then 'SerialNumber'
						when	@LabelFormatName like 'MAT_AEREOS' then 'Id'
						else 'Serial' end
		

if	isnull(@FieldValue,0)>0 and isnull(@LabelFormatName,'')='' begin

	Select	@LabelFormatName=rlib.name,
			@LabelFormatView=case 
								 when rlib.name='L_CKT_WIP' or obj.part='PALLET' then 'HN.VW_PS_DataLabel_WIP'
								 when part.type in ('R','W') then 'HN.VW_PS_DataLabel_RawMaterial'
								 when upper(LEFT(obj.part,3))='MIT' then 'HN.VW_PS_DataLabel_CustomerMIT' 

								else 'HN.VW_PS_DataLabel_CustomerGeneral' end,
			@Copies = case when part.type = 'F' then 2 else 1 end
	from	object obj
		left join part on obj.part=part.part
		left join part_inventory pi on pi.part=obj.part
		left join report_library rlib on pi.eehlabel=rlib.name		
	WHERE   obj.serial=@FieldValue

end else begin

	Select @LabelFormatView= case 
								when 	@LabelFormatName like 'MOLD%' then 'HN.VW_PS_DataLabel_Moldeo' 
								when 	@LabelFormatName ='RUNNER' then 'HN.VW_PS_DataLabel_WIP'
								when 	@LabelFormatName ='L_CKT_WIP' then 'HN.VW_PS_DataLabel_WIP'
								when 	@LabelFormatName ='DANO_MOLDE' then 'HN.VW_PS_DataLabel_MoldesDanados'
								when	@LabelFormatName = 'SPL_LABEL_IDEN' then 'WOS'
								when	@LabelFormatName = 'PCB_Lbl1' then 'VW_PCB_BinLabel'
								when	@LabelFormatName = 'SAMPLEMOLDING' then 'PrintQueue'
								when	@LabelFormatName = 'L_CKT_WIP' then 'HN.VW_PS_DataLabel_WIP'
								when	@LabelFormatName = 'L_CKTWIP_PCB' then 'HN.VW_PS_DataLabel_WIP'
								when	@LabelFormatName ='PALLET' then 'HN.VW_PS_DataLabel_WIP'
								when	@LabelFormatName = 'PCB_4X1' then 'HN.VW_PS_DataLabel_RawMaterial'
								when	@LabelFormatName = 'PCB_4X6' then 'HN.VW_PS_DataLabel_RawMaterial'
								when	@LabelFormatName = 'MAT_AEREOS' then 'VW_PS_DataLabel_Aereos'
								when	@LabelFormatName = 'FN_AUT' then  'HN.VW_PS_DataLabel_CustomerGeneral'
								when	@LabelFormatName = 'FIN_ALC0246' then  'HN.VW_PS_DataLabel_CustomerGeneral'
								when	@LabelFormatName = 'PCB_4X6_ZebraZ4M' then  'HN.VW_PS_DataLabel_RawMaterial'
								when	@LabelFormatName = 'FIN_NAS0001' then  'HN.VW_PS_DataLabel_CustomerGeneral'
								when	@LabelFormatName = 'FN_ADC_2D' then  'HN.VW_PS_DataLabel_CustomerGeneral'
								when	@LabelFormatName = 'FIN_LTK' then  'HN.VW_PS_DataLabel_CustomerGeneral'
								when	@LabelFormatName = 'FIN_MAGNA' then  'HN.VW_PS_DataLabel_CustomerGeneral'
								when	@LabelFormatName = 'FN_ADC_US' then  'HN.VW_PS_DataLabel_CustomerGeneral'
								when	@LabelFormatName = 'FIN_STE_PCB' then  'HN.VW_PS_DataLabel_CustomerGeneral'
								when	@LabelFormatName = 'FIN_STE_ENSB' then  'HN.VW_PS_DataLabel_CustomerGeneral'
								else
									(Select case 
											when rlib.name='L_CKT_WIP' or obj.part='PALLET' then 'HN.VW_PS_DataLabel_WIP'
											when part.type in ('R','W') then 'HN.VW_PS_DataLabel_RawMaterial'
											when upper(LEFT(obj.part,3))='MIT' then 'HN.VW_PS_DataLabel_CustomerMIT' 
										else 'HN.VW_PS_DataLabel_CustomerGeneral' end		
									from	object obj
										left join part on obj.part=part.part
										left join part_inventory pi on pi.part=obj.part
										left join report_library rlib on pi.eehlabel=rlib.name		
									WHERE   obj.serial=@FieldValue)
							end

		select	@Copies= isnull( (select copies from report_Library where name = @LabelFormatName), 1 )
		
end

print @LabelFormatView
print @FieldValue
print @LabelFormatName
print @FieldID


if exists (Select	1
			from		eehsql1.Sistema.dbo.APQP_Report_label_formatTest
			where	name=@LabelFormatName) begin 
		
	Select	@LabelFormatName=@LabelFormatName, 
			@LabelFormatView='HN.VW_PS_DataLabel_CustomerGeneral', 
			@Copies = 2
	print @LabelFormatView
	print @LabelFormatName
	print @FieldID
	print @FieldValue
	select	@Print='declare @InfoToPrint nvarchar(3000) select @InfoToPrint = ' + Report + 
				' from ' +  @LabelFormatView + 				
				' where '+ @FieldID + ' = convert(integer,' + convert(varchar,@FieldValue) +')  select PrintLine=@InfoToPrint,copies = ' + convert(varchar, @Copies )
	from	eehsql1.Sistema.dbo.APQP_Report_label_formatTest with (readuncommitted)
	where	name = @LabelFormatName
end else begin


select	@Print='declare @InfoToPrint nvarchar(3000) select @InfoToPrint = ' + FormatLabel + 
				' from ' +  @LabelFormatView + 				
				' where '+ @FieldID + ' = convert(integer,' + convert(varchar,@FieldValue) +')  select PrintLine=@InfoToPrint,copies = ' + convert(varchar, @Copies )
from	report_library_format
where	name = @LabelFormatName

end
PRINT @Print

exec sp_executeSQL @Print

	IF	@@Error != 0 begin
		SET	@Result = 300
		ROLLBACK TRAN @ProcName
		RAISERROR ('Error:  Unable to execute Labelformat Procedure!', 16, 1)
		RETURN	@Result
	END

--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION @ProcName
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
SET	@Result = 0
RETURN	@Result
END

GO
GRANT EXECUTE ON  [HN].[SP_BF_PrintLabel] TO [APPUser]
GO
