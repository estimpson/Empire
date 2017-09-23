SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create function [FT].[fn_DateTimeToString]
(	@ValueDT datetime, 
	@Format varchar(100) = '')
returns	varchar(256)
/* 
Valid @Format arguments
 nothing	returns the date as varchar or a blank string if null
 y or yy	returns the last two digits of the year
 yyyy		returns the four digits of the year
 m		returns the month
 mm		returns the month zero filled forcing two digits
 mmm or MMM	returns the month abbreviation (optional all caps)
 mmmm or MMMM	returns the full month name (optional all caps)
 d		returns the day
 dd		returns the day zero filled forcing two digits
 h		returns the hour
 hh		returns the hour zero filled forcing two digits
 n		returns the minute
 nn		returns the minute zero filled forcing two digits
 s		returns the second
 ss		returns the second zero filled forcing two digits
 l		returns millisecond
 else		returns itself
*/
begin
	
	--	Return blank if date is null.
	if	coalesce (@ValueDT, '') = '' return ''
	
	--	Return datetime as string in default format if format is blank.
	if	coalesce (@Format, '') = '' return convert (varchar, @ValueDT)
	
	declare	@FormattedText varchar(100),
		@Element varchar(255),
		@FormatChr varchar(1),
		@Counter int,
		@DatePart varchar (9),
		@Padding tinyint
	
	set @FormattedText = ''
	set @Counter = 1
	
	--	Loop through each format character.
	while	@Counter < len (@Format) + 1 begin
		set	@FormatChr = substring (@Format, @Counter, 1)
		--	Year:
		if	@FormatChr = 'y' begin
			--	See if next character is the same.
			if	substring (@Format, @Counter + 3, 1) = @FormatChr begin
				set	@FormattedText = @FormattedText + convert (varchar, datepart (yyyy, @ValueDT))
				set	@Counter = @Counter + 3
			end
			else begin
				set	@FormattedText = @FormattedText + right (convert(varchar, datepart (yyyy, @ValueDT)), 2)
				if	substring (@Format, @Counter+1, 1) = @FormatChr set @Counter = @Counter + 1
			end
		end
		--	Month:
		else if	@FormatChr in ('m', 'k') begin
			set	@DatePart = @FormatChr + @FormatChr
			--	See if next (3) characters is the same, unabbreviated day.
			if	substring (@Format, @Counter + 1, 3) = @FormatChr + @FormatChr + @FormatChr begin
				set	@Element = FT.fn_DateName (@FormatChr, @ValueDT)
				set	@Counter = @Counter + 3
			end
			else
			--	See if next (2) characters is the same, day abbreviation.
			if	substring (@Format, @Counter + 1, 2) = @FormatChr + @FormatChr begin
				set	@Element = convert (char (3), FT.fn_DateName (@FormatChr, @ValueDT))
				set	@Counter = @Counter + 2
			end
			--	See if next character is the same.
			else if	substring (@Format, @Counter + 1, 1) = @FormatChr begin
				set	@Element = FT.fn_ZeroPad (FT.fn_DatePart (@DatePart, @ValueDT), 2)
				set	@Counter = @Counter + 1 --2
			end
			else begin
				set	@Element = FT.fn_ZeroPad (FT.fn_DatePart (@DatePart, @ValueDT), 0)
				set	@Counter = @Counter + 0 --1
			end
			if	Ascii (@FormatChr) = Ascii (Upper (@FormatChr)) begin
				set	@Element = Upper (@Element)
			end
			set	@FormattedText = @FormattedText + @Element
		end
		--	Day of Week:
		else if	@FormatChr = 'k' begin
			set	@DatePart = @FormatChr + @FormatChr
			--	See if next (3) characters is the same, unabbreviated day.
			if	substring (@Format, @Counter + 1, 3) = @FormatChr + @FormatChr + @FormatChr begin
				set	@Element = FT.fn_DateName (@FormatChr, @ValueDT)
				set	@Counter = @Counter + 3
			end
			else
			--	See if next (2) characters is the same, day abbreviation.
			if	substring (@Format, @Counter + 1, 2) = @FormatChr + @FormatChr begin
				set	@Element = convert (char (3), FT.fn_DateName (@FormatChr, @ValueDT))
				set	@Counter = @Counter + 2
			end
			--	See if next character is the same.
			else if	substring (@Format, @Counter + 1, 1) = @FormatChr begin
				set	@Element = FT.fn_ZeroPad (FT.fn_DatePart (@DatePart, @ValueDT), 2)
				set	@Counter = @Counter + 1 --2
			end
			else begin
				set	@Element = FT.fn_ZeroPad (FT.fn_DatePart (@DatePart, @ValueDT), 0)
				set	@Counter = @Counter + 0 --1
			end
			set	@FormattedText = @FormattedText + @Element
		end
		--	Day of Year:
		else if	@FormatChr = 'j' begin
			set	@DatePart = @FormatChr + @FormatChr
			--	See if next (2) characters is the same, 3 digit julian.
			if	substring (@Format, @Counter + 1, 2) = @FormatChr + @FormatChr begin
				set	@Padding = 3
				set	@Counter = @Counter + 2 --3
			end
			--	See if next character is the same.
			else if	substring (@Format, @Counter + 1, 1) = @FormatChr begin
				set	@Padding = 2
				set	@Counter = @Counter + 1 --2
			end
			else begin
				set	@Padding = 0
				set	@Counter = @Counter + 0 --1
			end
			set	@FormattedText = @FormattedText + FT.fn_ZeroPad (FT.fn_DatePart (@DatePart, @ValueDT), @Padding)
		end
		--	Day of Month, Hour, Minute, Second:
		else if	@FormatChr in ('d','h','n','s') begin
			set	@DatePart = @FormatChr + @FormatChr
			--	See if next character is the same.
			if	substring (@Format, @Counter + 1, 1) = @FormatChr begin
				set	@Padding = 2
				set	@Counter = @Counter + 1 --2
			end
			else begin
				set	@Padding = 0
				set	@Counter = @Counter + 0 --1
			end
			set	@FormattedText = @FormattedText + FT.fn_ZeroPad (FT.fn_DatePart (@DatePart, @ValueDT), @Padding)
		end
		else if	@FormatChr = 'l'
		set @FormattedText = @FormattedText + convert(varchar, datepart(ms, @ValueDT))
		else
		set @FormattedText = @FormattedText + @FormatChr
		
		set @Counter = @Counter + 1
	end
	
	return  @FormattedText
end
GO
