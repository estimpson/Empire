use FxUtilities
go

drop function Fx.FileStreamCRC
go

drop assembly CRC32
go

create assembly CRC32
authorization dbo
from 'c:\Temp\CLR\CRC32.dll'
go

alter assembly CRC32
drop file all
add file from 'c:\Temp\CLR\CRC32.dll'
go

print N'Creating Fx.FileCRC...'
go

create function Fx.FileStreamCRC(@fileContents varbinary(max))
returns int
as external name CRC32.UserDefinedFunctions.FileStreamCRC;
go
