CREATE TABLE [dbo].[TempDestinationContact]
(
[LinkedtoMonitorCustomer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Destination] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Contact] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkedCustomer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LinkedDestination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[currentCustomerContact] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[currentCustomerPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
