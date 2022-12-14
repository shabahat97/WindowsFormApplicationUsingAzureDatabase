/****** Object:  Database [SuperVoters]    Script Date: 3/4/2022 3:57:37 PM ******/
CREATE DATABASE [SuperVoters]  (EDITION = 'Basic', SERVICE_OBJECTIVE = 'Basic', MAXSIZE = 2 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS;
GO
ALTER DATABASE [SuperVoters] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SuperVoters] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SuperVoters] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SuperVoters] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SuperVoters] SET ARITHABORT OFF 
GO
ALTER DATABASE [SuperVoters] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SuperVoters] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SuperVoters] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SuperVoters] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SuperVoters] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SuperVoters] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SuperVoters] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SuperVoters] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SuperVoters] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [SuperVoters] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SuperVoters] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [SuperVoters] SET  MULTI_USER 
GO
ALTER DATABASE [SuperVoters] SET ENCRYPTION ON
GO
ALTER DATABASE [SuperVoters] SET QUERY_STORE = ON
GO
ALTER DATABASE [SuperVoters] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 7), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 10, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
/*** The scripts of database scoped configurations in Azure should be executed inside the target database connection. ***/
GO
-- ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
/****** Object:  Table [dbo].[CastVote]    Script Date: 3/4/2022 3:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CastVote](
	[ElectionId] [int] NOT NULL,
	[VoterId] [int] NOT NULL,
	[CandidateId] [int] NOT NULL,
	[DateInserted] [varchar](25) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Election]    Script Date: 3/4/2022 3:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Election](
	[EleId] [int] NOT NULL,
	[EleTopic] [char](50) NOT NULL,
	[DateRange] [date] NULL,
	[CanId] [int] NULL,
 CONSTRAINT [PK_Election] PRIMARY KEY CLUSTERED 
(
	[EleId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Register]    Script Date: 3/4/2022 3:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Register](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Role] [varchar](10) NOT NULL,
	[FirstName] [varchar](20) NOT NULL,
	[MiddleName] [varchar](20) NULL,
	[DateOfBirth] [varchar](8) NOT NULL,
	[Email] [varchar](20) NOT NULL,
	[Address] [varchar](50) NOT NULL,
	[LastName] [varchar](20) NOT NULL,
 CONSTRAINT [PK_NewTable-1] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TempCandidate]    Script Date: 3/4/2022 3:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TempCandidate](
	[CandidateId] [int] IDENTITY(1,1) NOT NULL,
	[CandidateName] [varchar](25) NOT NULL,
 CONSTRAINT [PK_TempCandidate] PRIMARY KEY CLUSTERED 
(
	[CandidateId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetElectionDates]    Script Date: 3/4/2022 3:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Run
--exec dbo.GetElectionDates

CREATE PROCEDURE [dbo].[GetElectionDates]  
AS   
    SET NOCOUNT ON;  
    SELECT Distinct convert(varchar, cast(DateInserted as date), 107) as ElectionDate
    FROM SuperVoters.dbo.CastVote  
GO
/****** Object:  StoredProcedure [dbo].[GetElectionDates2]    Script Date: 3/4/2022 3:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetElectionDates2]  
AS   
    SET NOCOUNT ON;  
    SELECT Distinct convert(varchar, cast(DateInserted as date), 107) 
    FROM SuperVoters.dbo.CastVote  
GO
/****** Object:  StoredProcedure [dbo].[GetVoteResults]    Script Date: 3/4/2022 3:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Test
/* 
exec dbo.GetVoteResults '03/03/22'
select * from dbo.CastVote
select * from dbo.TempCandidate
*/

CREATE PROCEDURE [dbo].[GetVoteResults]  
    @DateOfElection nvarchar(50)  
AS   
    SET NOCOUNT ON; 

    SELECT * INTO #temp from 
    (SELECT cv.CandidateId,  COUNT(*) as TotalVotes
    FROM SuperVoters.dbo.CastVote cv 
    JOIN SuperVoters.dbo.TempCandidate c on cv.CandidateId = c.CandidateId
     WHERE CAST(cv.DateInserted as date) = CAST(@DateOfElection as date)
    Group By cv.CandidateId) as abc

    SELECT c.CandidateName, t.TotalVotes from #Temp t
    JOIN dbo.TempCandidate c on c.CandidateId = t.CandidateId
 
GO
ALTER DATABASE [SuperVoters] SET  READ_WRITE 
GO
