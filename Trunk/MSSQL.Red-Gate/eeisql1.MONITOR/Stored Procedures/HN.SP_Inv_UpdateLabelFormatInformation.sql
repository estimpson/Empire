SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [HN].[SP_Inv_UpdateLabelFormatInformation]( 
		@Result integer = 0 output
) AS



SET nocount ON
SET	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount smallint
DECLARE @FromLoc varchar(10), @Plant varchar(10)
DECLARE @Object_Quantity numeric(20,6), @Part varchar(25)

--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer

SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION UpdateLabelFormatInfo
ELSE
	SAVE TRANSACTION UpdateLabelFormatInfo


Create table #ListPartWrongLabel (
	Part varchar(25),
	label_format varchar(50),
	TroyLabelREference varchar(50),
	EEHLabel varchar(50))


--Listado de partes con formato incorrecto
insert into #ListPartWrongLabel
Select	troypi.part, troypi.label_format, TroyLabelREference = troypi.eehlabel, EEHLabel= eehpi.label_format
from	dbo.part_inventory troypi
	inner join eehsql1.eeh.dbo.part_inventory eehpi
		 on troypi.part = eehpi.part
where	isnull(troypi.eehlabel,'') <> isnull(eehpi.label_format,'')


set	@Error = @@Error

if exists (Select 1
			from #ListPartWrongLabel)
begin			

--Creacion de formatos faltantes en US
Insert into dbo.report_library_format (name, formatlabel)
Select name, formatlabel
from	eehsql1.eeh.dbo.report_library_format
where	name in (
				Select NuevoFormato.eehlabel
				from (Select	distinct EEHLabel 
						from	#ListPartWrongLabel
						where	TroyLabelREference <> EEHLabel) NuevoFormato
					left join dbo.report_library_format formato
						on NuevoFormato.EEHLabel = formato.name
				where formato.name is null)


--Creacion ReportLibrary
Insert into dbo.report_library (name, report, type, [object_name], library_name, preview, print_setup, printer, copies)
Select name, report, type, [object_name], library_name, preview, print_setup, printer, copies
from	eehsql1.eeh.dbo.report_library
where	name in (
				Select NuevoFormato.eehlabel
				from (Select	distinct EEHLabel 
						from	#ListPartWrongLabel
						where	TroyLabelREference <> EEHLabel) NuevoFormato
					left join dbo.report_library formato
						on NuevoFormato.EEHLabel = formato.name
				where formato.name is null)

--actualizar formatos correctos
update dbo.part_inventory
set eehlabel = listado.EEHLabel
from dbo.part_inventory TroyPartInv
	inner join  #ListPartWrongLabel listado
		 on TroyPartInv.Part = listado.part
end

--Actualizar Inforecord de partes

Insert into monitor.dbo.part_characteristics (Part, IndexNo)
	Select	Part,IndexNo
	from	eehsql1.eeh.dbo.part_characteristics
		WHERE INDEXNO IS NOT NULL AND INDEXNO>0
		and part not in (Select PArt
						 from monitor.dbo.part_characteristics)



update monitor.dbo.part
set InfoRecord = InfoRecordHN.InfoRecord
from monitor.dbo.part  PartC
	 inner join (Select	Part,InfoRecord
					from	eehsql1.eeh.dbo.part_characteristics
					where	len(isnull(InfoRecord,''))>0) InfoRecordHN
		on PartC.part = InfoRecordHN.part


--Boxtype by parts
Insert into dbo.package_materials (Code, Name, type, returnable, weight)
Select	Code, Name, type, returnable, weight
from	eehsql1.monitor.dbo.package_materials
where	code not in (
			Select	code
			from	dbo.package_materials)

Insert into part_packaging(part, code, quantity)
Select EEHPack.part, EEHPack.code, EEHPack.quantity
from eehsql1.monitor.dbo.part_packaging EEHPack
	inner join (Select    PArtInv.Part
				from      eehsql1.monitor.dbo.part_inventory PArtInv
				inner join eehsql1.monitor.dbo.part  Part on part.part= partinv.part
				where part.type='F' and distribution_plant != 'EEA') DistributionPlant
		on eehpack.part = DistributionPlant.part
where	eehpack.part not in (Select Part
					 from part_packaging)



-- Update Format Label

update dbo.report_library_format
set FormatLabel=f.FormatLabel
FROM dbo.report_library_format fu inner join  ( Select *
 from	eehsql1.eeh.dbo.report_library_format )f on fu.name=f.name

--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION UpdateLabelFormatInfo
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
SET	@Result = 0
RETURN	@Result

GO
