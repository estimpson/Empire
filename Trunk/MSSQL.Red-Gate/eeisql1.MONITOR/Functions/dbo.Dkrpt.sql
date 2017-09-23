SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create FUNCTION [dbo].[Dkrpt](@phrase VARCHAR(100), 
					  @action VARCHAR(1)) 
RETURNs varchar(200) aS

begin

declare
    @longitud int,@x int,
    @i int,
    @phrase_dkrpt VARCHAR(200),
    @phrase_dkrpt_temp VARCHAR(200)

	set @i = 1
	set @x = 32
	set @longitud = 0
	set @phrase_dkrpt = ''
	set @phrase_dkrpt_temp = ''
	

    select @longitud = len(@phrase)
    while @i <= @longitud 
	 begin
        IF (@action = 'E')
           begin 
            SELECT @phrase_dkrpt_temp = char(Ascii(SUBSTRing(@phrase,@i,1))+ (@x+ (@x/2))) 
           end
         else 
           begin
			   if (@action = 'D') 
			   begin
					SELECT @phrase_dkrpt_temp = char(Ascii(SUBSTRing(@phrase,@i,1))-(@x+ (@x/2)))
			   end
		   end

        select @phrase_dkrpt = @phrase_dkrpt + @phrase_dkrpt_temp
		set @i = @i + 1
     end

    RETURN @phrase_dkrpt

end

GO
GRANT EXECUTE ON  [dbo].[Dkrpt] TO [APPUser]
GO
