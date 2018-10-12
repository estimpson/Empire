SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Rerival the user by password, ussing the new formula for password


create function [dbo].[fn_GetEmployeeByPassword]
(
	@Password varchar(255)
)
returns	@Employee table
    (	name  varchar(40),
	operator_code varchar(5) )   
as
/*

declare	@Password varchar(255)

set @Password = ''

select	*
from	fn_GetEmployeeByPassword( @Password )


*/

begin

    insert into @Employee( name, operator_code )	
    SELECT name, operator_code 
    FROM eeh.dbo.employee with (readuncommitted)
    WHERE pwdcompare(@Password,npassword,0) = 1

    return
end
GO
