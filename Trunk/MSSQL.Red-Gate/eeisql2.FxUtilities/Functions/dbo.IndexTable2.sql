SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[IndexTable2]
(	@FirstIndex bigint
,	@LastIndex bigint
)
returns @Result table (Id bigint primary key)
with schemabinding
as
/***************************************************************************************************
    DESCRIPTION:
         Create an one column table of indexes starting with first specified index and 
         ending with last specified index.

    INPUT PARAMETERS:
         @FirstIndex:    First index to start the list of indexes with.
         @LastIndex:     Last index to end the list of indexes with.

    RETURN VALUE:
         Table with list of specified indexes.

    EXAMPLES:
        SELECT * FROM dbo.IndexTable(1, 20)
        SELECT * FROM dbo.IndexTable(1, 16)
        SELECT * FROM dbo.IndexTable(1, 17)
        SELECT * FROM dbo.IndexTable(1, 18)
        SELECT * FROM dbo.IndexTable(1, 1)
        SELECT * FROM dbo.IndexTable(1, 0)
***************************************************************************************************/
begin
	DECLARE @max        bigint
    ,       @offset     bigint
    ;
    IF @LastIndex IS NULL RETURN ;
    IF @FirstIndex IS NULL RETURN ;
    
	insert
		@Result
	select
		Id
	from
		CRC32.IndexTable it
	where
		it.Id between @FirstIndex and @LastIndex;

    SELECT @max= MAX(Id) FROM @Result
    ;
    WHILE @max < @LastIndex
    BEGIN
        SET @offset = (1 + @max - @FirstIndex)
        ;
        INSERT
        INTO    @Result
        SELECT  Id = Id + @offset
        FROM    @Result
        WHERE   Id <= (@LastIndex - @offset)
        ;
        SELECT @max= MAX(Id) FROM @Result
        ;
    END
    DELETE FROM @Result WHERE Id > @LastIndex
    ;
    RETURN
end;
GO
