USE Trucking
go

SET IDENTITY_INSERT Trucking.dbo.Employee ON

create table Employee(
hid hierarchyid not null,
userId int unique identity(1,1),
Emp_level as hid.GetLevel() persisted,
userName nvarchar(50) not null,
constraint pk_Empl primary key clustered([hid] asc));


insert into Employee(hid, userId,userName) values (hierarchyid::GetRoot(), 1, 'Savcheko');

--добавление к корневой записи потомков
declare @id hierarchyid
select @id = max(hid) from Employee
where hid.GetAncestor(1) = hierarchyid::GetRoot()

insert into Employee(hid, userId,userName) values (hierarchyid::GetRoot().GetDescendant(@id, null), 2, 'Petrova');

select @id = max(hid) from Employee
where hid.GetAncestor(1) = hierarchyid::GetRoot()

insert into Employee(hid, userId,userName) values (hierarchyid::GetRoot().GetDescendant(@id, null), 3, 'Sidorov');

select @id = max(hid) from Employee
where hid.GetAncestor(1) = hierarchyid::GetRoot()

insert into Employee(hid, userId,userName) values (hierarchyid::GetRoot().GetDescendant(@id, null), 4, 'Vasechkina');

--next level
declare @phId hierarchyid
select  @phId = (select hid from Employee where userId = 2);

select @id =max(hid) from Employee where hid.GetAncestor(1) = @phId
insert into Employee(hid, userId,userName) values (@phId.GetDescendant(@id, null), 7, 'Smirnova');

select @phId = (Select hid from Employee where userId = 4);
select @id =max(hid) from Employee where hid.GetAncestor(1) = @phId
insert into Employee(hid, userId,userName) values(@phId.GetDescendant(@id, null), 5, 'Kruglova');
select @id =max(hid) from Employee where hid.GetAncestor(1) = @phId
insert into Employee(hid, userId,userName) values(@phId.GetDescendant(@id, null), 6, 'Kvadratov');

select @phId = (Select hid from Employee where userId = 7);
select @id =max(hid) from Employee where hid.GetAncestor(1) = @phId
insert into Employee(hid, userId,userName) values(@phId.GetDescendant(@id, null), 8, 'Pupkin');

-------------------------------------------------
select hid.ToString() as hidString, hid.GetLevel() as Level,
userId, userName from Employee;
go

--task 2
create procedure ChildNote
@Id int
as 
declare @CurrentEmployee hierarchyid
select  @CurrentEmployee = (select hid from Employee where userId = @Id);
select hid.ToString() as hid, * from Employee where
hid.GetAncestor(1) = @CurrentEmployee;
go

execute ChildNote 1

--task 3
--https://docs.microsoft.com/ru-ru/sql/relational-databases/tables/lesson-2-creating-and-managing-data-in-a-hierarchical-table?view=sql-server-2017#create-a-procedure-for-entering-new-nodes
--по заданию должен быть один параметр (параметр узла)
CREATE PROC AddEmp(@mgrid int, @empid int, @e_name varchar(20))   
AS   
BEGIN  
   DECLARE @mOrgNode hierarchyid, @lc hierarchyid  
   SELECT @mOrgNode = hid   
   FROM Employee 
   WHERE userId = @mgrid  
   SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
   BEGIN TRANSACTION  
      SELECT @lc = max(hid)   
      FROM Employee 
      WHERE hid.GetAncestor(1) = @mOrgNode ;  

      INSERT Employee (hid, userId, userName)  
      VALUES(@mOrgNode.GetDescendant(@lc, NULL), @empid, @e_name)  
   COMMIT  
END;

execute AddEmp 1, 9, 'Somov';

--task 4	
--https://docs.microsoft.com/ru-ru/sql/relational-databases/hierarchical-data-sql-server?view=sql-server-2017
CREATE PROCEDURE MoveUnderTree(@oldMgr nvarchar(50), @newMgr nvarchar(50))
as
BEGIN
DECLARE @nold hierarchyid, @nnew hierarchyid  
SELECT @nold = hid FROM Employee WHERE userName = @oldMgr ;  
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
BEGIN TRANSACTION  
SELECT @nnew = hid FROM Employee WHERE userName = @newMgr ;  
  
SELECT @nnew = @nnew.GetDescendant(max(hid), NULL)   
FROM Employee WHERE hid.GetAncestor(1)=@nnew ;  
  
UPDATE Employee  
SET hid = hid.GetReparentedValue(@nold, @nnew)  
WHERE hid.IsDescendantOf(@nold) = 1;  
  
COMMIT TRANSACTION  
END ;  
GO 

execute MoveUnderTree 'Petrova', 'Kvadratov'
--delete from Employee