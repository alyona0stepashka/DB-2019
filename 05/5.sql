CREATE TABLE TableLab5(
  hid hierarchyid NOT NULL,
  userId int NOT NULL,
  userName nvarchar(50) NOT NULL,
CONSTRAINT PK_TableLab5 PRIMARY KEY CLUSTERED 
(
  [hid] ASC
));



insert into TableLab5 values(hierarchyid::GetRoot(), 1, 'Pakholko'); 
select * from TableLab5;

declare @Id hierarchyid  
select @Id = MAX(hid) from TableLab5 where hid.GetAncestor(1) = hierarchyid::GetRoot() ; 
insert into TableLab5 values(hierarchyid::GetRoot().GetDescendant(@id, null), 2, 'Savenko');

declare @Id hierarchyid
select @Id = MAX(hid) from TableLab5 where hid.GetAncestor(1) = hierarchyid::GetRoot() ;
insert into TableLab5 values(hierarchyid::GetRoot().GetDescendant(@id, null), 3, 'Shaveiko');
 
declare @phId hierarchyid
select @phId = (SELECT hid FROM TableLab5 WHERE userId = 2);
declare @Id hierarchyid
select @Id = MAX(hid) from TableLab5 where hid.GetAncestor(1) = @phId;
insert into TableLab5 values( @phId.GetDescendant(@id, null), 7, 'Shaveiko');

select hid.ToString(), hid.GetLevel(), * from TableLab5; 

--2------------------------------------------
drop procedure SelectPodchRoot

GO  
CREATE PROCEDURE SelectPodchRoot(@level int)    
AS   
BEGIN  
   select hid.ToString(), * from TableLab5 where hid.GetLevel() = @level;
END;
  
GO  
exec SelectPodchRoot 1;
---------------------------------

CREATE TABLE TableLab5(
  hid hierarchyid NOT NULL,
  userId int NOT NULL,
  userName nvarchar(50) NOT NULL,
CONSTRAINT PK_TableLab5 PRIMARY KEY CLUSTERED 
(
  [hid] ASC
))
--3---------------------------------------------
drop proc AddDocherRoot
GO  
CREATE PROCEDURE AddDocherRoot(@UserId int,@UserName nvarchar(50))   
AS   
BEGIN  
declare @Id hierarchyid
declare @phId hierarchyid
select @phId = (SELECT hid FROM TableLab5 WHERE UserId = @UserId);

select @Id = MAX(hid) from TableLab5 where hid.GetAncestor(1) = @phId

insert into TableLab5 values( @phId.GetDescendant(@id, null),@UserId,@UserName);
END;  

GO  
exec AddDocherRoot 1, 'Mozol';
select * from TableLab5; 
go
drop proc MoveRoot
CREATE PROCEDURE MoveRoot(@old_uzel int, @new_uzel int )
AS  
BEGIN  
DECLARE @nold hierarchyid, @nnew hierarchyid  
SELECT @nold = hid FROM TableLab5 WHERE UserId = @old_uzel ;  
  
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
BEGIN TRANSACTION  
SELECT @nnew = hid FROM TableLab5 WHERE UserId = @new_uzel ; 
  
SELECT @nnew = @nnew.GetDescendant(max(hid), NULL)   
FROM TableLab5 WHERE hid.GetAncestor(1)=@nnew ; 
UPDATE TableLab5   
SET hid = hid.GetReparentedValue(@nold, @nnew)   
WHERE hid.IsDescendantOf(@nold) = 1 ;   
 commit;
  END ;  
GO  
----
exec MoveRoot 1,2
select hid.ToString(), hid.GetLevel(), * from TableLab5