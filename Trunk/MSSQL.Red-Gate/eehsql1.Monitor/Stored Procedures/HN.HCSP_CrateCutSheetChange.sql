SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [HN].[HCSP_CrateCutSheetChange]( 
				@OldPart varchar(25), 
				@NewPart varchar(25),
				@Result int output )
as
/*
Example
begin Tran

declare	@RC int, @RetValue int
exec @RC = HN.HCSP_CrateCutSheetChange
		@OldPart = 'AUT0059-HD06',
		@NewPart = 'AUT0059-HD10',
		@Result = @RetValue out		

select	@RetValue , @RC

select	*
from	HC_Partes
where	part = 'AUT0059-HD10'

select	*
from	HC_Circuito_Componentes
where	part = 'AUT0059-HD10'

rollback
*/
SET nocount ON

SET	@Result = 999999


--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount SMALLINT
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION HCSP_CrateCutSheetChange
ELSE
	SAVE TRANSACTION HCSP_CrateCutSheetChange
--</Tran>

--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer
--</Error Handling>


if not exists( select 1
			from	HC_Partes
			where	part = @oldPart )
Begin
	set	@Result = 20000
	rollback tran HCSP_CratePottingChange
	raiserror( 'The part %s does not exists.',16,1, @OldPart)
	return @Result
End

if exists( select 1
			from	HC_Partes
			where	part = @NewPart )
Begin
	set	@Result = 20000
	rollback tran HCSP_CratePottingChange
	raiserror( 'The part %s does not exists.',16,1, @NewPart)
	return @Result
End


insert into  HC_Partes (
		Part,
		Ingenieria,
		IngIngenieria,
		FechaIngenieria,
		APQP,
		IngAPQP,
		FechaAPQP,
		Materiales,
		IngMateriales,
		FechaMateriales,
		Modo,
		Revision,
		VerificarSplice_APQP,
		Revision_Plano) 
select	@NewPart,
		Ingenieria,
		IngIngenieria,
		FechaIngenieria,
		APQP,
		IngAPQP,
		FechaAPQP,
		Materiales,
		IngMateriales,
		FechaMateriales,
		Modo,
		Revision,
		VerificarSplice_APQP,
		Revision_Plano
from	HC_Partes
where	part = @OldPart

select	@Error = @@error,
		@RowCount = @@rowcount

if	@RowCount != 1
begin
	set	@Result = 20002
	rollback tran	HCSP_CrateCutSheetChange
	raiserror( 'The part %s can not be create hc_Partes',16,1, @NewPart)
	return @Result
end


if	@Error != 0
begin
	set	@Result = 20003
	rollback tran	HCSP_CrateCutSheetChange
	raiserror( 'An error ocurr when try to create hc_Partes of the part %s',16,1, @NewPart)
	return @Result
end


insert into HC_Circuito_Componentes (
		Part,
		Circuito,
		Alambre,
		Calibre,
		Color,
		Longitud,
		Terminal1,
		EsDesforre1,
		Nota1,
		Terminal2,
		EsDesforre2,
		Nota2,
		Bando,
		Estado,
		Componente1,
		Componente2,
		Componente3,
		Ubicacion,
		CircuitoDoble,
		Nivel,
		TipoMaquinaID,
		RateKomax,
		RateSplice,
		RateTM,
		Unir_Circuito,
		Con_Circuito,
		TipoRacka,
		Camisa_Splice,
		Nota_Circuito,
		TripleTroquelado,
		TensionM,
		Grapa,
		Maquina,
		Rate)
select
		@NewPart,
		Circuito,
		Alambre,
		Calibre,
		Color,
		Longitud,
		Terminal1,
		EsDesforre1,
		Nota1,
		Terminal2,
		EsDesforre2,
		Nota2,
		Bando,
		Estado,
		Componente1,
		Componente2,
		Componente3,
		Ubicacion,
		CircuitoDoble,
		Nivel,
		TipoMaquinaID,
		RateKomax,
		RateSplice,
		RateTM,
		Unir_Circuito,
		Con_Circuito,
		TipoRacka,
		Camisa_Splice,
		Nota_Circuito,
		TripleTroquelado,
		TensionM,
		Grapa,
		Maquina,
		Rate
from	HC_Circuito_Componentes
where	Part = @OldPart

select	@Error = @@error,
		@RowCount = @@rowcount

if	@RowCount != 1
begin
	set	@Result = 20002
	rollback tran	HCSP_CrateCutSheetChange
	raiserror( 'The part %s can not be create HC_Circuito_Componentes',16,1, @NewPart)
	return @Result
end


if	@Error != 0
begin
	set	@Result = 20003
	rollback tran	HCSP_CrateCutSheetChange
	raiserror( 'An error ocurr when try to create HC_Circuito_Componentes of the part %s',16,1, @NewPart)
	return @Result
end

insert into HC_Circuito_Componentes_Splice_Der (
		Part,
		Circuito,
		Componente,
		ComponenteConectar,
		Calibre)
select	@NewPart,
		Circuito,
		Componente,
		ComponenteConectar,
		Calibre
from	HC_Circuito_Componentes_Splice_Der
where	Part = @OldPart

select	@Error = @@error,
		@RowCount = @@rowcount

if	@Error != 0
begin
	set	@Result = 20002
	rollback tran	HCSP_CrateCutSheetChange
	raiserror( 'The part %s can not be create HC_Circuito_Componentes_Splice_Der',16,1, @NewPart)
	return @Result
end


insert into HC_Circuito_Componentes_Splice_Izq (
		Part,
		Circuito,
		Componente,
		ComponenteConectar,
		Calibre)
select	@NewPart,
		Circuito,
		Componente,
		ComponenteConectar,
		Calibre
from	HC_Circuito_Componentes_Splice_Izq
where	Part = @OldPart


select	@Error = @@error,
		@RowCount = @@rowcount

if	@Error != 0
begin
	set	@Result = 20002
	rollback tran	HCSP_CrateCutSheetChange
	raiserror( 'The part %s can not be create HC_Circuito_Componentes_Splice_Izq',16,1, @NewPart)
	return @Result
end

insert into CP_Control_ECN (
	ECN,
	Part_Vieja,
	Part_Nueva,
	Estado,
	FechaImplementacion,
	ContenedorID,
	Comentario,
	FechaFirma,
	FechaRecepcion,
	FechaImplementacionEEH) 
select 
	ECN = 'ECN291-08',
	OldPart = @OldPart,
	NewPart = @NewPart,
	Estado = 1,
	FechaImplementacion = '5/11/2008',
	ContenedorID = 243,
	Comentario = '',
	FechaFirma = getdate(),
	FechaRecepcion = getdate(),
	FechaImplementacionEEH = getdate()
	


select	@Error = @@error,
		@RowCount = @@rowcount

if	@Error != 0
begin
	set	@Result = 20002
	rollback tran	HCSP_CrateCutSheetChange
	raiserror( 'The part %s can not be create HC_Circuito_Componentes_Splice_Der',16,1, @NewPart)
	return @Result
end

declare	@NewProyectoID int,
		@OldProyectoID int
		
select	@OldProyectoID = ProyectoID
from	TP_Proyectos
where	nombre = @OldPart

insert into TP_Proyectos (
	Nombre,
	IID,
	FechaTarget,
	FechaInicio,
	Usuario,
	Activo,
	EAU,
	IngCalidad,
	IngAPQP,
	AutorizadaCalidad,
	AutorizadaAPQP,
	FechaCalidad,
	FechaAPQP )
select		
	@NewPart,
	IID,
	getdate(),
	getdate(),
	Usuario,
	Activo,
	EAU,
	IngCalidad,
	IngAPQP,
	AutorizadaCalidad,
	AutorizadaAPQP,
	FechaCalidad,
	FechaAPQP
from	TP_Proyectos
where	ProyectoID = @OldProyectoID

set	@NewProyectoID = SCOPE_IDENTITY ()

if	@Error != 0
begin
	set	@Result = 20002
	rollback tran	HCSP_CrateCutSheetChange
	raiserror( 'The part %s can not be create HC_Circuito_Componentes_Splice_Der',16,1, @NewPart)
	return @Result
end

insert into TP_TerminalProyecto (
	TCFGID,
	ProyectoID,
	CArnes,
	MismoCircuito,
	Usuario)
select 	
		TCFGID,
		@NewProyectoID,
		CArnes,
		MismoCircuito,
		Usuario
from	TP_TerminalProyecto 
where	ProyectoID = @OldProyectoID

if	@TranCount = 0 begin
	commit transaction HCSP_CrateCutSheetChange
end
--</CloseTran Required=Yes AutoCreate=Yes>

set	@Result = 0
return	@Result
GO
