CREATE TABLE [dbo].[destination_shipping]
(
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[scac_code] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[trans_mode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[dock_code_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[model_year_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fob] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[freigt_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[note_for_shipper] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[note_for_bol] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[print_shipper_note] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[print_bol_note] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[allow_mult_po] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ship_day] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[will_call_customer] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[allow_overstage] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SundayShip] [int] NULL,
[MondayShip] [int] NULL,
[TuesdayShip] [int] NULL,
[WednesdayShip] [int] NULL,
[ThursdayShip] [int] NULL,
[FridayShip] [int] NULL,
[SaturdayShip] [int] NULL
) ON [PRIMARY]
GO
