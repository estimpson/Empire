SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [HN].[sys_CrossTab]
		@SQLSource 			varchar(8000),
		@ColFieldID			varchar(8000),
		@ColFieldName		varchar(8000),
		@ColFieldOrder		varchar(8000),
		@CalcFieldName		varchar(8000),
		@RowFieldNames		varchar(8000),
		@TempTableName		varchar(200) = null,
		@CalcOperation		varchar(50) = 'sum',		
		@Debug				bit = 0,
		@SourceFilter		varchar(8000) = null,
        @NumColOrdering     bit = 0,
        @RowTotals          varchar(100) = null,
        @ColTotals          varchar(100) = null,
        @OrderBy            varchar(8000) = null,
        @CalcFieldType      varchar(100) = 'int'
as


/*-----------------------------------------------------------------------------------------
' Procedure : sys_CrossTab
' DateTime  : 11 May 2006 17:59:56
' Author    : Keith Fletcher
' Ver       : 1.5
' Purpose   : Generate a cross-tab result set on a given SQL source
' To Check  :
' Changes   : KF - 23 May 2006 - Added a parameter to order the columns in the crosstab (Ver 1.1)
' Changes   : KF - 24 Aug 2006 - Added a parameter for the where clause of the source (Ver 1.2)
' Changes   : KF - 05 Oct 2006 - Added alpha/num column ordering, row and column totals (Ver 1.3)
' Changes   : KF - 06 Oct 2006 - Added CalcFieldType (Ver 1.4)
' Changes   : KF - 16 Mar 2007 - Touched up the code comments (Ver 1.5)
'-----------------------------------------------------------------------------------------*/



/*
-- Start of debugging stuff
declare		@SQLSource 			varchar(8000)
declare		@ColFieldID			varchar(8000)
declare		@ColFieldName		varchar(8000)
declare		@ColFieldOrder		varchar(8000)
declare		@CalcFieldName		varchar(8000)
declare		@RowFieldNames		varchar(8000)
declare		@TempTableName		varchar(200)
declare		@CalcOperation		varchar(50)
declare		@Debug				bit
declare		@SourceFilter		varchar(8000)
declare     @NumColOrdering     bit
declare     @RowTotals          varchar(100)
declare     @ColTotals          varchar(100)
declare     @OrderBy            varchar(8000)
declare     @CalcFieldType      varchar(100)


set		@SQLSource			= 'Northwind..[Order Details] Ord inner join Northwind..Products Prd on Ord.ProductID = Prd.ProductID'
set		@ColFieldID 		= 'Ord.ProductID'
set		@ColFieldName 		= 'Prd.ProductName'
set		@ColFieldOrder		= 'Prd.ProductName'
set		@CalcFieldName		= 'Quantity'
set		@RowFieldNames		= 'OrderID'
set		@TempTableName		= '#CrossTab'
set		@CalcOperation		= 'sum'		
set		@Debug				= 1
set		@SourceFilter		= null
set     @NumColOrdering     = 0
set     @RowTotals          = 'RowTotal'
set     @ColTotals          = 'ColTotal'
set     @OrderBy            = null
set     @CalcFieldType      = 'int'
-- End of debugging stuff
*/



set nocount on


-----=====******--~-~--~~---~-~---~~-~-~---~---~--~--~~~-~-~---~---~--~*****=====-----
--              Variable declaration


-- These are all my 'buffer' variables used to build up the SQL queries. If you wish to have a query that's
-- culture-aware, you'll need to change these to nvarchars. You'll also need to set the maximum size to
-- 4000 (@MaxVarSize)

declare     @MaxVarSize     int
set         @MaxVarSize     = 8000

declare	@SQLCase1	varchar(8000)	declare	@SQLCase2	varchar(8000)	declare	@SQLCase3	varchar(8000)
declare	@SQLCase4	varchar(8000)	declare	@SQLCase5	varchar(8000)	declare	@SQLCase6	varchar(8000)
declare	@SQLCase7	varchar(8000)	declare	@SQLCase8	varchar(8000)	declare	@SQLCase9	varchar(8000)
declare	@SQLCase10	varchar(8000)	declare	@SQLCase11	varchar(8000)	declare	@SQLCase12	varchar(8000)
declare	@SQLCase13	varchar(8000)	declare	@SQLCase14	varchar(8000)	declare	@SQLCase15	varchar(8000)
declare	@SQLCase16	varchar(8000)	declare	@SQLCase17	varchar(8000)	declare	@SQLCase18	varchar(8000)
declare	@SQLCase19	varchar(8000)	declare	@SQLCase20	varchar(8000)	declare	@SQLCase21	varchar(8000)
declare	@SQLCase22	varchar(8000)	declare	@SQLCase23	varchar(8000)	declare	@SQLCase24	varchar(8000)
declare	@SQLCase25	varchar(8000)	declare	@SQLCase26	varchar(8000)	declare	@SQLCase27	varchar(8000)
declare	@SQLCase28	varchar(8000)	declare	@SQLCase29	varchar(8000)	declare	@SQLCase30	varchar(8000)
declare	@SQLCase31	varchar(8000)	declare	@SQLCase32	varchar(8000)	declare	@SQLCase33	varchar(8000)
declare	@SQLCase34	varchar(8000)	declare	@SQLCase35	varchar(8000)	declare	@SQLCase36	varchar(8000)
declare	@SQLCase37	varchar(8000)	declare	@SQLCase38	varchar(8000)	declare	@SQLCase39	varchar(8000)
declare	@SQLCase40	varchar(8000)	declare	@SQLCase41	varchar(8000)	declare	@SQLCase42	varchar(8000)
declare	@SQLCase43	varchar(8000)	declare	@SQLCase44	varchar(8000)	declare	@SQLCase45	varchar(8000)
declare	@SQLCase46	varchar(8000)	declare	@SQLCase47	varchar(8000)	declare	@SQLCase48	varchar(8000)
declare	@SQLCase49	varchar(8000)	declare	@SQLCase50	varchar(8000)  

declare		@SQLCaseLine	varchar(8000)
declare 	@SQLCaseLevel	tinyint
declare 	@SQLCaseLen		int

declare	@SQLCol1	varchar(8000)	declare	@SQLCol2	varchar(8000)	declare	@SQLCol3	varchar(8000)
declare	@SQLCol4	varchar(8000)	declare	@SQLCol5	varchar(8000)	declare	@SQLCol6	varchar(8000)
declare	@SQLCol7	varchar(8000)	declare	@SQLCol8	varchar(8000)	declare	@SQLCol9	varchar(8000)
declare	@SQLCol10	varchar(8000)	declare	@SQLCol11	varchar(8000)	declare	@SQLCol12	varchar(8000)
declare	@SQLCol13	varchar(8000)	declare	@SQLCol14	varchar(8000)	declare	@SQLCol15	varchar(8000)
declare	@SQLCol16	varchar(8000)	declare	@SQLCol17	varchar(8000)	declare	@SQLCol18	varchar(8000)
declare	@SQLCol19	varchar(8000)	declare	@SQLCol20	varchar(8000)	declare	@SQLCol21	varchar(8000)
declare	@SQLCol22	varchar(8000)	declare	@SQLCol23	varchar(8000)	declare	@SQLCol24	varchar(8000)
declare	@SQLCol25	varchar(8000)	declare	@SQLCol26	varchar(8000)	declare	@SQLCol27	varchar(8000)
declare	@SQLCol28	varchar(8000)	declare	@SQLCol29	varchar(8000)	declare	@SQLCol30	varchar(8000)
declare	@SQLCol31	varchar(8000)	declare	@SQLCol32	varchar(8000)	declare	@SQLCol33	varchar(8000)
declare	@SQLCol34	varchar(8000)	declare	@SQLCol35	varchar(8000)	declare	@SQLCol36	varchar(8000)
declare	@SQLCol37	varchar(8000)	declare	@SQLCol38	varchar(8000)	declare	@SQLCol39	varchar(8000)
declare	@SQLCol40	varchar(8000)	declare	@SQLCol41	varchar(8000)	declare	@SQLCol42	varchar(8000)
declare	@SQLCol43	varchar(8000)	declare	@SQLCol44	varchar(8000)	declare	@SQLCol45	varchar(8000)
declare	@SQLCol46	varchar(8000)	declare	@SQLCol47	varchar(8000)	declare	@SQLCol48	varchar(8000)
declare	@SQLCol49	varchar(8000)	declare	@SQLCol50	varchar(8000)

declare		@SQLColLine		varchar(8000)
declare 	@SQLColLevel	tinyint
declare 	@SQLColLen		int

declare	@SQLTot1	varchar(8000)	declare	@SQLTot2	varchar(8000)	declare	@SQLTot3	varchar(8000)
declare	@SQLTot4	varchar(8000)	declare	@SQLTot5	varchar(8000)	declare	@SQLTot6	varchar(8000)
declare	@SQLTot7	varchar(8000)	declare	@SQLTot8	varchar(8000)	declare	@SQLTot9	varchar(8000)
declare	@SQLTot10	varchar(8000)	declare	@SQLTot11	varchar(8000)	declare	@SQLTot12	varchar(8000)
declare	@SQLTot13	varchar(8000)	declare	@SQLTot14	varchar(8000)	declare	@SQLTot15	varchar(8000)
declare	@SQLTot16	varchar(8000)	declare	@SQLTot17	varchar(8000)	declare	@SQLTot18	varchar(8000)
declare	@SQLTot19	varchar(8000)	declare	@SQLTot20	varchar(8000)	declare	@SQLTot21	varchar(8000)
declare	@SQLTot22	varchar(8000)	declare	@SQLTot23	varchar(8000)	declare	@SQLTot24	varchar(8000)
declare	@SQLTot25	varchar(8000)	declare	@SQLTot26	varchar(8000)	declare	@SQLTot27	varchar(8000)
declare	@SQLTot28	varchar(8000)	declare	@SQLTot29	varchar(8000)	declare	@SQLTot30	varchar(8000)
declare	@SQLTot31	varchar(8000)	declare	@SQLTot32	varchar(8000)	declare	@SQLTot33	varchar(8000)
declare	@SQLTot34	varchar(8000)	declare	@SQLTot35	varchar(8000)	declare	@SQLTot36	varchar(8000)
declare	@SQLTot37	varchar(8000)	declare	@SQLTot38	varchar(8000)	declare	@SQLTot39	varchar(8000)
declare	@SQLTot40	varchar(8000)	declare	@SQLTot41	varchar(8000)	declare	@SQLTot42	varchar(8000)
declare	@SQLTot43	varchar(8000)	declare	@SQLTot44	varchar(8000)	declare	@SQLTot45	varchar(8000)
declare	@SQLTot46	varchar(8000)	declare	@SQLTot47	varchar(8000)	declare	@SQLTot48	varchar(8000)
declare	@SQLTot49	varchar(8000)	declare	@SQLTot50	varchar(8000)

declare		@SQLTotLine		varchar(8000)
declare 	@SQLTotLevel	tinyint
declare 	@SQLTotLen		int

declare	@SQLIns1	varchar(8000)	declare	@SQLIns2	varchar(8000)	declare	@SQLIns3	varchar(8000)
declare	@SQLIns4	varchar(8000)	declare	@SQLIns5	varchar(8000)	declare	@SQLIns6	varchar(8000)
declare	@SQLIns7	varchar(8000)	declare	@SQLIns8	varchar(8000)	declare	@SQLIns9	varchar(8000)
declare	@SQLIns10	varchar(8000)	declare	@SQLIns11	varchar(8000)	declare	@SQLIns12	varchar(8000)
declare	@SQLIns13	varchar(8000)	declare	@SQLIns14	varchar(8000)	declare	@SQLIns15	varchar(8000)
declare	@SQLIns16	varchar(8000)	declare	@SQLIns17	varchar(8000)	declare	@SQLIns18	varchar(8000)
declare	@SQLIns19	varchar(8000)	declare	@SQLIns20	varchar(8000)	declare	@SQLIns21	varchar(8000)
declare	@SQLIns22	varchar(8000)	declare	@SQLIns23	varchar(8000)	declare	@SQLIns24	varchar(8000)
declare	@SQLIns25	varchar(8000)	declare	@SQLIns26	varchar(8000)	declare	@SQLIns27	varchar(8000)
declare	@SQLIns28	varchar(8000)	declare	@SQLIns29	varchar(8000)	declare	@SQLIns30	varchar(8000)

declare		@SQLInsLine		varchar(8000)
declare 	@SQLInsLevel	tinyint
declare 	@SQLInsLen		int

declare	@SQLTtC1	varchar(8000)	declare	@SQLTtC2	varchar(8000)	declare	@SQLTtC3	varchar(8000)
declare	@SQLTtC4	varchar(8000)	declare	@SQLTtC5	varchar(8000)	declare	@SQLTtC6	varchar(8000)
declare	@SQLTtC7	varchar(8000)	declare	@SQLTtC8	varchar(8000)	declare	@SQLTtC9	varchar(8000)
declare	@SQLTtC10	varchar(8000)	declare	@SQLTtC11	varchar(8000)	declare	@SQLTtC12	varchar(8000)
declare	@SQLTtC13	varchar(8000)	declare	@SQLTtC14	varchar(8000)	declare	@SQLTtC15	varchar(8000)
declare	@SQLTtC16	varchar(8000)	declare	@SQLTtC17	varchar(8000)	declare	@SQLTtC18	varchar(8000)
declare	@SQLTtC19	varchar(8000)	declare	@SQLTtC20	varchar(8000)	declare	@SQLTtC21	varchar(8000)
declare	@SQLTtC22	varchar(8000)	declare	@SQLTtC23	varchar(8000)	declare	@SQLTtC24	varchar(8000)
declare	@SQLTtC25	varchar(8000)	declare	@SQLTtC26	varchar(8000)	declare	@SQLTtC27	varchar(8000)
declare	@SQLTtC28	varchar(8000)	declare	@SQLTtC29	varchar(8000)	declare	@SQLTtC30	varchar(8000)

declare		@SQLTtCLine		varchar(8000)
declare 	@SQLTtCLevel	tinyint
declare 	@SQLTtCLen		int


declare		@ColID			varchar(100)
declare		@ColName		varchar(200)
declare		@ColTotal		varchar(100)
declare     @GrandTotal     varchar(100)
declare		@ColNo			int

declare		@StrippedRowFieldNames	varchar(8000)
declare     @CalcScript     varchar(100)

declare		@NewLine		char(2)

declare		@AddWhere		varchar(8000)
declare     @AddOrder       varchar(8000)


-----=====******--~-~--~~---~-~---~~-~-~---~---~--~--~~~-~-~---~---~--~*****=====-----
--              Variable initialisation


set	@SQLCase1	= ''	set	@SQLCase2	= ''	set	@SQLCase3	= ''	set	@SQLCase4	= ''
set	@SQLCase5	= ''	set	@SQLCase6	= ''	set	@SQLCase7	= ''	set	@SQLCase8	= ''
set	@SQLCase9	= ''	set	@SQLCase10	= ''	set	@SQLCase11	= ''	set	@SQLCase12	= ''
set	@SQLCase13	= ''	set	@SQLCase14	= ''	set	@SQLCase15	= ''	set	@SQLCase16	= ''
set	@SQLCase17	= ''	set	@SQLCase18	= ''	set	@SQLCase19	= ''	set	@SQLCase20	= ''
set	@SQLCase21	= ''	set	@SQLCase22	= ''	set	@SQLCase23	= ''	set	@SQLCase24	= ''
set	@SQLCase25	= ''	set	@SQLCase26	= ''	set	@SQLCase27	= ''	set	@SQLCase28	= ''
set	@SQLCase29	= ''	set	@SQLCase30	= ''	set	@SQLCase31	= ''	set	@SQLCase32	= ''
set	@SQLCase33	= ''	set	@SQLCase34	= ''	set	@SQLCase35	= ''	set	@SQLCase36	= ''
set	@SQLCase37	= ''	set	@SQLCase38	= ''	set	@SQLCase39	= ''	set	@SQLCase40	= ''
set	@SQLCase41	= ''	set	@SQLCase42	= ''	set	@SQLCase43	= ''	set	@SQLCase44	= ''
set	@SQLCase45	= ''	set	@SQLCase46	= ''	set	@SQLCase47	= ''	set	@SQLCase48	= ''
set	@SQLCase49	= ''	set	@SQLCase50	= ''

set		@SQLCaseLine		= ''
set		@SQLCaseLevel		= 1
set		@SQLCaseLen		    = 0

set	@SQLCol1	= ''	set	@SQLCol2	= ''	set	@SQLCol3	= ''	set	@SQLCol4	= ''
set	@SQLCol5	= ''	set	@SQLCol6	= ''	set	@SQLCol7	= ''	set	@SQLCol8	= ''
set	@SQLCol9	= ''	set	@SQLCol10	= ''	set	@SQLCol11	= ''	set	@SQLCol12	= ''
set	@SQLCol13	= ''	set	@SQLCol14	= ''	set	@SQLCol15	= ''	set	@SQLCol16	= ''
set	@SQLCol17	= ''	set	@SQLCol18	= ''	set	@SQLCol19	= ''	set	@SQLCol20	= ''
set	@SQLCol21	= ''	set	@SQLCol22	= ''	set	@SQLCol23	= ''	set	@SQLCol24	= ''
set	@SQLCol25	= ''	set	@SQLCol26	= ''	set	@SQLCol27	= ''	set	@SQLCol28	= ''
set	@SQLCol29	= ''	set	@SQLCol30	= ''	set	@SQLCol31	= ''	set	@SQLCol32	= ''
set	@SQLCol33	= ''	set	@SQLCol34	= ''	set	@SQLCol35	= ''	set	@SQLCol36	= ''
set	@SQLCol37	= ''	set	@SQLCol38	= ''	set	@SQLCol39	= ''	set	@SQLCol40	= ''
set	@SQLCol41	= ''	set	@SQLCol42	= ''	set	@SQLCol43	= ''	set	@SQLCol44	= ''
set	@SQLCol45	= ''	set	@SQLCol46	= ''	set	@SQLCol47	= ''	set	@SQLCol48	= ''
set	@SQLCol49	= ''	set	@SQLCol50	= ''	

set		@SQLColLine		    = ''
set		@SQLColLevel		= 1
set		@SQLColLen		    = 0

set	@SQLTot1	= ''	set	@SQLTot2	= ''	set	@SQLTot3	= ''	set	@SQLTot4	= ''
set	@SQLTot5	= ''	set	@SQLTot6	= ''	set	@SQLTot7	= ''	set	@SQLTot8	= ''
set	@SQLTot9	= ''	set	@SQLTot10	= ''	set	@SQLTot11	= ''	set	@SQLTot12	= ''
set	@SQLTot13	= ''	set	@SQLTot14	= ''	set	@SQLTot15	= ''	set	@SQLTot16	= ''
set	@SQLTot17	= ''	set	@SQLTot18	= ''	set	@SQLTot19	= ''	set	@SQLTot20	= ''
set	@SQLTot21	= ''	set	@SQLTot22	= ''	set	@SQLTot23	= ''	set	@SQLTot24	= ''
set	@SQLTot25	= ''	set	@SQLTot26	= ''	set	@SQLTot27	= ''	set	@SQLTot28	= ''
set	@SQLTot29	= ''	set	@SQLTot30	= ''	set	@SQLTot31	= ''	set	@SQLTot32	= ''
set	@SQLTot33	= ''	set	@SQLTot34	= ''	set	@SQLTot35	= ''	set	@SQLTot36	= ''
set	@SQLTot37	= ''	set	@SQLTot38	= ''	set	@SQLTot39	= ''	set	@SQLTot40	= ''
set	@SQLTot41	= ''	set	@SQLTot42	= ''	set	@SQLTot43	= ''	set	@SQLTot44	= ''
set	@SQLTot45	= ''	set	@SQLTot46	= ''	set	@SQLTot47	= ''	set	@SQLTot48	= ''
set	@SQLTot49	= ''	set	@SQLTot50	= ''	

set		@SQLTotLine		    = ''
set		@SQLTotLevel		= 1
set		@SQLTotLen		    = 0

set	@SQLIns1	= ''	set	@SQLIns2	= ''	set	@SQLIns3	= ''	set	@SQLIns4	= ''
set	@SQLIns5	= ''	set	@SQLIns6	= ''	set	@SQLIns7	= ''	set	@SQLIns8	= ''
set	@SQLIns9	= ''	set	@SQLIns10	= ''	set	@SQLIns11	= ''	set	@SQLIns12	= ''
set	@SQLIns13	= ''	set	@SQLIns14	= ''	set	@SQLIns15	= ''	set	@SQLIns16	= ''
set	@SQLIns17	= ''	set	@SQLIns18	= ''	set	@SQLIns19	= ''	set	@SQLIns20	= ''
set	@SQLIns21	= ''	set	@SQLIns22	= ''	set	@SQLIns23	= ''	set	@SQLIns24	= ''
set	@SQLIns25	= ''	set	@SQLIns26	= ''	set	@SQLIns27	= ''	set	@SQLIns28	= ''
set	@SQLIns29	= ''	set	@SQLIns30	= ''	

set		@SQLInsLine		    = ''
set		@SQLInsLevel		= 1
set		@SQLInsLen		    = 0

set	@SQLTtC1	= ''	set	@SQLTtC2	= ''	set	@SQLTtC3	= ''	set	@SQLTtC4	= ''
set	@SQLTtC5	= ''	set	@SQLTtC6	= ''	set	@SQLTtC7	= ''	set	@SQLTtC8	= ''
set	@SQLTtC9	= ''	set	@SQLTtC10	= ''	set	@SQLTtC11	= ''	set	@SQLTtC12	= ''
set	@SQLTtC13	= ''	set	@SQLTtC14	= ''	set	@SQLTtC15	= ''	set	@SQLTtC16	= ''
set	@SQLTtC17	= ''	set	@SQLTtC18	= ''	set	@SQLTtC19	= ''	set	@SQLTtC20	= ''
set	@SQLTtC21	= ''	set	@SQLTtC22	= ''	set	@SQLTtC23	= ''	set	@SQLTtC24	= ''
set	@SQLTtC25	= ''	set	@SQLTtC26	= ''	set	@SQLTtC27	= ''	set	@SQLTtC28	= ''
set	@SQLTtC29	= ''	set	@SQLTtC30	= ''	

set		@SQLTtCLine		    = ''
set		@SQLTtCLevel		= 1
set		@SQLTtCLen		    = 0


set		@ColNo			    = 1

set		@StrippedRowFieldNames	= @RowFieldNames

set		@NewLine		    = char(13) + char(10)


if			@SourceFilter is null
	set			@AddWhere = ''
else
	set			@AddWhere = ' and ' + @SourceFilter

if			@OrderBy is null
	set			@AddOrder = ''
else
	set			@AddOrder = ' order by ' + @OrderBy


-----=====******--~-~--~~---~-~---~~-~-~---~---~--~--~~~-~-~---~---~--~*****=====-----
--              Get the column names and ID's

-- We want to collect a list of all the columns that we need to create for the cross tab.
-- This is done by doing a select on our source data, and inserting the first occurence 
-- of each data item that we find in the field pointed to by @ColFieldID. While we're at
-- it, we might as well put the column in the correct display order.

create		table #Columns		(ColID		varchar(100),
					            ColName		varchar(200),
                                ColOrderNum bigint identity(1,1))


-- Add a field to keep a running total of the column values. This needs to be added 
-- dynamically, as we don't know the data type of this field upfront.
exec    ('alter table #Columns add ColTotal ' + @CalcFieldType)


-- If we need to calculate the column totals, build the command that we need to calculate
-- it. Both the aggregate type and the data type are not known, so we do it dynamically. 
-- If we don't need to calculate column totals, we'll set it to null.
if      @ColTotals is not null 
    set     @CalcScript     = @CalcOperation + '(cast(' + @CalcFieldName  + ' as ' + @CalcFieldType + '))'
else
    set     @CalcScript     = '0'


-- Here's were it all comes together. We create an INSERT statement that adds all of the 
-- column ID's and names to our temp table. We trim the fields and calculate the column
-- totals. This is the first hit on our source data.

-- We're not worried about the ordering of the columns...
if		@ColFieldOrder is null
	exec	('insert into #Columns (ColID, ColName, ColTotal) select ltrim(rtrim(isnull(cast(' 
            + @ColFieldID + ' as varchar(100)), ''''))), ltrim(rtrim(isnull(cast(' 
            + @ColFieldName + ' as varchar(100)), ''''))), ' + @CalcScript + ' from ' + @SQLSource 
            + ' where 1=1 ' + @AddWhere + ' group by ' + @ColFieldID + ', ' + @ColFieldName)

else
begin
-- We are concerned with column ordering, and they must be sorted alphanumerically
    if      @NumColOrdering = 0
	    exec	('insert into #Columns (ColID, ColName, ColTotal) select ltrim(rtrim(isnull(cast(' 
                + @ColFieldID + ' as varchar(100)), ''''))), ltrim(rtrim(isnull(cast(' + @ColFieldName + 
			    ' as varchar(100)), ''''))), ' + @CalcScript + ' from ' + @SQLSource + ' where 1=1 ' 
                + @AddWhere + ' group by ' + @ColFieldID + ', ' + @ColFieldName + ', ' + @ColFieldOrder
                + ' order by cast(ltrim(rtrim(isnull(' + @ColFieldOrder + ' , ''''))) as varchar(100))')
    else
-- We are concerned with column ordering, and they must be sorted numerically
	    exec	('insert into #Columns (ColID, ColName, ColTotal)select ltrim(rtrim(isnull(cast(' 
                + @ColFieldID + ' as varchar(100)), ''''))), ltrim(rtrim(isnull(cast(' + @ColFieldName + 
			    ' as varchar(100)), ''''))), ' + @CalcScript + ' from ' + @SQLSource + ' where 1=1 ' 
                + @AddWhere + ' group by ' + @ColFieldID + ', ' + @ColFieldName + ', ' + @ColFieldOrder
                + ' order by cast(isnull(' + @ColFieldOrder + ' , 0) as decimal(24,8))')
end


-- If we've enabled both column and row totals, we'll need to add one extra cell to the 
-- bottom corner that holds the grand total.
if  @ColTotals is not null and
    @RowTotals is not null
    set     @GrandTotal = 'cast(' + (select cast(sum(ColTotal) as varchar(100)) from #Columns) + ' as ' + @CalcFieldType + ')'
set     @GrandTotal = isnull(@GrandTotal, '')

-----=====******--~-~--~~---~-~---~~-~-~---~---~--~--~~~-~-~---~---~--~*****=====-----
--              Strip the table names and/or aliases from the row fields


-- Things start to get interesting now. If we've used a portion of a SELECT statement as 
-- our source data, it is possible that some of the fields in the @RowFieldNames param
-- are prefixed with either the table name or table alias. We need to strip these out, 
-- so that we're left with the bare field name.

declare		@StrippedField		varchar(200)
declare 	@Index 			int
declare 	@Index2			int
declare		@LastIndex		int
declare		@DeAliasedField		varchar(200)

set		@LastIndex		= 1
set		@Index			= 9000
set		@StrippedRowFieldNames 	= ''
set		@DeAliasedField		= ''

-- Loop through each row field
while		@Index > 0
begin

	set		@Index			= charindex(',', @RowFieldNames, @LastIndex)	

	if	@Index = 0
		set @StrippedField = ltrim(rtrim(substring(@RowFieldNames, @LastIndex, len(@RowFieldNames))))
	else
		set @StrippedField = ltrim(rtrim(substring(@RowFieldNames, @LastIndex, @Index - @LastIndex)))


	-- Strip the alias for the outer query
	set 		@Index2		= charindex('.', @StrippedField)
	if 		@Index2 > 0
		set @DeAliasedField = substring(@StrippedField, @Index2 + 1, len(@StrippedField)) 
	else
		set @DeAliasedField = @StrippedField

    -- Append the stripped field name to our SELECT field list. Insert comma's where appropriate
	set @StrippedRowFieldNames = @StrippedRowFieldNames + case len(@StrippedRowFieldNames) when 0 then '' else ',' end + @DeAliasedField 


    -- If the output of the cross tab is to be inserted into a given temp table, we'll need 
    -- to add the fields from @RowFieldNames into the temp table. This is also the start of
    -- the 'debugging' outputs.
	if		@TempTableName is not null
	begin
		if 	@Debug = 1
			print	'alter table ' + @TempTableName + ' add [' + @DeAliasedField + '] varchar(100)'
		exec		('alter table ' + @TempTableName + ' add [' + @DeAliasedField + '] varchar(100)')
	end

	set		@LastIndex		= @Index + 1
end


-----=====******--~-~--~~---~-~---~~-~-~---~---~--~--~~~-~-~---~---~--~*****=====-----
--              Define column cursor


-- Right, we're now in the heart and soul of the stored procedure. Here we're going to
-- define a cursor that handles each column (already populated in the #Columns table)
-- in turn, and builds the CASE statement to catch the values that should be considered
-- when calculating that column.

-- Standard cursor declaration stuff
declare			curColCursor 	cursor read_only for
select 			ColID, ColName, cast(ColTotal as varchar(100)) ColTotal
from			#Columns
order by		ColOrderNum
 
open			curColCursor

fetch next
from 			curColCursor 
into			@ColID, @ColName, @ColTotal

while 	(@@fetch_status <> -1)
begin
	if 		(@@fetch_status <> -2)
	begin

		-- If the field name is empty, we'll add a generic name for it. This would have 
        -- happened if we're using a @ColFieldName mapping, and a field name was not
        -- found that linked to the @ColFieldID. These generic field names will run in
        -- sequence; Field1, Field2 etc.
		if @ColName = '' 
			set	@ColName = 'Field ' + cast(@ColNo as varchar(50))


		-- Add the column to the temp table
		if		@TempTableName is not null
		begin
			if 		@Debug = 1
				print 		'alter table ' + @TempTableName + ' add [' + @ColName + '] ' + @CalcFieldType
			exec		('alter table ' + @TempTableName + ' add [' + @ColName + '] ' + @CalcFieldType)
		end


		-- Build the case statement for this column. This will form part of the 'inner' SELECT
		set	@SQLCaseLine = ', cast(case when ' + @ColFieldID + ' = ''' + cast(@ColID as varchar(50)) + 
					''' then isnull(' + @CalcOperation + '(' + @CalcFieldName + '), 0) else 0 end as ' + 
                    @CalcFieldType + ')  [' + @ColName + ']' + @NewLine

        -- Build the statement to combine the individual entries into a proper cross tab. This
        -- forms the SELECT field list of the 'outer' SELECT.
		set 	@SQLColLine = ', sum([' + @ColName + ']) [' + @ColName + '] ' + @NewLine

        -- Build up the column totals query
        if      @ColTotals is not null
		    set 	@SQLTtCLine = ', cast(' + @ColTotal + ' as ' + @CalcFieldType + ')'

        -- Build up the row totals query
        if      @RowTotals is not null
        begin
            if      (@SQLTotLen + @SQLTotLevel) > 1
                set     @SQLTotLine = ' + sum([' + @ColName + '])' + @NewLine
            else
                set     @SQLTotLine = ' sum([' + @ColName + '])' + @NewLine
        end
        
        /*
        if      @RowTotals is not null
            set     @SQLTotLine = ' + sum([' + @ColName + '])' + @NewLine
        */

        -- If we're saving the cross tab to a temp table, build up the temp
        -- table INSERT query
		if	@TempTableName is not null
			set 	@SQLInsLine = ', [' + @ColName + '] ' + @NewLine


		-- Varchar's have a maximum length of 8000, and nvarchar's of 4000 (in SQL 2000, at least).
        -- If we have a large number of columns, we'll exceed that length very quickly. Seeing that
        -- we can't append all of this to a TEXT field, and have sp_executesql run from a TEXT type,
        -- we'll need to find another workaround. I've basically declared a collection of varchar's
        -- (I'm sure you didn't miss those at the beginning of the proc!). We'll keep appending data
        -- to the variable we're currently working with, and once we're about to exceed it's capacity,
        -- we'll switch to the next one in line. At the end, we concatenate all the strings together
        -- and run it as one BIG statement. If you have inordinately large queries, and find that you
        -- are running out of space, you'll need to add a few more of these 'buffer' variables. I
        -- think that if you look at the code closely enough you'll figure out how to add a few more.

        -- NB:!! If you want to use nvarchar's instead if varchars, you'll need to set @MaxVarSize
        -- down to 4000. You should then also prefix all the strings with a 'N.
		if	len(@SQLCaseLine) + @SQLCaseLen > @MaxVarSize
		begin
			set	@SQLCaseLine = '--*** Line ' + cast(@SQLCaseLevel as varchar(50)) + @NewLine + @SQLCaseLine
			set	@SQLCaseLevel = @SQLCaseLevel + 1

			if 	@SQLCaseLevel > 50
				raiserror ('Case level was too high (ran out of variables). %d', 16, 1, @SQLCaseLevel)

			set	@SQLCaseLen = 0
		end
		if	len(@SQLColLine) + @SQLColLen > @MaxVarSize
		begin
			set	@SQLColLevel = @SQLColLevel + 1

			if 	@SQLColLevel > 50
				raiserror ('Col level was too high (ran out of variables). %d', 16, 1, @SQLColLevel)

			set	@SQLColLen = 0
		end
		if	len(@SQLTotLine) + @SQLTotLen > @MaxVarSize
		begin
			set	@SQLTotLevel = @SQLTotLevel + 1

			if 	@SQLTotLevel > 50
				raiserror ('Tot level was too high (ran out of variables). %d', 16, 1, @SQLTotLevel)

			set	@SQLTotLen = 0
		end
		if	len(@SQLTtCLine) + @SQLTtCLen > @MaxVarSize
		begin
			set	@SQLTtCLevel = @SQLTtCLevel + 1

			if 	@SQLTtCLevel > 50
				raiserror ('Tot level was too high (ran out of variables). %d', 16, 1, @SQLTtCLevel)

			set	@SQLTtCLen = 0
		end
		if	@TempTableName is not null
		begin
			if	len(@SQLInsLine) + @SQLInsLen > @MaxVarSize
			begin
				set	@SQLInsLevel = @SQLInsLevel + 1
	
				if 	@SQLInsLevel > 30
					raiserror ('Ins level was too high (ran out of variables). %d', 16, 1, @SQLInsLevel)
	
				set	@SQLInsLen = 0
			end	
		end

        -- Keep a running count of how full our current variable is
		set	@SQLCaseLen = @SQLCaseLen + len(@SQLCaseLine)	
		set	@SQLColLen = @SQLColLen + len(@SQLColLine)	
		set	@SQLTotLen = @SQLTotLen + len(@SQLTotLine)	
		set	@SQLTtCLen = @SQLTtCLen + len(@SQLTtCLine)	
		if	@TempTableName is not null
			set	@SQLInsLen = @SQLInsLen + len(@SQLInsLine)	


		-- Add the line to the appropriate column variable
		if		@SQLCaseLevel = 1	set	@SQLCase1 	= @SQLCase1 + @SQLCaseLine
		else if		@SQLCaseLevel = 2	set	@SQLCase2 	= @SQLCase2 + @SQLCaseLine
		else if		@SQLCaseLevel = 3	set	@SQLCase3 	= @SQLCase3 + @SQLCaseLine
		else if		@SQLCaseLevel = 4	set	@SQLCase4 	= @SQLCase4 + @SQLCaseLine
		else if		@SQLCaseLevel = 5	set	@SQLCase5 	= @SQLCase5 + @SQLCaseLine
		else if		@SQLCaseLevel = 6	set	@SQLCase6 	= @SQLCase6 + @SQLCaseLine
		else if		@SQLCaseLevel = 7	set	@SQLCase7 	= @SQLCase7 + @SQLCaseLine
		else if		@SQLCaseLevel = 8	set	@SQLCase8 	= @SQLCase8 + @SQLCaseLine
		else if		@SQLCaseLevel = 9	set	@SQLCase9 	= @SQLCase9 + @SQLCaseLine
		else if		@SQLCaseLevel = 10	set	@SQLCase10 	= @SQLCase10 + @SQLCaseLine
		else if		@SQLCaseLevel = 11	set	@SQLCase11 	= @SQLCase11 + @SQLCaseLine
		else if		@SQLCaseLevel = 12	set	@SQLCase12 	= @SQLCase12 + @SQLCaseLine
		else if		@SQLCaseLevel = 13	set	@SQLCase13 	= @SQLCase13 + @SQLCaseLine
		else if		@SQLCaseLevel = 14	set	@SQLCase14 	= @SQLCase14 + @SQLCaseLine
		else if		@SQLCaseLevel = 15	set	@SQLCase15 	= @SQLCase15 + @SQLCaseLine
		else if		@SQLCaseLevel = 16	set	@SQLCase16 	= @SQLCase16 + @SQLCaseLine
		else if		@SQLCaseLevel = 17	set	@SQLCase17 	= @SQLCase17 + @SQLCaseLine
		else if		@SQLCaseLevel = 18	set	@SQLCase18 	= @SQLCase18 + @SQLCaseLine
		else if		@SQLCaseLevel = 19	set	@SQLCase19 	= @SQLCase19 + @SQLCaseLine
		else if		@SQLCaseLevel = 20	set	@SQLCase20 	= @SQLCase20 + @SQLCaseLine
		else if		@SQLCaseLevel = 21	set	@SQLCase21 	= @SQLCase21 + @SQLCaseLine
		else if		@SQLCaseLevel = 22	set	@SQLCase22 	= @SQLCase22 + @SQLCaseLine
		else if		@SQLCaseLevel = 23	set	@SQLCase23 	= @SQLCase23 + @SQLCaseLine
		else if		@SQLCaseLevel = 24	set	@SQLCase24 	= @SQLCase24 + @SQLCaseLine
		else if		@SQLCaseLevel = 25	set	@SQLCase25 	= @SQLCase25 + @SQLCaseLine
		else if		@SQLCaseLevel = 26	set	@SQLCase26 	= @SQLCase26 + @SQLCaseLine
		else if		@SQLCaseLevel = 27	set	@SQLCase27 	= @SQLCase27 + @SQLCaseLine
		else if		@SQLCaseLevel = 28	set	@SQLCase28 	= @SQLCase28 + @SQLCaseLine
		else if		@SQLCaseLevel = 29	set	@SQLCase29 	= @SQLCase29 + @SQLCaseLine
		else if		@SQLCaseLevel = 30	set	@SQLCase30 	= @SQLCase30 + @SQLCaseLine
		else if		@SQLCaseLevel = 31	set	@SQLCase31 	= @SQLCase31 + @SQLCaseLine
		else if		@SQLCaseLevel = 32	set	@SQLCase32 	= @SQLCase32 + @SQLCaseLine
		else if		@SQLCaseLevel = 33	set	@SQLCase33 	= @SQLCase33 + @SQLCaseLine
		else if		@SQLCaseLevel = 34	set	@SQLCase34 	= @SQLCase34 + @SQLCaseLine
		else if		@SQLCaseLevel = 35	set	@SQLCase35 	= @SQLCase35 + @SQLCaseLine
		else if		@SQLCaseLevel = 36	set	@SQLCase36 	= @SQLCase36 + @SQLCaseLine
		else if		@SQLCaseLevel = 37	set	@SQLCase37 	= @SQLCase37 + @SQLCaseLine
		else if		@SQLCaseLevel = 38	set	@SQLCase38 	= @SQLCase38 + @SQLCaseLine
		else if		@SQLCaseLevel = 39	set	@SQLCase39 	= @SQLCase39 + @SQLCaseLine
		else if		@SQLCaseLevel = 40	set	@SQLCase40 	= @SQLCase40 + @SQLCaseLine
		else if		@SQLCaseLevel = 41	set	@SQLCase41 	= @SQLCase41 + @SQLCaseLine
		else if		@SQLCaseLevel = 42	set	@SQLCase42 	= @SQLCase42 + @SQLCaseLine
		else if		@SQLCaseLevel = 43	set	@SQLCase43 	= @SQLCase43 + @SQLCaseLine
		else if		@SQLCaseLevel = 44	set	@SQLCase44 	= @SQLCase44 + @SQLCaseLine
		else if		@SQLCaseLevel = 45	set	@SQLCase45 	= @SQLCase45 + @SQLCaseLine
		else if		@SQLCaseLevel = 46	set	@SQLCase46 	= @SQLCase46 + @SQLCaseLine
		else if		@SQLCaseLevel = 47	set	@SQLCase47 	= @SQLCase47 + @SQLCaseLine
		else if		@SQLCaseLevel = 48	set	@SQLCase48 	= @SQLCase48 + @SQLCaseLine
		else if		@SQLCaseLevel = 49	set	@SQLCase49 	= @SQLCase49 + @SQLCaseLine
		else if		@SQLCaseLevel = 50	set	@SQLCase50 	= @SQLCase50 + @SQLCaseLine



		if		@SQLColLevel = 1	set	@SQLCol1 	= @SQLCol1 + @SQLColLine
		else if		@SQLColLevel = 2	set	@SQLCol2 	= @SQLCol2 + @SQLColLine
		else if		@SQLColLevel = 3	set	@SQLCol3 	= @SQLCol3 + @SQLColLine
		else if		@SQLColLevel = 4	set	@SQLCol4 	= @SQLCol4 + @SQLColLine
		else if		@SQLColLevel = 5	set	@SQLCol5 	= @SQLCol5 + @SQLColLine
		else if		@SQLColLevel = 6	set	@SQLCol6 	= @SQLCol6 + @SQLColLine
		else if		@SQLColLevel = 7	set	@SQLCol7 	= @SQLCol7 + @SQLColLine
		else if		@SQLColLevel = 8	set	@SQLCol8 	= @SQLCol8 + @SQLColLine
		else if		@SQLColLevel = 9	set	@SQLCol9 	= @SQLCol9 + @SQLColLine
		else if		@SQLColLevel = 10	set	@SQLCol10 	= @SQLCol10 + @SQLColLine
		else if		@SQLColLevel = 11	set	@SQLCol11 	= @SQLCol11 + @SQLColLine
		else if		@SQLColLevel = 12	set	@SQLCol12 	= @SQLCol12 + @SQLColLine
		else if		@SQLColLevel = 13	set	@SQLCol13 	= @SQLCol13 + @SQLColLine
		else if		@SQLColLevel = 14	set	@SQLCol14 	= @SQLCol14 + @SQLColLine
		else if		@SQLColLevel = 15	set	@SQLCol15 	= @SQLCol15 + @SQLColLine
		else if		@SQLColLevel = 16	set	@SQLCol16 	= @SQLCol16 + @SQLColLine
		else if		@SQLColLevel = 17	set	@SQLCol17 	= @SQLCol17 + @SQLColLine
		else if		@SQLColLevel = 18	set	@SQLCol18 	= @SQLCol18 + @SQLColLine
		else if		@SQLColLevel = 19	set	@SQLCol19 	= @SQLCol19 + @SQLColLine
		else if		@SQLColLevel = 20	set	@SQLCol20 	= @SQLCol20 + @SQLColLine
		else if		@SQLColLevel = 21	set	@SQLCol21 	= @SQLCol21 + @SQLColLine
		else if		@SQLColLevel = 22	set	@SQLCol22 	= @SQLCol22 + @SQLColLine
		else if		@SQLColLevel = 23	set	@SQLCol23 	= @SQLCol23 + @SQLColLine
		else if		@SQLColLevel = 24	set	@SQLCol24 	= @SQLCol24 + @SQLColLine
		else if		@SQLColLevel = 25	set	@SQLCol25 	= @SQLCol25 + @SQLColLine
		else if		@SQLColLevel = 26	set	@SQLCol26 	= @SQLCol26 + @SQLColLine
		else if		@SQLColLevel = 27	set	@SQLCol27 	= @SQLCol27 + @SQLColLine
		else if		@SQLColLevel = 28	set	@SQLCol28 	= @SQLCol28 + @SQLColLine
		else if		@SQLColLevel = 29	set	@SQLCol29 	= @SQLCol29 + @SQLColLine
		else if		@SQLColLevel = 30	set	@SQLCol30 	= @SQLCol30 + @SQLColLine
		else if		@SQLColLevel = 31	set	@SQLCol31 	= @SQLCol31 + @SQLColLine
		else if		@SQLColLevel = 32	set	@SQLCol32 	= @SQLCol32 + @SQLColLine
		else if		@SQLColLevel = 33	set	@SQLCol33 	= @SQLCol33 + @SQLColLine
		else if		@SQLColLevel = 34	set	@SQLCol34 	= @SQLCol34 + @SQLColLine
		else if		@SQLColLevel = 35	set	@SQLCol35 	= @SQLCol35 + @SQLColLine
		else if		@SQLColLevel = 36	set	@SQLCol36 	= @SQLCol36 + @SQLColLine
		else if		@SQLColLevel = 37	set	@SQLCol37 	= @SQLCol37 + @SQLColLine
		else if		@SQLColLevel = 38	set	@SQLCol38 	= @SQLCol38 + @SQLColLine
		else if		@SQLColLevel = 39	set	@SQLCol39 	= @SQLCol39 + @SQLColLine
		else if		@SQLColLevel = 40	set	@SQLCol40 	= @SQLCol40 + @SQLColLine
		else if		@SQLColLevel = 41	set	@SQLCol41 	= @SQLCol41 + @SQLColLine
		else if		@SQLColLevel = 42	set	@SQLCol42 	= @SQLCol42 + @SQLColLine
		else if		@SQLColLevel = 43	set	@SQLCol43 	= @SQLCol43 + @SQLColLine
		else if		@SQLColLevel = 44	set	@SQLCol44 	= @SQLCol44 + @SQLColLine
		else if		@SQLColLevel = 45	set	@SQLCol45 	= @SQLCol45 + @SQLColLine
		else if		@SQLColLevel = 46	set	@SQLCol46 	= @SQLCol46 + @SQLColLine
		else if		@SQLColLevel = 47	set	@SQLCol47 	= @SQLCol47 + @SQLColLine
		else if		@SQLColLevel = 48	set	@SQLCol48 	= @SQLCol48 + @SQLColLine
		else if		@SQLColLevel = 49	set	@SQLCol49 	= @SQLCol49 + @SQLColLine
		else if		@SQLColLevel = 50	set	@SQLCol50 	= @SQLCol50 + @SQLColLine

        if      @RowTotals is not null
        begin
		    if		@SQLTotLevel = 1	set	@SQLTot1 	= @SQLTot1 + @SQLTotLine
		    else if		@SQLTotLevel = 2	set	@SQLTot2 	= @SQLTot2 + @SQLTotLine
		    else if		@SQLTotLevel = 3	set	@SQLTot3 	= @SQLTot3 + @SQLTotLine
		    else if		@SQLTotLevel = 4	set	@SQLTot4 	= @SQLTot4 + @SQLTotLine
		    else if		@SQLTotLevel = 5	set	@SQLTot5 	= @SQLTot5 + @SQLTotLine
		    else if		@SQLTotLevel = 6	set	@SQLTot6 	= @SQLTot6 + @SQLTotLine
		    else if		@SQLTotLevel = 7	set	@SQLTot7 	= @SQLTot7 + @SQLTotLine
		    else if		@SQLTotLevel = 8	set	@SQLTot8 	= @SQLTot8 + @SQLTotLine
		    else if		@SQLTotLevel = 9	set	@SQLTot9 	= @SQLTot9 + @SQLTotLine
		    else if		@SQLTotLevel = 10	set	@SQLTot10 	= @SQLTot10 + @SQLTotLine
		    else if		@SQLTotLevel = 11	set	@SQLTot11 	= @SQLTot11 + @SQLTotLine
		    else if		@SQLTotLevel = 12	set	@SQLTot12 	= @SQLTot12 + @SQLTotLine
		    else if		@SQLTotLevel = 13	set	@SQLTot13 	= @SQLTot13 + @SQLTotLine
		    else if		@SQLTotLevel = 14	set	@SQLTot14 	= @SQLTot14 + @SQLTotLine
		    else if		@SQLTotLevel = 15	set	@SQLTot15 	= @SQLTot15 + @SQLTotLine
		    else if		@SQLTotLevel = 16	set	@SQLTot16 	= @SQLTot16 + @SQLTotLine
		    else if		@SQLTotLevel = 17	set	@SQLTot17 	= @SQLTot17 + @SQLTotLine
		    else if		@SQLTotLevel = 18	set	@SQLTot18 	= @SQLTot18 + @SQLTotLine
		    else if		@SQLTotLevel = 19	set	@SQLTot19 	= @SQLTot19 + @SQLTotLine
		    else if		@SQLTotLevel = 20	set	@SQLTot20 	= @SQLTot20 + @SQLTotLine
		    else if		@SQLTotLevel = 21	set	@SQLTot21 	= @SQLTot21 + @SQLTotLine
		    else if		@SQLTotLevel = 22	set	@SQLTot22 	= @SQLTot22 + @SQLTotLine
		    else if		@SQLTotLevel = 23	set	@SQLTot23 	= @SQLTot23 + @SQLTotLine
		    else if		@SQLTotLevel = 24	set	@SQLTot24 	= @SQLTot24 + @SQLTotLine
		    else if		@SQLTotLevel = 25	set	@SQLTot25 	= @SQLTot25 + @SQLTotLine
		    else if		@SQLTotLevel = 26	set	@SQLTot26 	= @SQLTot26 + @SQLTotLine
		    else if		@SQLTotLevel = 27	set	@SQLTot27 	= @SQLTot27 + @SQLTotLine
		    else if		@SQLTotLevel = 28	set	@SQLTot28 	= @SQLTot28 + @SQLTotLine
		    else if		@SQLTotLevel = 29	set	@SQLTot29 	= @SQLTot29 + @SQLTotLine
		    else if		@SQLTotLevel = 30	set	@SQLTot30 	= @SQLTot30 + @SQLTotLine
		    else if		@SQLTotLevel = 31	set	@SQLTot31 	= @SQLTot31 + @SQLTotLine
		    else if		@SQLTotLevel = 32	set	@SQLTot32 	= @SQLTot32 + @SQLTotLine
		    else if		@SQLTotLevel = 33	set	@SQLTot33 	= @SQLTot33 + @SQLTotLine
		    else if		@SQLTotLevel = 34	set	@SQLTot34 	= @SQLTot34 + @SQLTotLine
		    else if		@SQLTotLevel = 35	set	@SQLTot35 	= @SQLTot35 + @SQLTotLine
		    else if		@SQLTotLevel = 36	set	@SQLTot36 	= @SQLTot36 + @SQLTotLine
		    else if		@SQLTotLevel = 37	set	@SQLTot37 	= @SQLTot37 + @SQLTotLine
		    else if		@SQLTotLevel = 38	set	@SQLTot38 	= @SQLTot38 + @SQLTotLine
		    else if		@SQLTotLevel = 39	set	@SQLTot39 	= @SQLTot39 + @SQLTotLine
		    else if		@SQLTotLevel = 40	set	@SQLTot40 	= @SQLTot40 + @SQLTotLine
		    else if		@SQLTotLevel = 41	set	@SQLTot41 	= @SQLTot41 + @SQLTotLine
		    else if		@SQLTotLevel = 42	set	@SQLTot42 	= @SQLTot42 + @SQLTotLine
		    else if		@SQLTotLevel = 43	set	@SQLTot43 	= @SQLTot43 + @SQLTotLine
		    else if		@SQLTotLevel = 44	set	@SQLTot44 	= @SQLTot44 + @SQLTotLine
		    else if		@SQLTotLevel = 45	set	@SQLTot45 	= @SQLTot45 + @SQLTotLine
		    else if		@SQLTotLevel = 46	set	@SQLTot46 	= @SQLTot46 + @SQLTotLine
		    else if		@SQLTotLevel = 47	set	@SQLTot47 	= @SQLTot47 + @SQLTotLine
		    else if		@SQLTotLevel = 48	set	@SQLTot48 	= @SQLTot48 + @SQLTotLine
		    else if		@SQLTotLevel = 49	set	@SQLTot49 	= @SQLTot49 + @SQLTotLine
		    else if		@SQLTotLevel = 50	set	@SQLTot50 	= @SQLTot50 + @SQLTotLine
        end

		if		@TempTableName is not null
		begin
			if		@SQLInsLevel = 1	set	@SQLIns1 	= @SQLIns1 + @SQLInsLine
			else if		@SQLInsLevel = 2	set	@SQLIns2 	= @SQLIns2 + @SQLInsLine
			else if		@SQLInsLevel = 3	set	@SQLIns3 	= @SQLIns3 + @SQLInsLine
			else if		@SQLInsLevel = 4	set	@SQLIns4 	= @SQLIns4 + @SQLInsLine
			else if		@SQLInsLevel = 5	set	@SQLIns5 	= @SQLIns5 + @SQLInsLine
			else if		@SQLInsLevel = 6	set	@SQLIns6 	= @SQLIns6 + @SQLInsLine
			else if		@SQLInsLevel = 7	set	@SQLIns7 	= @SQLIns7 + @SQLInsLine
			else if		@SQLInsLevel = 8	set	@SQLIns8 	= @SQLIns8 + @SQLInsLine
			else if		@SQLInsLevel = 9	set	@SQLIns9 	= @SQLIns9 + @SQLInsLine
			else if		@SQLInsLevel = 10	set	@SQLIns10 	= @SQLIns10 + @SQLInsLine
			else if		@SQLInsLevel = 11	set	@SQLIns11 	= @SQLIns11 + @SQLInsLine
			else if		@SQLInsLevel = 12	set	@SQLIns12 	= @SQLIns12 + @SQLInsLine
			else if		@SQLInsLevel = 13	set	@SQLIns13 	= @SQLIns13 + @SQLInsLine
			else if		@SQLInsLevel = 14	set	@SQLIns14 	= @SQLIns14 + @SQLInsLine
			else if		@SQLInsLevel = 15	set	@SQLIns15 	= @SQLIns15 + @SQLInsLine
			else if		@SQLInsLevel = 16	set	@SQLIns16 	= @SQLIns16 + @SQLInsLine
			else if		@SQLInsLevel = 17	set	@SQLIns17 	= @SQLIns17 + @SQLInsLine
			else if		@SQLInsLevel = 18	set	@SQLIns18 	= @SQLIns18 + @SQLInsLine
			else if		@SQLInsLevel = 19	set	@SQLIns19 	= @SQLIns19 + @SQLInsLine
			else if		@SQLInsLevel = 20	set	@SQLIns20 	= @SQLIns20 + @SQLInsLine
			else if		@SQLInsLevel = 21	set	@SQLIns21 	= @SQLIns21 + @SQLInsLine
			else if		@SQLInsLevel = 22	set	@SQLIns22 	= @SQLIns22 + @SQLInsLine
			else if		@SQLInsLevel = 23	set	@SQLIns23 	= @SQLIns23 + @SQLInsLine
			else if		@SQLInsLevel = 24	set	@SQLIns24 	= @SQLIns24 + @SQLInsLine
			else if		@SQLInsLevel = 25	set	@SQLIns25 	= @SQLIns25 + @SQLInsLine
			else if		@SQLInsLevel = 26	set	@SQLIns26 	= @SQLIns26 + @SQLInsLine
			else if		@SQLInsLevel = 27	set	@SQLIns27 	= @SQLIns27 + @SQLInsLine
			else if		@SQLInsLevel = 28	set	@SQLIns28 	= @SQLIns28 + @SQLInsLine
			else if		@SQLInsLevel = 29	set	@SQLIns29 	= @SQLIns29 + @SQLInsLine
			else if		@SQLInsLevel = 30	set	@SQLIns30 	= @SQLIns30 + @SQLInsLine
		end

		if		@ColTotals is not null
		begin
			if		@SQLTtCLevel = 1	set	@SQLTtC1 	= @SQLTtC1 + @SQLTtCLine
			else if		@SQLTtCLevel = 2	set	@SQLTtC2 	= @SQLTtC2 + @SQLTtCLine
			else if		@SQLTtCLevel = 3	set	@SQLTtC3 	= @SQLTtC3 + @SQLTtCLine
			else if		@SQLTtCLevel = 4	set	@SQLTtC4 	= @SQLTtC4 + @SQLTtCLine
			else if		@SQLTtCLevel = 5	set	@SQLTtC5 	= @SQLTtC5 + @SQLTtCLine
			else if		@SQLTtCLevel = 6	set	@SQLTtC6 	= @SQLTtC6 + @SQLTtCLine
			else if		@SQLTtCLevel = 7	set	@SQLTtC7 	= @SQLTtC7 + @SQLTtCLine
			else if		@SQLTtCLevel = 8	set	@SQLTtC8 	= @SQLTtC8 + @SQLTtCLine
			else if		@SQLTtCLevel = 9	set	@SQLTtC9 	= @SQLTtC9 + @SQLTtCLine
			else if		@SQLTtCLevel = 10	set	@SQLTtC10 	= @SQLTtC10 + @SQLTtCLine
			else if		@SQLTtCLevel = 11	set	@SQLTtC11 	= @SQLTtC11 + @SQLTtCLine
			else if		@SQLTtCLevel = 12	set	@SQLTtC12 	= @SQLTtC12 + @SQLTtCLine
			else if		@SQLTtCLevel = 13	set	@SQLTtC13 	= @SQLTtC13 + @SQLTtCLine
			else if		@SQLTtCLevel = 14	set	@SQLTtC14 	= @SQLTtC14 + @SQLTtCLine
			else if		@SQLTtCLevel = 15	set	@SQLTtC15 	= @SQLTtC15 + @SQLTtCLine
			else if		@SQLTtCLevel = 16	set	@SQLTtC16 	= @SQLTtC16 + @SQLTtCLine
			else if		@SQLTtCLevel = 17	set	@SQLTtC17 	= @SQLTtC17 + @SQLTtCLine
			else if		@SQLTtCLevel = 18	set	@SQLTtC18 	= @SQLTtC18 + @SQLTtCLine
			else if		@SQLTtCLevel = 19	set	@SQLTtC19 	= @SQLTtC19 + @SQLTtCLine
			else if		@SQLTtCLevel = 20	set	@SQLTtC20 	= @SQLTtC20 + @SQLTtCLine
			else if		@SQLTtCLevel = 21	set	@SQLTtC21 	= @SQLTtC21 + @SQLTtCLine
			else if		@SQLTtCLevel = 22	set	@SQLTtC22 	= @SQLTtC22 + @SQLTtCLine
			else if		@SQLTtCLevel = 23	set	@SQLTtC23 	= @SQLTtC23 + @SQLTtCLine
			else if		@SQLTtCLevel = 24	set	@SQLTtC24 	= @SQLTtC24 + @SQLTtCLine
			else if		@SQLTtCLevel = 25	set	@SQLTtC25 	= @SQLTtC25 + @SQLTtCLine
			else if		@SQLTtCLevel = 26	set	@SQLTtC26 	= @SQLTtC26 + @SQLTtCLine
			else if		@SQLTtCLevel = 27	set	@SQLTtC27 	= @SQLTtC27 + @SQLTtCLine
			else if		@SQLTtCLevel = 28	set	@SQLTtC28 	= @SQLTtC28 + @SQLTtCLine
			else if		@SQLTtCLevel = 29	set	@SQLTtC29 	= @SQLTtC29 + @SQLTtCLine
			else if		@SQLTtCLevel = 30	set	@SQLTtC30 	= @SQLTtC30 + @SQLTtCLine
		end

		set	@ColNo = @ColNo + 1

	end

	fetch next
	from 		curColCursor 
	into		@ColID, @ColName, @ColTotal

end

close		curColCursor
deallocate	curColCursor

-- Don't forget to debug print our row total column...
if  @RowTotals is not null and
    @TempTableName is not null
begin
    if		@Debug		= 1
        print	    'alter table ' + @TempTableName + ' add [' + @RowTotals + '] ' + @CalcFieldType
    exec		('alter table ' + @TempTableName + ' add [' + @RowTotals + '] ' + @CalcFieldType)
end


-----=====******--~-~--~~---~-~---~~-~-~---~---~--~--~~~-~-~---~---~--~*****=====-----
--              Run the cross-tab

-- Right, all the hard work has now been done. We just need to run the SQL statements 
-- that we've built up. We have eight different scenarions (a combination of with or
-- without column totals, with or without row totals, and with or without writing to
-- a temp table). The query execution for each of these scenarios differs slightly. 
-- I probably could have joined some of these scenarios, but the decided against it
-- for both performance and maintainability reasons. If does look a bit full though
-- with all the debug code mixed in with it.



if      @ColTotals is not null
begin
    if      @RowTotals is not null
    begin
        if		@TempTableName is not null
        begin   -- Row totals, col totals, temp table
        if      @Debug = 1 
        begin 
            print   '--1 Row totals, col totals, temp table'
            print 'insert into ' + @TempTableName + '(' + @StrippedRowFieldNames 
		    print @SQLIns1  print @SQLIns2  print @SQLIns3  print @SQLIns4  print @SQLIns5  print @SQLIns6  print @SQLIns7 
            print @SQLIns8  print @SQLIns9  print @SQLIns10 print @SQLIns11 print @SQLIns12 print @SQLIns13 print @SQLIns14 
            print @SQLIns15 print @SQLIns16 print @SQLIns17 print @SQLIns18 print @SQLIns19 print @SQLIns20 print @SQLIns21  
            print @SQLIns22 print @SQLIns23 print @SQLIns24 print @SQLIns25 print @SQLIns26 print @SQLIns27 print @SQLIns28 
            print @SQLIns29 print @SQLIns30 print ',[' + @RowTotals + '])'  print 'select ' + @StrippedRowFieldNames
		    print @SQLCol1  print @SQLCol2  print @SQLCol3  print @SQLCol4  print @SQLCol5  print @SQLCol6  print @SQLCol7 
            print @SQLCol8  print @SQLCol9  print @SQLCol10 print @SQLCol11 print @SQLCol12 print @SQLCol13 print @SQLCol14 
            print @SQLCol15 print @SQLCol16 print @SQLCol17 print @SQLCol18 print @SQLCol19 print @SQLCol20 print @SQLCol21  
            print @SQLCol22 print @SQLCol23 print @SQLCol24 print @SQLCol25 print @SQLCol26 print @SQLCol27 print @SQLCol28 
            print @SQLCol29 print @SQLCol30 print @SQLCol31 print @SQLCol32 print @SQLCol33 print @SQLCol34 print @SQLCol35 
            print @SQLCol36 print @SQLCol37 print @SQLCol38 print @SQLCol39 print @SQLCol40 print @SQLCol41 print @SQLCol42 
            print @SQLCol43 print @SQLCol44 print @SQLCol45 print @SQLCol46 print @SQLCol47 print @SQLCol48 print @SQLCol49 
            print @SQLCol50 print   @NewLine + ', '  
		    print @SQLTot1  print @SQLTot2  print @SQLTot3  print @SQLTot4  print @SQLTot5  print @SQLTot6  print @SQLTot7 
            print @SQLTot8  print @SQLTot9  print @SQLTot10 print @SQLTot11 print @SQLTot12 print @SQLTot13 print @SQLTot14 
            print @SQLTot15 print @SQLTot16 print @SQLTot17 print @SQLTot18 print @SQLTot19 print @SQLTot20 print @SQLTot21  
            print @SQLTot22 print @SQLTot23 print @SQLTot24 print @SQLTot25 print @SQLTot26 print @SQLTot27 print @SQLTot28 
            print @SQLTot29 print @SQLTot30 print @SQLTot31 print @SQLTot32 print @SQLTot33 print @SQLTot34 print @SQLTot35 
            print @SQLTot36 print @SQLTot37 print @SQLTot38 print @SQLTot39 print @SQLTot40 print @SQLTot41 print @SQLTot42 
            print @SQLTot43 print @SQLTot44 print @SQLTot45 print @SQLTot46 print @SQLTot47 print @SQLTot48 print @SQLTot49 
            print @SQLTot50 print   ' [' + @RowTotals + ']' + @NewLine 	    print  @NewLine + ' from (select ' + @RowFieldNames 
		    print @SQLCase1  print @SQLCase2  print @SQLCase3  print @SQLCase4  print @SQLCase5  print @SQLCase6  print @SQLCase7
		    print @SQLCase8  print @SQLCase9  print @SQLCase10 print @SQLCase11 print @SQLCase12 print @SQLCase13 print @SQLCase14 
            print @SQLCase15 print @SQLCase16 print @SQLCase17 print @SQLCase18 print @SQLCase19 print @SQLCase20 print @SQLCase21  
            print @SQLCase22 print @SQLCase23 print @SQLCase24 print @SQLCase25 print @SQLCase26 print @SQLCase27 print @SQLCase28 
            print @SQLCase29 print @SQLCase30 print @SQLCase31 print @SQLCase32 print @SQLCase33 print @SQLCase34 print @SQLCase35 
            print @SQLCase36 print @SQLCase37 print @SQLCase38 print @SQLCase39 print @SQLCase40 print @SQLCase41 print @SQLCase42 
            print @SQLCase43 print @SQLCase44 print @SQLCase45 print @SQLCase46 print @SQLCase47 print @SQLCase48 print @SQLCase49 
            print @SQLCase50 + @NewLine 
            print 'from ' + @SQLSource + @NewLine 
            print 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine 
            print 'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine 
            print 'group by ' + @StrippedRowFieldNames + @NewLine
            print 'union all ' + @Newline + 'select ' + @ColTotals  
	        print @SQLTtC1  print @SQLTtC2  print @SQLTtC3  print @SQLTtC4  print @SQLTtC5  print @SQLTtC6  print @SQLTtC7  
            print @SQLTtC8  print @SQLTtC9  print @SQLTtC10 print @SQLTtC11 print @SQLTtC12 print @SQLTtC13 print @SQLTtC14 
            print @SQLTtC15 print @SQLTtC16 print @SQLTtC17 print @SQLTtC18 print @SQLTtC19 print @SQLTtC20 print @SQLTtC21 
            print @SQLTtC22 print @SQLTtC23 print @SQLTtC24 print @SQLTtC25 print @SQLTtC26 print @SQLTtC27 print @SQLTtC28 
            print @SQLTtC29 print @SQLTtC30 print ', ' + @GrandTotal        print @AddOrder + @NewLine
        end

        exec	('insert into ' + @TempTableName + '(' + @StrippedRowFieldNames +
		        @SQLIns1  + @SQLIns2 + @SQLIns3 + @SQLIns4 + @SQLIns5 + @SQLIns6 + @SQLIns7 + @SQLIns8 + @SQLIns9 + @SQLIns10 +
		        @SQLIns11  + @SQLIns12 + @SQLIns13 + @SQLIns14 + @SQLIns15 + @SQLIns16 + @SQLIns17 + @SQLIns18 + @SQLIns19 + @SQLIns20 +
		        @SQLIns21  + @SQLIns22 + @SQLIns23 + @SQLIns24 + @SQLIns25 + @SQLIns26 + @SQLIns27 + @SQLIns28 + @SQLIns29 + @SQLIns30 + 
                ',[' + @RowTotals + '])' + 
		        'select ' + @StrippedRowFieldNames + 
		        @SQLCol1  + @SQLCol2 + @SQLCol3 + @SQLCol4 + @SQLCol5 + @SQLCol6 + @SQLCol7 + @SQLCol8 + @SQLCol9 + @SQLCol10 +
		        @SQLCol11  + @SQLCol12 + @SQLCol13 + @SQLCol14 + @SQLCol15 + @SQLCol16 + @SQLCol17 + @SQLCol18 + @SQLCol19 + @SQLCol20 +
		        @SQLCol21  + @SQLCol22 + @SQLCol23 + @SQLCol24 + @SQLCol25 + @SQLCol26 + @SQLCol27 + @SQLCol28 + @SQLCol29 + @SQLCol30 +
		        @SQLCol31  + @SQLCol32 + @SQLCol33 + @SQLCol34 + @SQLCol35 + @SQLCol36 + @SQLCol37 + @SQLCol38 + @SQLCol39 + @SQLCol40 +
		        @SQLCol41  + @SQLCol42 + @SQLCol43 + @SQLCol44 + @SQLCol45 + @SQLCol46 + @SQLCol47 + @SQLCol48 + @SQLCol49 + @SQLCol50 +
		        @NewLine + ', ' + 
		        @SQLTot1  + @SQLTot2 + @SQLTot3 + @SQLTot4 + @SQLTot5 + @SQLTot6 + @SQLTot7 + @SQLTot8 + @SQLTot9 + @SQLTot10 +
		        @SQLTot11  + @SQLTot12 + @SQLTot13 + @SQLTot14 + @SQLTot15 + @SQLTot16 + @SQLTot17 + @SQLTot18 + @SQLTot19 + @SQLTot20 +
		        @SQLTot21  + @SQLTot22 + @SQLTot23 + @SQLTot24 + @SQLTot25 + @SQLTot26 + @SQLTot27 + @SQLTot28 + @SQLTot29 + @SQLTot30 +
		        @SQLTot31  + @SQLTot32 + @SQLTot33 + @SQLTot34 + @SQLTot35 + @SQLTot36 + @SQLTot37 + @SQLTot38 + @SQLTot39 + @SQLTot40 +
		        @SQLTot41  + @SQLTot42 + @SQLTot43 + @SQLTot44 + @SQLTot45 + @SQLTot46 + @SQLTot47 + @SQLTot48 + @SQLTot49 + @SQLTot50 +
                ' [' + @RowTotals + ']' + @NewLine + 
		        @NewLine + ' from (select ' + @RowFieldNames +
		        @SQLCase1 + @SQLCase2 + @SQLCase3 + @SQLCase4 + @SQLCase5 + @SQLCase6 + @SQLCase7 + @SQLCase8 + @SQLCase9 + @SQLCase10 +
		        @SQLCase11  + @SQLCase12 + @SQLCase13 + @SQLCase14 + @SQLCase15 + @SQLCase16 + @SQLCase17 + @SQLCase18 + @SQLCase19 + @SQLCase20 +
		        @SQLCase21  + @SQLCase22 + @SQLCase23 + @SQLCase24 + @SQLCase25 + @SQLCase26 + @SQLCase27 + @SQLCase28 + @SQLCase29 + @SQLCase30 +
		        @SQLCase31  + @SQLCase32 + @SQLCase33 + @SQLCase34 + @SQLCase35 + @SQLCase36 + @SQLCase37 + @SQLCase38 + @SQLCase39 + @SQLCase40 +
		        @SQLCase41  + @SQLCase42 + @SQLCase43 + @SQLCase44 + @SQLCase45 + @SQLCase46 + @SQLCase47 + @SQLCase48 + @SQLCase49 + @SQLCase50 +
		        @NewLine + 'from ' + @SQLSource + @NewLine + 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine + 
		        'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine + 'group by ' + @StrippedRowFieldNames + @NewLine +
                ' union all ' + @Newline + 'select ' + @ColTotals + 
		        @SQLTtC1  + @SQLTtC2  + @SQLTtC3  + @SQLTtC4  + @SQLTtC5  + @SQLTtC6  + @SQLTtC7  + @SQLTtC8  + @SQLTtC9  + @SQLTtC10 + 
                @SQLTtC11 + @SQLTtC12 + @SQLTtC13 + @SQLTtC14 + @SQLTtC15 + @SQLTtC16 + @SQLTtC17 + @SQLTtC18 + @SQLTtC19 + @SQLTtC20 + 
		        @SQLTtC21 + @SQLTtC22 + @SQLTtC23 + @SQLTtC24 + @SQLTtC25 + @SQLTtC26 + @SQLTtC27 + @SQLTtC28 + @SQLTtC29 + @SQLTtC30 +
		        ', ' + @GrandTotal + @AddOrder
                )
        end
        else
        begin   -- Row totals, col totals, no temp table
        if      @Debug = 1 
        begin
            print 'select ' + @StrippedRowFieldNames
		    print @SQLCol1  print @SQLCol2  print @SQLCol3  print @SQLCol4  print @SQLCol5  print @SQLCol6  print @SQLCol7 
            print @SQLCol8  print @SQLCol9  print @SQLCol10 print @SQLCol11 print @SQLCol12 print @SQLCol13 print @SQLCol14 
            print @SQLCol15 print @SQLCol16 print @SQLCol17 print @SQLCol18 print @SQLCol19 print @SQLCol20 print @SQLCol21  
            print @SQLCol22 print @SQLCol23 print @SQLCol24 print @SQLCol25 print @SQLCol26 print @SQLCol27 print @SQLCol28 
            print @SQLCol29 print @SQLCol30 print @SQLCol31 print @SQLCol32 print @SQLCol33 print @SQLCol34 print @SQLCol35 
            print @SQLCol36 print @SQLCol37 print @SQLCol38 print @SQLCol39 print @SQLCol40 print @SQLCol41 print @SQLCol42 
            print @SQLCol43 print @SQLCol44 print @SQLCol45 print @SQLCol46 print @SQLCol47 print @SQLCol48 print @SQLCol49 
            print @SQLCol50 print   @NewLine + ', '  
		    print @SQLTot1  print @SQLTot2  print @SQLTot3  print @SQLTot4  print @SQLTot5  print @SQLTot6  print @SQLTot7 
            print @SQLTot8  print @SQLTot9  print @SQLTot10 print @SQLTot11 print @SQLTot12 print @SQLTot13 print @SQLTot14 
            print @SQLTot15 print @SQLTot16 print @SQLTot17 print @SQLTot18 print @SQLTot19 print @SQLTot20 print @SQLTot21  
            print @SQLTot22 print @SQLTot23 print @SQLTot24 print @SQLTot25 print @SQLTot26 print @SQLTot27 print @SQLTot28 
            print @SQLTot29 print @SQLTot30 print @SQLTot31 print @SQLTot32 print @SQLTot33 print @SQLTot34 print @SQLTot35 
            print @SQLTot36 print @SQLTot37 print @SQLTot38 print @SQLTot39 print @SQLTot40 print @SQLTot41 print @SQLTot42 
            print @SQLTot43 print @SQLTot44 print @SQLTot45 print @SQLTot46 print @SQLTot47 print @SQLTot48 print @SQLTot49 
            print @SQLTot50 print   ' [' + @RowTotals + ']' + @NewLine 	    print  @NewLine + ' from (select ' + @RowFieldNames 
		    print @SQLCase1  print @SQLCase2  print @SQLCase3  print @SQLCase4  print @SQLCase5  print @SQLCase6  print @SQLCase7
		    print @SQLCase8  print @SQLCase9  print @SQLCase10 print @SQLCase11 print @SQLCase12 print @SQLCase13 print @SQLCase14 
            print @SQLCase15 print @SQLCase16 print @SQLCase17 print @SQLCase18 print @SQLCase19 print @SQLCase20 print @SQLCase21  
            print @SQLCase22 print @SQLCase23 print @SQLCase24 print @SQLCase25 print @SQLCase26 print @SQLCase27 print @SQLCase28 
            print @SQLCase29 print @SQLCase30 print @SQLCase31 print @SQLCase32 print @SQLCase33 print @SQLCase34 print @SQLCase35 
            print @SQLCase36 print @SQLCase37 print @SQLCase38 print @SQLCase39 print @SQLCase40 print @SQLCase41 print @SQLCase42 
            print @SQLCase43 print @SQLCase44 print @SQLCase45 print @SQLCase46 print @SQLCase47 print @SQLCase48 print @SQLCase49 
            print @SQLCase50 + @NewLine 
            print 'from ' + @SQLSource + @NewLine 
            print 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine 
            print 'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine 
            print 'group by ' + @StrippedRowFieldNames + @NewLine
            print 'union all ' + @Newline + 'select ' + @ColTotals  
	        print @SQLTtC1  print @SQLTtC2  print @SQLTtC3  print @SQLTtC4  print @SQLTtC5  print @SQLTtC6  print @SQLTtC7  
            print @SQLTtC8  print @SQLTtC9  print @SQLTtC10 print @SQLTtC11 print @SQLTtC12 print @SQLTtC13 print @SQLTtC14 
            print @SQLTtC15 print @SQLTtC16 print @SQLTtC17 print @SQLTtC18 print @SQLTtC19 print @SQLTtC20 print @SQLTtC21 
            print @SQLTtC22 print @SQLTtC23 print @SQLTtC24 print @SQLTtC25 print @SQLTtC26 print @SQLTtC27 print @SQLTtC28 
            print @SQLTtC29 print @SQLTtC30 print ', ' + @GrandTotal        print @AddOrder + @NewLine
        end

        exec	('select ' + @StrippedRowFieldNames + 
		        @SQLCol1  + @SQLCol2 + @SQLCol3 + @SQLCol4 + @SQLCol5 + @SQLCol6 + @SQLCol7 + @SQLCol8 + @SQLCol9 + @SQLCol10 +
		        @SQLCol11  + @SQLCol12 + @SQLCol13 + @SQLCol14 + @SQLCol15 + @SQLCol16 + @SQLCol17 + @SQLCol18 + @SQLCol19 + @SQLCol20 +
		        @SQLCol21  + @SQLCol22 + @SQLCol23 + @SQLCol24 + @SQLCol25 + @SQLCol26 + @SQLCol27 + @SQLCol28 + @SQLCol29 + @SQLCol30 +
		        @SQLCol31  + @SQLCol32 + @SQLCol33 + @SQLCol34 + @SQLCol35 + @SQLCol36 + @SQLCol37 + @SQLCol38 + @SQLCol39 + @SQLCol40 +
		        @SQLCol41  + @SQLCol42 + @SQLCol43 + @SQLCol44 + @SQLCol45 + @SQLCol46 + @SQLCol47 + @SQLCol48 + @SQLCol49 + @SQLCol50 +
		        @NewLine + ', ' + 
		        @SQLTot1  + @SQLTot2 + @SQLTot3 + @SQLTot4 + @SQLTot5 + @SQLTot6 + @SQLTot7 + @SQLTot8 + @SQLTot9 + @SQLTot10 +
		        @SQLTot11  + @SQLTot12 + @SQLTot13 + @SQLTot14 + @SQLTot15 + @SQLTot16 + @SQLTot17 + @SQLTot18 + @SQLTot19 + @SQLTot20 +
		        @SQLTot21  + @SQLTot22 + @SQLTot23 + @SQLTot24 + @SQLTot25 + @SQLTot26 + @SQLTot27 + @SQLTot28 + @SQLTot29 + @SQLTot30 +
		        @SQLTot31  + @SQLTot32 + @SQLTot33 + @SQLTot34 + @SQLTot35 + @SQLTot36 + @SQLTot37 + @SQLTot38 + @SQLTot39 + @SQLTot40 +
		        @SQLTot41  + @SQLTot42 + @SQLTot43 + @SQLTot44 + @SQLTot45 + @SQLTot46 + @SQLTot47 + @SQLTot48 + @SQLTot49 + @SQLTot50 +
                ' [' + @RowTotals + ']' + @NewLine +
		        @NewLine + ' from (select ' + @RowFieldNames +
		        @SQLCase1 + @SQLCase2 + @SQLCase3 + @SQLCase4 + @SQLCase5 + @SQLCase6 + @SQLCase7 + @SQLCase8 + @SQLCase9 + @SQLCase10 +
		        @SQLCase11  + @SQLCase12 + @SQLCase13 + @SQLCase14 + @SQLCase15 + @SQLCase16 + @SQLCase17 + @SQLCase18 + @SQLCase19 + @SQLCase20 +
		        @SQLCase21  + @SQLCase22 + @SQLCase23 + @SQLCase24 + @SQLCase25 + @SQLCase26 + @SQLCase27 + @SQLCase28 + @SQLCase29 + @SQLCase30 +
		        @SQLCase31  + @SQLCase32 + @SQLCase33 + @SQLCase34 + @SQLCase35 + @SQLCase36 + @SQLCase37 + @SQLCase38 + @SQLCase39 + @SQLCase40 +
		        @SQLCase41  + @SQLCase42 + @SQLCase43 + @SQLCase44 + @SQLCase45 + @SQLCase46 + @SQLCase47 + @SQLCase48 + @SQLCase49 + @SQLCase50 +
		        @NewLine + 'from ' + @SQLSource + @NewLine + 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine + 
		        'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine + 'group by ' + @StrippedRowFieldNames + @NewLine + 
                ' union all ' + @Newline + 'select ' + @ColTotals + 
		        @SQLTtC1  + @SQLTtC2  + @SQLTtC3  + @SQLTtC4  + @SQLTtC5  + @SQLTtC6  + @SQLTtC7  + @SQLTtC8  + @SQLTtC9  + @SQLTtC10 + 
                @SQLTtC11 + @SQLTtC12 + @SQLTtC13 + @SQLTtC14 + @SQLTtC15 + @SQLTtC16 + @SQLTtC17 + @SQLTtC18 + @SQLTtC19 + @SQLTtC20 + 
		        @SQLTtC21 + @SQLTtC22 + @SQLTtC23 + @SQLTtC24 + @SQLTtC25 + @SQLTtC26 + @SQLTtC27 + @SQLTtC28 + @SQLTtC29 + @SQLTtC30 +                
                ', ' + @GrandTotal + @AddOrder
                )
        end
    end
    else
    begin
        if		@TempTableName is not null
        begin   -- No row totals, col totals, temp table
        if      @Debug = 1 
        begin   
            print   '--3 No row totals, col totals, temp table'
            print 'insert into ' + @TempTableName + '(' + @StrippedRowFieldNames 
		    print @SQLIns1  print @SQLIns2  print @SQLIns3  print @SQLIns4  print @SQLIns5  print @SQLIns6  print @SQLIns7 
            print @SQLIns8  print @SQLIns9  print @SQLIns10 print @SQLIns11 print @SQLIns12 print @SQLIns13 print @SQLIns14 
            print @SQLIns15 print @SQLIns16 print @SQLIns17 print @SQLIns18 print @SQLIns19 print @SQLIns20 print @SQLIns21  
            print @SQLIns22 print @SQLIns23 print @SQLIns24 print @SQLIns25 print @SQLIns26 print @SQLIns27 print @SQLIns28 
            print @SQLIns29 print @SQLIns30 print ') select ' + @StrippedRowFieldNames
		    print @SQLCol1  print @SQLCol2  print @SQLCol3  print @SQLCol4  print @SQLCol5  print @SQLCol6  print @SQLCol7 
            print @SQLCol8  print @SQLCol9  print @SQLCol10 print @SQLCol11 print @SQLCol12 print @SQLCol13 print @SQLCol14 
            print @SQLCol15 print @SQLCol16 print @SQLCol17 print @SQLCol18 print @SQLCol19 print @SQLCol20 print @SQLCol21  
            print @SQLCol22 print @SQLCol23 print @SQLCol24 print @SQLCol25 print @SQLCol26 print @SQLCol27 print @SQLCol28 
            print @SQLCol29 print @SQLCol30 print @SQLCol31 print @SQLCol32 print @SQLCol33 print @SQLCol34 print @SQLCol35 
            print @SQLCol36 print @SQLCol37 print @SQLCol38 print @SQLCol39 print @SQLCol40 print @SQLCol41 print @SQLCol42 
            print @SQLCol43 print @SQLCol44 print @SQLCol45 print @SQLCol46 print @SQLCol47 print @SQLCol48 print @SQLCol49 
            print @SQLCol50 print ' from (select ' print @RowFieldNames 
		    print @SQLCase1  print @SQLCase2  print @SQLCase3  print @SQLCase4  print @SQLCase5  print @SQLCase6  print @SQLCase7
		    print @SQLCase8  print @SQLCase9  print @SQLCase10 print @SQLCase11 print @SQLCase12 print @SQLCase13 print @SQLCase14 
            print @SQLCase15 print @SQLCase16 print @SQLCase17 print @SQLCase18 print @SQLCase19 print @SQLCase20 print @SQLCase21  
            print @SQLCase22 print @SQLCase23 print @SQLCase24 print @SQLCase25 print @SQLCase26 print @SQLCase27 print @SQLCase28 
            print @SQLCase29 print @SQLCase30 print @SQLCase31 print @SQLCase32 print @SQLCase33 print @SQLCase34 print @SQLCase35 
            print @SQLCase36 print @SQLCase37 print @SQLCase38 print @SQLCase39 print @SQLCase40 print @SQLCase41 print @SQLCase42 
            print @SQLCase43 print @SQLCase44 print @SQLCase45 print @SQLCase46 print @SQLCase47 print @SQLCase48 print @SQLCase49 
            print @SQLCase50 + @NewLine 
            print 'from ' + @SQLSource + @NewLine 
            print 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine 
            print 'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine 
            print 'group by ' + @StrippedRowFieldNames + @NewLine
            print 'union all ' + @Newline + 'select ' + @ColTotals  
	        print @SQLTtC1  print @SQLTtC2  print @SQLTtC3  print @SQLTtC4  print @SQLTtC5  print @SQLTtC6  print @SQLTtC7  
            print @SQLTtC8  print @SQLTtC9  print @SQLTtC10 print @SQLTtC11 print @SQLTtC12 print @SQLTtC13 print @SQLTtC14 
            print @SQLTtC15 print @SQLTtC16 print @SQLTtC17 print @SQLTtC18 print @SQLTtC19 print @SQLTtC20 print @SQLTtC21 
            print @SQLTtC22 print @SQLTtC23 print @SQLTtC24 print @SQLTtC25 print @SQLTtC26 print @SQLTtC27 print @SQLTtC28 
            print @SQLTtC29 print @SQLTtC30 print @AddOrder + @NewLine
        end		        

        exec	('insert into ' + @TempTableName + '(' + @StrippedRowFieldNames +
		        @SQLIns1  + @SQLIns2 + @SQLIns3 + @SQLIns4 + @SQLIns5 + @SQLIns6 + @SQLIns7 + @SQLIns8 + @SQLIns9 + @SQLIns10 +
		        @SQLIns11  + @SQLIns12 + @SQLIns13 + @SQLIns14 + @SQLIns15 + @SQLIns16 + @SQLIns17 + @SQLIns18 + @SQLIns19 + @SQLIns20 +
		        @SQLIns21  + @SQLIns22 + @SQLIns23 + @SQLIns24 + @SQLIns25 + @SQLIns26 + @SQLIns27 + @SQLIns28 + @SQLIns29 + @SQLIns30 + ')' + 
		        'select ' + @StrippedRowFieldNames + 
		        @SQLCol1  + @SQLCol2 + @SQLCol3 + @SQLCol4 + @SQLCol5 + @SQLCol6 + @SQLCol7 + @SQLCol8 + @SQLCol9 + @SQLCol10 +
		        @SQLCol11  + @SQLCol12 + @SQLCol13 + @SQLCol14 + @SQLCol15 + @SQLCol16 + @SQLCol17 + @SQLCol18 + @SQLCol19 + @SQLCol20 +
		        @SQLCol21  + @SQLCol22 + @SQLCol23 + @SQLCol24 + @SQLCol25 + @SQLCol26 + @SQLCol27 + @SQLCol28 + @SQLCol29 + @SQLCol30 +
		        @SQLCol31  + @SQLCol32 + @SQLCol33 + @SQLCol34 + @SQLCol35 + @SQLCol36 + @SQLCol37 + @SQLCol38 + @SQLCol39 + @SQLCol40 +
		        @SQLCol41  + @SQLCol42 + @SQLCol43 + @SQLCol44 + @SQLCol45 + @SQLCol46 + @SQLCol47 + @SQLCol48 + @SQLCol49 + @SQLCol50 +
		        @NewLine + ' from (select ' + @RowFieldNames +
		        @SQLCase1 + @SQLCase2 + @SQLCase3 + @SQLCase4 + @SQLCase5 + @SQLCase6 + @SQLCase7 + @SQLCase8 + @SQLCase9 + @SQLCase10 +
		        @SQLCase11  + @SQLCase12 + @SQLCase13 + @SQLCase14 + @SQLCase15 + @SQLCase16 + @SQLCase17 + @SQLCase18 + @SQLCase19 + @SQLCase20 +
		        @SQLCase21  + @SQLCase22 + @SQLCase23 + @SQLCase24 + @SQLCase25 + @SQLCase26 + @SQLCase27 + @SQLCase28 + @SQLCase29 + @SQLCase30 +
		        @SQLCase31  + @SQLCase32 + @SQLCase33 + @SQLCase34 + @SQLCase35 + @SQLCase36 + @SQLCase37 + @SQLCase38 + @SQLCase39 + @SQLCase40 +
		        @SQLCase41  + @SQLCase42 + @SQLCase43 + @SQLCase44 + @SQLCase45 + @SQLCase46 + @SQLCase47 + @SQLCase48 + @SQLCase49 + @SQLCase50 +
		        @NewLine + 'from ' + @SQLSource + @NewLine + 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine + 
		        'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine + 'group by ' + @StrippedRowFieldNames + @NewLine +
                ' union all ' + @Newline + 'select ' + @ColTotals + 
		        @SQLTtC1  + @SQLTtC2  + @SQLTtC3  + @SQLTtC4  + @SQLTtC5  + @SQLTtC6  + @SQLTtC7  + @SQLTtC8  + @SQLTtC9  + @SQLTtC10 + 
                @SQLTtC11 + @SQLTtC12 + @SQLTtC13 + @SQLTtC14 + @SQLTtC15 + @SQLTtC16 + @SQLTtC17 + @SQLTtC18 + @SQLTtC19 + @SQLTtC20 + 
		        @SQLTtC21 + @SQLTtC22 + @SQLTtC23 + @SQLTtC24 + @SQLTtC25 + @SQLTtC26 + @SQLTtC27 + @SQLTtC28 + @SQLTtC29 + @SQLTtC30  + 
                @AddOrder
		        )
        end
        else
        begin   -- No row totals, col totals, no temp table
        if      @Debug = 1
        begin    
            print   '--4 No row totals, col totals, no temp table'        
            print 'select * from (select ' + @StrippedRowFieldNames
		    print @SQLCol1  print @SQLCol2  print @SQLCol3  print @SQLCol4  print @SQLCol5  print @SQLCol6  print @SQLCol7 
            print @SQLCol8  print @SQLCol9  print @SQLCol10 print @SQLCol11 print @SQLCol12 print @SQLCol13 print @SQLCol14 
            print @SQLCol15 print @SQLCol16 print @SQLCol17 print @SQLCol18 print @SQLCol19 print @SQLCol20 print @SQLCol21  
            print @SQLCol22 print @SQLCol23 print @SQLCol24 print @SQLCol25 print @SQLCol26 print @SQLCol27 print @SQLCol28 
            print @SQLCol29 print @SQLCol30 print @SQLCol31 print @SQLCol32 print @SQLCol33 print @SQLCol34 print @SQLCol35 
            print @SQLCol36 print @SQLCol37 print @SQLCol38 print @SQLCol39 print @SQLCol40 print @SQLCol41 print @SQLCol42 
            print @SQLCol43 print @SQLCol44 print @SQLCol45 print @SQLCol46 print @SQLCol47 print @SQLCol48 print @SQLCol49 
            print @SQLCol50 print  @NewLine + ' from (select ' + @RowFieldNames 
		    print @SQLCase1  print @SQLCase2  print @SQLCase3  print @SQLCase4  print @SQLCase5  print @SQLCase6  print @SQLCase7
		    print @SQLCase8  print @SQLCase9  print @SQLCase10 print @SQLCase11 print @SQLCase12 print @SQLCase13 print @SQLCase14 
            print @SQLCase15 print @SQLCase16 print @SQLCase17 print @SQLCase18 print @SQLCase19 print @SQLCase20 print @SQLCase21  
            print @SQLCase22 print @SQLCase23 print @SQLCase24 print @SQLCase25 print @SQLCase26 print @SQLCase27 print @SQLCase28 
            print @SQLCase29 print @SQLCase30 print @SQLCase31 print @SQLCase32 print @SQLCase33 print @SQLCase34 print @SQLCase35 
            print @SQLCase36 print @SQLCase37 print @SQLCase38 print @SQLCase39 print @SQLCase40 print @SQLCase41 print @SQLCase42 
            print @SQLCase43 print @SQLCase44 print @SQLCase45 print @SQLCase46 print @SQLCase47 print @SQLCase48 print @SQLCase49 
            print @SQLCase50 + @NewLine 
            print 'from ' + @SQLSource + @NewLine 
            print 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine 
            print 'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine 
            print 'group by ' + @StrippedRowFieldNames + @NewLine
            print 'union all ' + @Newline + 'select ' + @ColTotals  
	        print @SQLTtC1  print @SQLTtC2  print @SQLTtC3  print @SQLTtC4  print @SQLTtC5  print @SQLTtC6  print @SQLTtC7  
            print @SQLTtC8  print @SQLTtC9  print @SQLTtC10 print @SQLTtC11 print @SQLTtC12 print @SQLTtC13 print @SQLTtC14 
            print @SQLTtC15 print @SQLTtC16 print @SQLTtC17 print @SQLTtC18 print @SQLTtC19 print @SQLTtC20 print @SQLTtC21 
            print @SQLTtC22 print @SQLTtC23 print @SQLTtC24 print @SQLTtC25 print @SQLTtC26 print @SQLTtC27 print @SQLTtC28 
            print @SQLTtC29 print @SQLTtC30 print ' ) X ' + @AddOrder + @NewLine          
        end		        
        
        exec	('select * from (select ' + @StrippedRowFieldNames + 
		        @SQLCol1  + @SQLCol2 + @SQLCol3 + @SQLCol4 + @SQLCol5 + @SQLCol6 + @SQLCol7 + @SQLCol8 + @SQLCol9 + @SQLCol10 +
		        @SQLCol11  + @SQLCol12 + @SQLCol13 + @SQLCol14 + @SQLCol15 + @SQLCol16 + @SQLCol17 + @SQLCol18 + @SQLCol19 + @SQLCol20 +
		        @SQLCol21  + @SQLCol22 + @SQLCol23 + @SQLCol24 + @SQLCol25 + @SQLCol26 + @SQLCol27 + @SQLCol28 + @SQLCol29 + @SQLCol30 +
		        @SQLCol31  + @SQLCol32 + @SQLCol33 + @SQLCol34 + @SQLCol35 + @SQLCol36 + @SQLCol37 + @SQLCol38 + @SQLCol39 + @SQLCol40 +
		        @SQLCol41  + @SQLCol42 + @SQLCol43 + @SQLCol44 + @SQLCol45 + @SQLCol46 + @SQLCol47 + @SQLCol48 + @SQLCol49 + @SQLCol50 +
		        @NewLine + ' from (select ' + @RowFieldNames +
		        @SQLCase1 + @SQLCase2 + @SQLCase3 + @SQLCase4 + @SQLCase5 + @SQLCase6 + @SQLCase7 + @SQLCase8 + @SQLCase9 + @SQLCase10 +
		        @SQLCase11  + @SQLCase12 + @SQLCase13 + @SQLCase14 + @SQLCase15 + @SQLCase16 + @SQLCase17 + @SQLCase18 + @SQLCase19 + @SQLCase20 +
		        @SQLCase21  + @SQLCase22 + @SQLCase23 + @SQLCase24 + @SQLCase25 + @SQLCase26 + @SQLCase27 + @SQLCase28 + @SQLCase29 + @SQLCase30 +
		        @SQLCase31  + @SQLCase32 + @SQLCase33 + @SQLCase34 + @SQLCase35 + @SQLCase36 + @SQLCase37 + @SQLCase38 + @SQLCase39 + @SQLCase40 +
		        @SQLCase41  + @SQLCase42 + @SQLCase43 + @SQLCase44 + @SQLCase45 + @SQLCase46 + @SQLCase47 + @SQLCase48 + @SQLCase49 + @SQLCase50 +
		        @NewLine + 'from ' + @SQLSource + @NewLine + 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine + 
		        'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine + 'group by ' + @StrippedRowFieldNames + @NewLine + 
                ' union all ' + @Newline + 'select ' + @ColTotals + 
		        @SQLTtC1  + @SQLTtC2  + @SQLTtC3  + @SQLTtC4  + @SQLTtC5  + @SQLTtC6  + @SQLTtC7  + @SQLTtC8  + @SQLTtC9  + @SQLTtC10 + 
                @SQLTtC11 + @SQLTtC12 + @SQLTtC13 + @SQLTtC14 + @SQLTtC15 + @SQLTtC16 + @SQLTtC17 + @SQLTtC18 + @SQLTtC19 + @SQLTtC20 + 
		        @SQLTtC21 + @SQLTtC22 + @SQLTtC23 + @SQLTtC24 + @SQLTtC25 + @SQLTtC26 + @SQLTtC27 + @SQLTtC28 + @SQLTtC29 + @SQLTtC30 +
                ' ) X ' + @AddOrder + @NewLine 
                )                    
        end
    end
end
else
begin
    if      @RowTotals is not null
    begin
        if		@TempTableName is not null
        begin   -- Row totals, no col totals, temp table
        if      @Debug = 1 
        begin
            print   '--5 Row totals, no col totals, temp table'
            print 'insert into ' + @TempTableName + '(' + @StrippedRowFieldNames 
		    print @SQLIns1  print @SQLIns2  print @SQLIns3  print @SQLIns4  print @SQLIns5  print @SQLIns6  print @SQLIns7 
            print @SQLIns8  print @SQLIns9  print @SQLIns10 print @SQLIns11 print @SQLIns12 print @SQLIns13 print @SQLIns14 
            print @SQLIns15 print @SQLIns16 print @SQLIns17 print @SQLIns18 print @SQLIns19 print @SQLIns20 print @SQLIns21  
            print @SQLIns22 print @SQLIns23 print @SQLIns24 print @SQLIns25 print @SQLIns26 print @SQLIns27 print @SQLIns28 
            print @SQLIns29 print @SQLIns30 print ', [' + @RowTotals + '])' print 'select ' + @StrippedRowFieldNames
		    print @SQLCol1  print @SQLCol2  print @SQLCol3  print @SQLCol4  print @SQLCol5  print @SQLCol6  print @SQLCol7 
            print @SQLCol8  print @SQLCol9  print @SQLCol10 print @SQLCol11 print @SQLCol12 print @SQLCol13 print @SQLCol14 
            print @SQLCol15 print @SQLCol16 print @SQLCol17 print @SQLCol18 print @SQLCol19 print @SQLCol20 print @SQLCol21  
            print @SQLCol22 print @SQLCol23 print @SQLCol24 print @SQLCol25 print @SQLCol26 print @SQLCol27 print @SQLCol28 
            print @SQLCol29 print @SQLCol30 print @SQLCol31 print @SQLCol32 print @SQLCol33 print @SQLCol34 print @SQLCol35 
            print @SQLCol36 print @SQLCol37 print @SQLCol38 print @SQLCol39 print @SQLCol40 print @SQLCol41 print @SQLCol42 
            print @SQLCol43 print @SQLCol44 print @SQLCol45 print @SQLCol46 print @SQLCol47 print @SQLCol48 print @SQLCol49 
            print @SQLCol50 print   @NewLine + ', '  
		    print @SQLTot1  print @SQLTot2  print @SQLTot3  print @SQLTot4  print @SQLTot5  print @SQLTot6  print @SQLTot7 
            print @SQLTot8  print @SQLTot9  print @SQLTot10 print @SQLTot11 print @SQLTot12 print @SQLTot13 print @SQLTot14 
            print @SQLTot15 print @SQLTot16 print @SQLTot17 print @SQLTot18 print @SQLTot19 print @SQLTot20 print @SQLTot21  
            print @SQLTot22 print @SQLTot23 print @SQLTot24 print @SQLTot25 print @SQLTot26 print @SQLTot27 print @SQLTot28 
            print @SQLTot29 print @SQLTot30 print @SQLTot31 print @SQLTot32 print @SQLTot33 print @SQLTot34 print @SQLTot35 
            print @SQLTot36 print @SQLTot37 print @SQLTot38 print @SQLTot39 print @SQLTot40 print @SQLTot41 print @SQLTot42 
            print @SQLTot43 print @SQLTot44 print @SQLTot45 print @SQLTot46 print @SQLTot47 print @SQLTot48 print @SQLTot49 
            print @SQLTot50 print   ' [' + @RowTotals + ']' + @NewLine 	    print  @NewLine + ' from (select ' + @RowFieldNames 
		    print @SQLCase1  print @SQLCase2  print @SQLCase3  print @SQLCase4  print @SQLCase5  print @SQLCase6  print @SQLCase7
		    print @SQLCase8  print @SQLCase9  print @SQLCase10 print @SQLCase11 print @SQLCase12 print @SQLCase13 print @SQLCase14 
            print @SQLCase15 print @SQLCase16 print @SQLCase17 print @SQLCase18 print @SQLCase19 print @SQLCase20 print @SQLCase21  
            print @SQLCase22 print @SQLCase23 print @SQLCase24 print @SQLCase25 print @SQLCase26 print @SQLCase27 print @SQLCase28 
            print @SQLCase29 print @SQLCase30 print @SQLCase31 print @SQLCase32 print @SQLCase33 print @SQLCase34 print @SQLCase35 
            print @SQLCase36 print @SQLCase37 print @SQLCase38 print @SQLCase39 print @SQLCase40 print @SQLCase41 print @SQLCase42 
            print @SQLCase43 print @SQLCase44 print @SQLCase45 print @SQLCase46 print @SQLCase47 print @SQLCase48 print @SQLCase49 
            print @SQLCase50 + @NewLine 
            print 'from ' + @SQLSource + @NewLine 
            print 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine 
            print 'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine 
            print 'group by ' + @StrippedRowFieldNames + @NewLine + @AddOrder
        end		        

        exec	('insert into ' + @TempTableName + '(' + @StrippedRowFieldNames +
		        @SQLIns1  + @SQLIns2 + @SQLIns3 + @SQLIns4 + @SQLIns5 + @SQLIns6 + @SQLIns7 + @SQLIns8 + @SQLIns9 + @SQLIns10 +
		        @SQLIns11  + @SQLIns12 + @SQLIns13 + @SQLIns14 + @SQLIns15 + @SQLIns16 + @SQLIns17 + @SQLIns18 + @SQLIns19 + @SQLIns20 +
		        @SQLIns21  + @SQLIns22 + @SQLIns23 + @SQLIns24 + @SQLIns25 + @SQLIns26 + @SQLIns27 + @SQLIns28 + @SQLIns29 + @SQLIns30 + 
                ', [' + @RowTotals + '])' + 
		        'select ' + @StrippedRowFieldNames + 
		        @SQLCol1  + @SQLCol2 + @SQLCol3 + @SQLCol4 + @SQLCol5 + @SQLCol6 + @SQLCol7 + @SQLCol8 + @SQLCol9 + @SQLCol10 +
		        @SQLCol11  + @SQLCol12 + @SQLCol13 + @SQLCol14 + @SQLCol15 + @SQLCol16 + @SQLCol17 + @SQLCol18 + @SQLCol19 + @SQLCol20 +
		        @SQLCol21  + @SQLCol22 + @SQLCol23 + @SQLCol24 + @SQLCol25 + @SQLCol26 + @SQLCol27 + @SQLCol28 + @SQLCol29 + @SQLCol30 +
		        @SQLCol31  + @SQLCol32 + @SQLCol33 + @SQLCol34 + @SQLCol35 + @SQLCol36 + @SQLCol37 + @SQLCol38 + @SQLCol39 + @SQLCol40 +
		        @SQLCol41  + @SQLCol42 + @SQLCol43 + @SQLCol44 + @SQLCol45 + @SQLCol46 + @SQLCol47 + @SQLCol48 + @SQLCol49 + @SQLCol50 +
		        @NewLine + ', ' + 
		        @SQLTot1  + @SQLTot2 + @SQLTot3 + @SQLTot4 + @SQLTot5 + @SQLTot6 + @SQLTot7 + @SQLTot8 + @SQLTot9 + @SQLTot10 +
		        @SQLTot11  + @SQLTot12 + @SQLTot13 + @SQLTot14 + @SQLTot15 + @SQLTot16 + @SQLTot17 + @SQLTot18 + @SQLTot19 + @SQLTot20 +
		        @SQLTot21  + @SQLTot22 + @SQLTot23 + @SQLTot24 + @SQLTot25 + @SQLTot26 + @SQLTot27 + @SQLTot28 + @SQLTot29 + @SQLTot30 +
		        @SQLTot31  + @SQLTot32 + @SQLTot33 + @SQLTot34 + @SQLTot35 + @SQLTot36 + @SQLTot37 + @SQLTot38 + @SQLTot39 + @SQLTot40 +
		        @SQLTot41  + @SQLTot42 + @SQLTot43 + @SQLTot44 + @SQLTot45 + @SQLTot46 + @SQLTot47 + @SQLTot48 + @SQLTot49 + @SQLTot50 +
                ' [' + @RowTotals + ']' + @NewLine + 
		        @NewLine + ' from (select ' + @RowFieldNames +
		        @SQLCase1 + @SQLCase2 + @SQLCase3 + @SQLCase4 + @SQLCase5 + @SQLCase6 + @SQLCase7 + @SQLCase8 + @SQLCase9 + @SQLCase10 +
		        @SQLCase11  + @SQLCase12 + @SQLCase13 + @SQLCase14 + @SQLCase15 + @SQLCase16 + @SQLCase17 + @SQLCase18 + @SQLCase19 + @SQLCase20 +
		        @SQLCase21  + @SQLCase22 + @SQLCase23 + @SQLCase24 + @SQLCase25 + @SQLCase26 + @SQLCase27 + @SQLCase28 + @SQLCase29 + @SQLCase30 +
		        @SQLCase31  + @SQLCase32 + @SQLCase33 + @SQLCase34 + @SQLCase35 + @SQLCase36 + @SQLCase37 + @SQLCase38 + @SQLCase39 + @SQLCase40 +
		        @SQLCase41  + @SQLCase42 + @SQLCase43 + @SQLCase44 + @SQLCase45 + @SQLCase46 + @SQLCase47 + @SQLCase48 + @SQLCase49 + @SQLCase50 +
		        @NewLine + 'from ' + @SQLSource + @NewLine + 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine + 
		        'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine + 'group by ' + @StrippedRowFieldNames + @NewLine + @AddOrder
		        )
        end
        else
        begin   -- Row totals, no col totals, no temp table
        if      @Debug = 1 
        begin
            print   '--6 Row totals, no col totals, no temp table'
            print 'select ' + @StrippedRowFieldNames
		    print @SQLCol1  print @SQLCol2  print @SQLCol3  print @SQLCol4  print @SQLCol5  print @SQLCol6  print @SQLCol7 
            print @SQLCol8  print @SQLCol9  print @SQLCol10 print @SQLCol11 print @SQLCol12 print @SQLCol13 print @SQLCol14 
            print @SQLCol15 print @SQLCol16 print @SQLCol17 print @SQLCol18 print @SQLCol19 print @SQLCol20 print @SQLCol21  
            print @SQLCol22 print @SQLCol23 print @SQLCol24 print @SQLCol25 print @SQLCol26 print @SQLCol27 print @SQLCol28 
            print @SQLCol29 print @SQLCol30 print @SQLCol31 print @SQLCol32 print @SQLCol33 print @SQLCol34 print @SQLCol35 
            print @SQLCol36 print @SQLCol37 print @SQLCol38 print @SQLCol39 print @SQLCol40 print @SQLCol41 print @SQLCol42 
            print @SQLCol43 print @SQLCol44 print @SQLCol45 print @SQLCol46 print @SQLCol47 print @SQLCol48 print @SQLCol49 
            print @SQLCol50 print   @NewLine + ', '  
		    print @SQLTot1  print @SQLTot2  print @SQLTot3  print @SQLTot4  print @SQLTot5  print @SQLTot6  print @SQLTot7 
            print @SQLTot8  print @SQLTot9  print @SQLTot10 print @SQLTot11 print @SQLTot12 print @SQLTot13 print @SQLTot14 
            print @SQLTot15 print @SQLTot16 print @SQLTot17 print @SQLTot18 print @SQLTot19 print @SQLTot20 print @SQLTot21  
            print @SQLTot22 print @SQLTot23 print @SQLTot24 print @SQLTot25 print @SQLTot26 print @SQLTot27 print @SQLTot28 
            print @SQLTot29 print @SQLTot30 print @SQLTot31 print @SQLTot32 print @SQLTot33 print @SQLTot34 print @SQLTot35 
            print @SQLTot36 print @SQLTot37 print @SQLTot38 print @SQLTot39 print @SQLTot40 print @SQLTot41 print @SQLTot42 
            print @SQLTot43 print @SQLTot44 print @SQLTot45 print @SQLTot46 print @SQLTot47 print @SQLTot48 print @SQLTot49 
            print @SQLTot50 print   ' [' + @RowTotals + ']' + @NewLine 	    print  @NewLine + ' from (select ' + @RowFieldNames 
		    print @SQLCase1  print @SQLCase2  print @SQLCase3  print @SQLCase4  print @SQLCase5  print @SQLCase6  print @SQLCase7
		    print @SQLCase8  print @SQLCase9  print @SQLCase10 print @SQLCase11 print @SQLCase12 print @SQLCase13 print @SQLCase14 
            print @SQLCase15 print @SQLCase16 print @SQLCase17 print @SQLCase18 print @SQLCase19 print @SQLCase20 print @SQLCase21  
            print @SQLCase22 print @SQLCase23 print @SQLCase24 print @SQLCase25 print @SQLCase26 print @SQLCase27 print @SQLCase28 
            print @SQLCase29 print @SQLCase30 print @SQLCase31 print @SQLCase32 print @SQLCase33 print @SQLCase34 print @SQLCase35 
            print @SQLCase36 print @SQLCase37 print @SQLCase38 print @SQLCase39 print @SQLCase40 print @SQLCase41 print @SQLCase42 
            print @SQLCase43 print @SQLCase44 print @SQLCase45 print @SQLCase46 print @SQLCase47 print @SQLCase48 print @SQLCase49 
            print @SQLCase50 + @NewLine 
            print 'from ' + @SQLSource + @NewLine 
            print 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine 
            print 'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine 
            print 'group by ' + @StrippedRowFieldNames + @NewLine + @AddOrder
        end		        

        exec	('select ' + @StrippedRowFieldNames + 
		        @SQLCol1  + @SQLCol2 + @SQLCol3 + @SQLCol4 + @SQLCol5 + @SQLCol6 + @SQLCol7 + @SQLCol8 + @SQLCol9 + @SQLCol10 +
		        @SQLCol11  + @SQLCol12 + @SQLCol13 + @SQLCol14 + @SQLCol15 + @SQLCol16 + @SQLCol17 + @SQLCol18 + @SQLCol19 + @SQLCol20 +
		        @SQLCol21  + @SQLCol22 + @SQLCol23 + @SQLCol24 + @SQLCol25 + @SQLCol26 + @SQLCol27 + @SQLCol28 + @SQLCol29 + @SQLCol30 +
		        @SQLCol31  + @SQLCol32 + @SQLCol33 + @SQLCol34 + @SQLCol35 + @SQLCol36 + @SQLCol37 + @SQLCol38 + @SQLCol39 + @SQLCol40 +
		        @SQLCol41  + @SQLCol42 + @SQLCol43 + @SQLCol44 + @SQLCol45 + @SQLCol46 + @SQLCol47 + @SQLCol48 + @SQLCol49 + @SQLCol50 +
		        @NewLine + ', ' + 
		        @SQLTot1  + @SQLTot2 + @SQLTot3 + @SQLTot4 + @SQLTot5 + @SQLTot6 + @SQLTot7 + @SQLTot8 + @SQLTot9 + @SQLTot10 +
		        @SQLTot11  + @SQLTot12 + @SQLTot13 + @SQLTot14 + @SQLTot15 + @SQLTot16 + @SQLTot17 + @SQLTot18 + @SQLTot19 + @SQLTot20 +
		        @SQLTot21  + @SQLTot22 + @SQLTot23 + @SQLTot24 + @SQLTot25 + @SQLTot26 + @SQLTot27 + @SQLTot28 + @SQLTot29 + @SQLTot30 +
		        @SQLTot31  + @SQLTot32 + @SQLTot33 + @SQLTot34 + @SQLTot35 + @SQLTot36 + @SQLTot37 + @SQLTot38 + @SQLTot39 + @SQLTot40 +
		        @SQLTot41  + @SQLTot42 + @SQLTot43 + @SQLTot44 + @SQLTot45 + @SQLTot46 + @SQLTot47 + @SQLTot48 + @SQLTot49 + @SQLTot50 +
                ' [' + @RowTotals + ']' + @NewLine +
		        @NewLine + ' from (select ' + @RowFieldNames +
		        @SQLCase1 + @SQLCase2 + @SQLCase3 + @SQLCase4 + @SQLCase5 + @SQLCase6 + @SQLCase7 + @SQLCase8 + @SQLCase9 + @SQLCase10 +
		        @SQLCase11  + @SQLCase12 + @SQLCase13 + @SQLCase14 + @SQLCase15 + @SQLCase16 + @SQLCase17 + @SQLCase18 + @SQLCase19 + @SQLCase20 +
		        @SQLCase21  + @SQLCase22 + @SQLCase23 + @SQLCase24 + @SQLCase25 + @SQLCase26 + @SQLCase27 + @SQLCase28 + @SQLCase29 + @SQLCase30 +
		        @SQLCase31  + @SQLCase32 + @SQLCase33 + @SQLCase34 + @SQLCase35 + @SQLCase36 + @SQLCase37 + @SQLCase38 + @SQLCase39 + @SQLCase40 +
		        @SQLCase41  + @SQLCase42 + @SQLCase43 + @SQLCase44 + @SQLCase45 + @SQLCase46 + @SQLCase47 + @SQLCase48 + @SQLCase49 + @SQLCase50 +
		        @NewLine + 'from ' + @SQLSource + @NewLine + 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine + 
		        'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine + 'group by ' + @StrippedRowFieldNames + @NewLine + @AddOrder
                )
        end
    end
    else
    begin
        if		@TempTableName is not null
        begin   -- No row totals, no col totals, temp table
        if      @Debug = 1 
        begin
            print   '--7 No row totals, no col totals, temp table'
            print 'insert into ' + @TempTableName + '(' + @StrippedRowFieldNames 
		    print @SQLIns1  print @SQLIns2  print @SQLIns3  print @SQLIns4  print @SQLIns5  print @SQLIns6  print @SQLIns7 
            print @SQLIns8  print @SQLIns9  print @SQLIns10 print @SQLIns11 print @SQLIns12 print @SQLIns13 print @SQLIns14 
            print @SQLIns15 print @SQLIns16 print @SQLIns17 print @SQLIns18 print @SQLIns19 print @SQLIns20 print @SQLIns21  
            print @SQLIns22 print @SQLIns23 print @SQLIns24 print @SQLIns25 print @SQLIns26 print @SQLIns27 print @SQLIns28 
            print @SQLIns29 print @SQLIns30 print ')' print 'select ' + @StrippedRowFieldNames
		    print @SQLCol1  print @SQLCol2  print @SQLCol3  print @SQLCol4  print @SQLCol5  print @SQLCol6  print @SQLCol7 
            print @SQLCol8  print @SQLCol9  print @SQLCol10 print @SQLCol11 print @SQLCol12 print @SQLCol13 print @SQLCol14 
            print @SQLCol15 print @SQLCol16 print @SQLCol17 print @SQLCol18 print @SQLCol19 print @SQLCol20 print @SQLCol21  
            print @SQLCol22 print @SQLCol23 print @SQLCol24 print @SQLCol25 print @SQLCol26 print @SQLCol27 print @SQLCol28 
            print @SQLCol29 print @SQLCol30 print @SQLCol31 print @SQLCol32 print @SQLCol33 print @SQLCol34 print @SQLCol35 
            print @SQLCol36 print @SQLCol37 print @SQLCol38 print @SQLCol39 print @SQLCol40 print @SQLCol41 print @SQLCol42 
            print @SQLCol43 print @SQLCol44 print @SQLCol45 print @SQLCol46 print @SQLCol47 print @SQLCol48 print @SQLCol49 
            print @SQLCol50 print @NewLine + ' from (select ' + @RowFieldNames 
		    print @SQLCase1  print @SQLCase2  print @SQLCase3  print @SQLCase4  print @SQLCase5  print @SQLCase6  print @SQLCase7
		    print @SQLCase8  print @SQLCase9  print @SQLCase10 print @SQLCase11 print @SQLCase12 print @SQLCase13 print @SQLCase14 
            print @SQLCase15 print @SQLCase16 print @SQLCase17 print @SQLCase18 print @SQLCase19 print @SQLCase20 print @SQLCase21  
            print @SQLCase22 print @SQLCase23 print @SQLCase24 print @SQLCase25 print @SQLCase26 print @SQLCase27 print @SQLCase28 
            print @SQLCase29 print @SQLCase30 print @SQLCase31 print @SQLCase32 print @SQLCase33 print @SQLCase34 print @SQLCase35 
            print @SQLCase36 print @SQLCase37 print @SQLCase38 print @SQLCase39 print @SQLCase40 print @SQLCase41 print @SQLCase42 
            print @SQLCase43 print @SQLCase44 print @SQLCase45 print @SQLCase46 print @SQLCase47 print @SQLCase48 print @SQLCase49 
            print @SQLCase50 + @NewLine 
            print 'from ' + @SQLSource + @NewLine 
            print 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine 
            print 'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine 
            print 'group by ' + @StrippedRowFieldNames + @NewLine + @AddOrder
        end 

        exec	('insert into ' + @TempTableName + '(' + @StrippedRowFieldNames +
		        @SQLIns1  + @SQLIns2 + @SQLIns3 + @SQLIns4 + @SQLIns5 + @SQLIns6 + @SQLIns7 + @SQLIns8 + @SQLIns9 + @SQLIns10 +
		        @SQLIns11  + @SQLIns12 + @SQLIns13 + @SQLIns14 + @SQLIns15 + @SQLIns16 + @SQLIns17 + @SQLIns18 + @SQLIns19 + @SQLIns20 +
		        @SQLIns21  + @SQLIns22 + @SQLIns23 + @SQLIns24 + @SQLIns25 + @SQLIns26 + @SQLIns27 + @SQLIns28 + @SQLIns29 + @SQLIns30 + ')' + 
		        'select ' + @StrippedRowFieldNames + 
		        @SQLCol1  + @SQLCol2 + @SQLCol3 + @SQLCol4 + @SQLCol5 + @SQLCol6 + @SQLCol7 + @SQLCol8 + @SQLCol9 + @SQLCol10 +
		        @SQLCol11  + @SQLCol12 + @SQLCol13 + @SQLCol14 + @SQLCol15 + @SQLCol16 + @SQLCol17 + @SQLCol18 + @SQLCol19 + @SQLCol20 +
		        @SQLCol21  + @SQLCol22 + @SQLCol23 + @SQLCol24 + @SQLCol25 + @SQLCol26 + @SQLCol27 + @SQLCol28 + @SQLCol29 + @SQLCol30 +
		        @SQLCol31  + @SQLCol32 + @SQLCol33 + @SQLCol34 + @SQLCol35 + @SQLCol36 + @SQLCol37 + @SQLCol38 + @SQLCol39 + @SQLCol40 +
		        @SQLCol41  + @SQLCol42 + @SQLCol43 + @SQLCol44 + @SQLCol45 + @SQLCol46 + @SQLCol47 + @SQLCol48 + @SQLCol49 + @SQLCol50 +
		        @NewLine + ' from (select ' + @RowFieldNames +
		        @SQLCase1 + @SQLCase2 + @SQLCase3 + @SQLCase4 + @SQLCase5 + @SQLCase6 + @SQLCase7 + @SQLCase8 + @SQLCase9 + @SQLCase10 +
		        @SQLCase11  + @SQLCase12 + @SQLCase13 + @SQLCase14 + @SQLCase15 + @SQLCase16 + @SQLCase17 + @SQLCase18 + @SQLCase19 + @SQLCase20 +
		        @SQLCase21  + @SQLCase22 + @SQLCase23 + @SQLCase24 + @SQLCase25 + @SQLCase26 + @SQLCase27 + @SQLCase28 + @SQLCase29 + @SQLCase30 +
		        @SQLCase31  + @SQLCase32 + @SQLCase33 + @SQLCase34 + @SQLCase35 + @SQLCase36 + @SQLCase37 + @SQLCase38 + @SQLCase39 + @SQLCase40 +
		        @SQLCase41  + @SQLCase42 + @SQLCase43 + @SQLCase44 + @SQLCase45 + @SQLCase46 + @SQLCase47 + @SQLCase48 + @SQLCase49 + @SQLCase50 +
		        @NewLine + 'from ' + @SQLSource + @NewLine + 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine + 
		        'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine + 'group by ' + @StrippedRowFieldNames + @NewLine + @AddOrder
		        )
        end
        else
        begin   -- No row totals, no col totals, no temp table
        if      @Debug = 1
        begin
            print   '--8 No row totals, no col totals, no temp table'
            print 'select ' + @StrippedRowFieldNames
		    print @SQLCol1  print @SQLCol2  print @SQLCol3  print @SQLCol4  print @SQLCol5  print @SQLCol6  print @SQLCol7 
            print @SQLCol8  print @SQLCol9  print @SQLCol10 print @SQLCol11 print @SQLCol12 print @SQLCol13 print @SQLCol14 
            print @SQLCol15 print @SQLCol16 print @SQLCol17 print @SQLCol18 print @SQLCol19 print @SQLCol20 print @SQLCol21  
            print @SQLCol22 print @SQLCol23 print @SQLCol24 print @SQLCol25 print @SQLCol26 print @SQLCol27 print @SQLCol28 
            print @SQLCol29 print @SQLCol30 print @SQLCol31 print @SQLCol32 print @SQLCol33 print @SQLCol34 print @SQLCol35 
            print @SQLCol36 print @SQLCol37 print @SQLCol38 print @SQLCol39 print @SQLCol40 print @SQLCol41 print @SQLCol42 
            print @SQLCol43 print @SQLCol44 print @SQLCol45 print @SQLCol46 print @SQLCol47 print @SQLCol48 print @SQLCol49 
            print @SQLCol50 print @NewLine + ' from (select ' + @RowFieldNames 
		    print @SQLCase1  print @SQLCase2  print @SQLCase3  print @SQLCase4  print @SQLCase5  print @SQLCase6  print @SQLCase7
		    print @SQLCase8  print @SQLCase9  print @SQLCase10 print @SQLCase11 print @SQLCase12 print @SQLCase13 print @SQLCase14 
            print @SQLCase15 print @SQLCase16 print @SQLCase17 print @SQLCase18 print @SQLCase19 print @SQLCase20 print @SQLCase21  
            print @SQLCase22 print @SQLCase23 print @SQLCase24 print @SQLCase25 print @SQLCase26 print @SQLCase27 print @SQLCase28 
            print @SQLCase29 print @SQLCase30 print @SQLCase31 print @SQLCase32 print @SQLCase33 print @SQLCase34 print @SQLCase35 
            print @SQLCase36 print @SQLCase37 print @SQLCase38 print @SQLCase39 print @SQLCase40 print @SQLCase41 print @SQLCase42 
            print @SQLCase43 print @SQLCase44 print @SQLCase45 print @SQLCase46 print @SQLCase47 print @SQLCase48 print @SQLCase49 
            print @SQLCase50 + @NewLine 
            print 'from ' + @SQLSource + @NewLine 
            print 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine 
            print 'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine 
            print 'group by ' + @StrippedRowFieldNames + @NewLine + @AddOrder
        end 

        exec	('select ' + @StrippedRowFieldNames + 
		        @SQLCol1  + @SQLCol2 + @SQLCol3 + @SQLCol4 + @SQLCol5 + @SQLCol6 + @SQLCol7 + @SQLCol8 + @SQLCol9 + @SQLCol10 +
		        @SQLCol11  + @SQLCol12 + @SQLCol13 + @SQLCol14 + @SQLCol15 + @SQLCol16 + @SQLCol17 + @SQLCol18 + @SQLCol19 + @SQLCol20 +
		        @SQLCol21  + @SQLCol22 + @SQLCol23 + @SQLCol24 + @SQLCol25 + @SQLCol26 + @SQLCol27 + @SQLCol28 + @SQLCol29 + @SQLCol30 +
		        @SQLCol31  + @SQLCol32 + @SQLCol33 + @SQLCol34 + @SQLCol35 + @SQLCol36 + @SQLCol37 + @SQLCol38 + @SQLCol39 + @SQLCol40 +
		        @SQLCol41  + @SQLCol42 + @SQLCol43 + @SQLCol44 + @SQLCol45 + @SQLCol46 + @SQLCol47 + @SQLCol48 + @SQLCol49 + @SQLCol50 +
		        @NewLine + ' from (select ' + @RowFieldNames +
		        @SQLCase1 + @SQLCase2 + @SQLCase3 + @SQLCase4 + @SQLCase5 + @SQLCase6 + @SQLCase7 + @SQLCase8 + @SQLCase9 + @SQLCase10 +
		        @SQLCase11  + @SQLCase12 + @SQLCase13 + @SQLCase14 + @SQLCase15 + @SQLCase16 + @SQLCase17 + @SQLCase18 + @SQLCase19 + @SQLCase20 +
		        @SQLCase21  + @SQLCase22 + @SQLCase23 + @SQLCase24 + @SQLCase25 + @SQLCase26 + @SQLCase27 + @SQLCase28 + @SQLCase29 + @SQLCase30 +
		        @SQLCase31  + @SQLCase32 + @SQLCase33 + @SQLCase34 + @SQLCase35 + @SQLCase36 + @SQLCase37 + @SQLCase38 + @SQLCase39 + @SQLCase40 +
		        @SQLCase41  + @SQLCase42 + @SQLCase43 + @SQLCase44 + @SQLCase45 + @SQLCase46 + @SQLCase47 + @SQLCase48 + @SQLCase49 + @SQLCase50 +
		        @NewLine + 'from ' + @SQLSource + @NewLine + 'where ' + @CalcFieldName + ' is not null' + @NewLine + @AddWhere + @NewLine + 
		        'group by ' + @RowFieldNames + ', ' + @ColFieldID + ') X' + @NewLine + 'group by ' + @StrippedRowFieldNames + @NewLine + @AddOrder
                )
        end
    end
end


drop table  #Columns


-----=====******--~-~--~~---~-~---~~-~-~---~---~--~--~~~-~-~---~---~--~*****=====-----
--              Fin.

GO
