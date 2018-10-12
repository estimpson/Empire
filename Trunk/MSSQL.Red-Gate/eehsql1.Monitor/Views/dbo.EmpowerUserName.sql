SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EmpowerUserName] as 
select	security_id, Name = first_name + ' ' +  last_name
from	user_names
GO
