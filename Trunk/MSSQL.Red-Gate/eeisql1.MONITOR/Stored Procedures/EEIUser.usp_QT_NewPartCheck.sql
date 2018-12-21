SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_QT_NewPartCheck]
	@EEIPartNumber varchar(30)
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
set	@Result = 0

--- <Error Handling>
declare
	--@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	--@ProcReturn integer,
	--@ProcResult integer,
	--@Error integer,
	@RowCount integer


set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
set @TranDT = getdate()


begin transaction


--- <Body>
select
	coalesce(bpa.base_part, '') as BasePart
from
	eeiuser.acctg_csm_base_part_attributes bpa
where
	bpa.base_part in
		(	select
				Value
			from
				dbo.fn_SplitStringToRows(@EEIPartNumber, '/')
		)
	or bpa.base_part in
		(
			select
				Value
			from
				dbo.fn_SplitStringToRows(@EEIPartNumber, ',')
		) 
--- </Body>


if @@TRANCOUNT > 0  
    commit transaction;  
GO
