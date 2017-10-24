SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[ftsp_ProTransSwapSerial]
(	@ProTransSerial int,
	@MonitorSerial int)
as
begin transaction
alter table object disable trigger all
alter table audit_trail disable trigger all
update	object
set	serial = @ProTransSerial
where	serial = @MonitorSerial

update	audit_trail
set	serial = @MonitorSerial
where	serial = @ProTransSerial and
	type = 'S'

alter table object enable trigger all
alter table audit_trail enable trigger all
commit
GO
