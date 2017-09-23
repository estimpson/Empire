CREATE TABLE [dbo].[part_eecustom_njb]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NJB] [int] NOT NULL,
[RevisionNo] [int] NOT NULL,
[NJB_type] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Destination] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerContact] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMail] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fileStatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fileLink] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
