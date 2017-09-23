SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create	procedure [dbo].[ftsp_get_EEHPartStandard]

as
begin
truncate table EEH_part_standard

insert EEH_part_standard
 
 select
		getdate(),
		convert(varchar(5),datepart(YYYY, getdate())),
		convert(smallint,datepart(MM, getdate())),
		'DAILY',
		* 
 from eehsql1.monitor.dbo.part_standard
End
GO
