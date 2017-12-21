SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 create function [dbo].[GiveMeNumbers](@input varchar(max))
 
 returns varchar(max)
 
 as
 
 begin
 
      declare @results varchar(max) = ''
      declare @position int = 1
      declare @current varchar(1)
      while @position <= len(@input)
      begin
         set @current = substring(@input, @position, 1)
         if  @current like '[0-9]'
             set @results = @results + @current 
              
         set @position += 1;
      end
      
      return @results
 end
GO
