CREATE TABLE [dbo].[part_eecustom]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[eau] [int] NULL,
[imds] [int] NULL,
[longest_lt] [int] NULL,
[min_prod_run] [numeric] (20, 6) NULL,
[critical_part] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[criticalpartnotes] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[auto_releases] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[weeks_to_freeze] [smallint] NULL,
[prod_start] [datetime] NULL,
[prod_end] [datetime] NULL,
[generate_mr] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_ship] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_ship_note] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_ship_operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prod_pre_end] [smallint] NULL,
[tb_pricing] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[backdays] [int] NULL,
[link1] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link2] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link3] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link4] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link5] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link6] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link7] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link8] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link9] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link10] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ppap_expdt] [datetime] NULL,
[std_hours] [numeric] (20, 6) NULL CONSTRAINT [df_sdt_hours] DEFAULT ((0)),
[quoted_bom_cost] [numeric] (20, 6) NULL,
[prod_bom_cost] [numeric] (20, 6) NULL,
[team_no] [int] NULL,
[non_order_status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_order_note] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_order_operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sales_return_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MinutestoApproveBox] [numeric] (20, 6) NULL,
[Expedite] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServicePart] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentRevLevel] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForeignProduct] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LowVolume] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUBasePrice] [numeric] (20, 6) NULL CONSTRAINT [DF__part_eecu__CUBas__0C3BC58A] DEFAULT ((0)),
[OriginalQuoteDate] [datetime] NULL CONSTRAINT [DF__part_eecu__Origi__0D2FE9C3] DEFAULT (NULL),
[Surchargable] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__part_eecu__Surch__0E240DFC] DEFAULT ('N'),
[ExpediteQty] [numeric] (20, 6) NULL,
[CriticalQty] [numeric] (20, 6) NULL,
[MinDaysDemandOnHand] [int] NULL,
[MaxDaysDemandOnHand] [int] NULL,
[EEIQCInspection] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EEHQCInspection] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Require_Lot] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__part_eecu__part___7E1EB37B] DEFAULT ('N')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Andre S.Boulanger>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[ft_tr_part_eecustom]
   ON  [dbo].[part_eecustom]
   for update 
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare	@DeletedPart varchar(25),
					@DeletedCurrentRev char(1),
					@InsertedCurrentRev char(1),
					@InsertedBasePart char(7),
					@InsertedPart varchar(25)
		select	@InsertedCurrentRev = CurrentRevLevel from inserted
		select	@DeletedCurrentRev =  CurrentRevLevel from deleted
		select	@InsertedBasePart = left(part,7) from inserted
		select	@InsertedPart = part from inserted
		
		if isNull(@InsertedCurrentRev,'N') != isNull(@DeletedCurrentRev,'N') and @InsertedCurrentRev = 'Y'
		begin
			update part_eecustom set CurrentRevLevel = 'N' where left(part,7) = @InsertedBasePart and part != @InsertedPart
		end
		
		/*if not exists(select 1 from order_header where blanket_part = @InsertedPart and isNull(status,'C') ='A')
		begin
		alter table order_header disable trigger mtr_order_header_u
			update order_header set status = Null  where left(blanket_part,7) = @InsertedBasePart and blanket_part != @InsertedPart
			update order_header set status ='A'  where  blanket_part = @InsertedPart and order_no =(select max(order_no) from order_header where blanket_part = @InsertedPart)
		alter table order_header enable trigger mtr_order_header_u
		End
		*/
		

END
GO
ALTER TABLE [dbo].[part_eecustom] ADD CONSTRAINT [PK__part_eecustom__0A537D18] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[part_eecustom] TO [APPUser]
GO
