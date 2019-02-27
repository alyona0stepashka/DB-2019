USE [KP] 
GO
select * from [dbo].[TEST];
select * from [dbo].[USER];
select * from QUESTION;
select * from RESULT;
select * from POINT; 
select * from TYPE;
select * from HISTORY;

CREATE TABLE [dbo].[USER] (
    [LOGIN]    NVARCHAR (50) NOT NULL,
    [PASSWORD] NVARCHAR (50) NULL,
    [ACCESS]   INT           NULL,
    CONSTRAINT [PK_USER] PRIMARY KEY CLUSTERED ([LOGIN] ASC)
);

CREATE TABLE [dbo].[TEST] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [NAME_TEST] NVARCHAR (50) NOT NULL,
    [AUTHOR]    NVARCHAR (50) NULL,
	[ID_TYPE]        INT  ,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([AUTHOR]) REFERENCES [dbo].[USER] ([LOGIN]),
	FOREIGN KEY ([ID_TYPE]) REFERENCES [dbo].[TYPE] ([ID])
);

CREATE TABLE [dbo].[TYPE] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [NAME_TYPE] NVARCHAR (50),
    PRIMARY KEY CLUSTERED ([ID] ASC)   
);

CREATE TABLE [dbo].[QUESTION] (
    [ID_QUESTION] INT           IDENTITY (1, 1) NOT NULL,
    [ID_TEST]     INT           NULL,
    [QUESTION]    NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([ID_QUESTION] ASC),
    FOREIGN KEY ([ID_TEST]) REFERENCES [dbo].[TEST] ([ID])
);

CREATE TABLE [dbo].[POINT] (
    [ID_ANSWER] INT           IDENTITY (1, 1) NOT NULL,
    [ID_Quest]  INT           NULL,
    [ANSWER]    NVARCHAR (50) NULL,
    [POINT]     INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_ANSWER] ASC),
    FOREIGN KEY ([ID_Quest]) REFERENCES [dbo].[QUESTION] ([ID_QUESTION])
);

CREATE TABLE [dbo].[RESULT] (
    [ID_Result]   INT           IDENTITY (1, 1) NOT NULL,
    [ID_Test]     INT           NULL,
    [RESULT1]     INT           NULL,
    [RESULT2]     INT           NULL,
    [TEXT_RESULT] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([ID_Result] ASC),
    FOREIGN KEY ([ID_Test]) REFERENCES [dbo].[TEST] ([ID])
);
 
CREATE TABLE [dbo].[HISTORY] (
    [ID] INT           IDENTITY (1, 1) NOT NULL,
    [ID_USER]  NVARCHAR (50) NOT NULL,
    [ID_RESULTH]    INT NULL,
	[ID_TYPE] INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([ID_USER]) REFERENCES [dbo].[USER] ([LOGIN]),
	FOREIGN KEY ([ID_TYPE]) REFERENCES [dbo].[TYPE] ([ID])
);
----------------------------------------PROC and FUNC-----------------------------------
------------------------Take_user_info--------------------------
alter proc Take_user_info
   @login nvarchar(50)
  as begin 
  begin try
  select * from [dbo].[USER] where LOGIN=@login;
  end try
begin catch
print error_message()
  end catch
  END;

   exec Take_user_info @login='admin';
   go
------------------------InsertUser--------------------------
   CREATE PROCEDURE InsertUser
	@login nvarchar(50),
	@password nvarchar(50),
	@access int
	AS BEGIN
	begin try
		INSERT INTO [dbo].[USER] ([LOGIN], [PASSWORD], [ACCESS])
			VALUES(@login, @password, @access);
			COMMIT
			end try
begin catch
print error_message()
end catch
	END;
	GO

exec InsertUser
	@login = 'admin',
	@password = 'admin',
	@access = 1;

SELECT * FROM [dbo].[USER];
---------------------------------------DeleteUser--------------
CREATE PROCEDURE DeleteUser
@login nvarchar(50)
AS BEGIN
	begin try
		DELETE FROM [dbo].[User] WHERE [LOGIN] = @login;
		 IF (@@error <> 0)
        ROLLBACK
			COMMIT;
			end try
begin catch
print error_message()
end catch
	END; 
GO

exec DeleteUser @login = 'user';
------------------------------------------UsersSelect-----------------------
CREATE PROCEDURE UsersSelect
	AS BEGIN
	begin try
		SELECT [LOGIN]
		FROM [dbo].[USER] where [ACCESS]=2
		COMMIT
			end try
begin catch
print error_message()
end catch
	END;
	GO

	DROP PROCEDURE UsersSelect;
	exec UsersSelect;

--------------------------------------------GetTestId-----------------------
	create function IdTest(
@nameTest nvarchar(50)) 
returns int
 AS BEGIN
 Declare @testId int = (select [ID] from [dbo].[TEST] where [NAME_TEST]=@nameTest);  
  return @testId;
  END;
	GO

	select * from TEST;
	select [dbo].IdTest ('testOne');

--------------------------------------TestCreate------------------------------------
CREATE PROCEDURE TestCreate
	@nameTest nvarchar(50),
	@author nvarchar(50),
	@idType int
	AS BEGIN
	begin try
		INSERT INTO [dbo].[TEST] ( [NAME_TEST], [AUTHOR],[ID_TYPE])
			VALUES( @nameTest, @author, @idType);
			COMMIT
			end try
begin catch
print error_message()
end catch
	END;
	GO

exec TestCreate
select * from TEST;
-------------------------Есливыбранный ответ совпал с текстом ответа вернуть балл за него-----------
CREATE function Ball(
@answ nvarchar(50),
@idQ int) 
returns int
 AS BEGIN
 Declare @b int = (select [POINT] from [dbo].[POINT] where [ANSWER]=@answ and [ID_Quest] = @idQ);  
  return @b;
  END;
	GO

select * from POINT;
select * from QUESTION;
select [dbo].Ball('a12',38);

---------------------------------------------------TypeById--------------------
CREATE function GetTypeById(
@idType int) 
returns nvarchar(50)
 AS BEGIN
 Declare @t nvarchar(50) = (select [NAME_TYPE] from [dbo].[TYPE] where  [ID] = @idType);  
  return @t;
  END;
	GO

select* from [dbo].[TYPE];
select [dbo].GetTypeById(1);

--------------------------------------------View-----------------------
create view TestView as
select [NAME_TEST], [AUTHOR] from TEST;
select * from TestView;

create view UserView as
select [LOGIN], [PASSWORD],[ACCESS] from [dbo].[USER];
select * from UserView;

insert into UserView ([LOGIN], [PASSWORD],[ACCESS])
values ('vichenka', '1234', 2);
select * from [dbo].[USER];

create view PointSum as
select SUM(POINT.POINT) as totalPoint from POINT;
select * from PointSum;

-----------------------------INDEX-------------
create nonclustered index LogIndex
on [dbo].[USER]([LOGIN] asc)
GO
drop index LogIndex on[dbo].[USER];
select [LOGIN] from [dbo].[USER]

create nonclustered index AccessIndex
on [dbo].[USER]([ACCESS] asc)
GO
drop index AccessIndex on[dbo].[USER];

select [ACCESS] from [dbo].[USER];