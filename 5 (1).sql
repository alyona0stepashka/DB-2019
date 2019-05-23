CREATE TABLE Table_1(
  hid hierarchyid NOT NULL,
  userId int NOT NULL,
  userName nvarchar(50) NOT NULL,
CONSTRAINT PK_Table_1 PRIMARY KEY CLUSTERED 
(
  [hid] ASC
))



insert into Table_1 values(hierarchyid::GetRoot(), 1, '������');--������� ������ ��������(GetRoot � ������ ������� �����)
----��� ����������� �����, ������� ������ ���������� ������������� ����� ��������.
select * from Table_1

declare @Id hierarchyid --���������� ��������� ����
select @Id = MAX(hid) from Table_1 where hid.GetAncestor(1) = hierarchyid::GetRoot() ;--�������� ��� ������, ������� (������) ������� �������� ������;
--GetAncestor � ������ hierarchyid ������, ����� ������� ������� ������, �������� 1 ������� ����������������� ������; 

insert into Table_1 values(hierarchyid::GetRoot().GetDescendant(@id, null), 2, 'Savenko');

declare @Id hierarchyid
select @Id = MAX(hid) from Table_1 where hid.GetAncestor(1) = hierarchyid::GetRoot() ;
insert into Table_1 values(hierarchyid::GetRoot().GetDescendant(@id, null), 3, '�������');

--GetDescendant � ������ hierarchyid �������, ��������� ��� ���������, � ������� ������� ����� ��������� ���, ������ ������ ������� ���������� �������� �� ������;
--�� ��������� ��� ���������, � ������� ������� ����� �������, ����� ������ ������ ������� ��������� ����� ���� (����� �� ���������� ����� ���� ����� null).
declare @phId hierarchyid
select @phId = (SELECT hid FROM Table_1 WHERE userId = 2);

declare @Id hierarchyid
select @Id = MAX(hid) from Table_1 where hid.GetAncestor(1) = @phId

insert into Table_1 values( @phId.GetDescendant(@id, null), 7, '�������');

select hid.ToString(), hid.GetLevel(), * from Table_1;
--GetLevel � ������ ������� hierarchyid;
------------------------
--2.	������� ���������, ������� ��������� ��� ����������� ���� � ��������� ������ �������� (�������� � �������� ����).
drop procedure SelectPodchRoot

GO  
CREATE PROCEDURE SelectPodchRoot(@level int)    
AS   
BEGIN  
   select hid.ToString(), * from Table_1 where hid.GetLevel() = @level;
END;
  
GO  
exec SelectPodchRoot 1;
---------------------------------

CREATE TABLE Table_1(
  hid hierarchyid NOT NULL,
  userId int NOT NULL,
  userName nvarchar(50) NOT NULL,
CONSTRAINT PK_Table_1 PRIMARY KEY CLUSTERED 
(
  [hid] ASC
))
--3.	������� ���������, ������� ������� ����������� ���� (�������� � �������� ����).
drop proc AddDocherRoot
GO  
CREATE PROCEDURE AddDocherRoot(@UserId int,@UserName nvarchar(50))  -- ��� ���������� ��������� ����
AS   
BEGIN  
declare @Id hierarchyid
declare @phId hierarchyid
select @phId = (SELECT hid FROM Table_1 WHERE UserId = @UserId);

select @Id = MAX(hid) from Table_1 where hid.GetAncestor(1) = @phId

insert into Table_1 values( @phId.GetDescendant(@id, null),@UserId,@UserName);
END;  

GO  
exec AddDocherRoot 1, 'Mozol';
select * from Table_1;
----------
--4.	������� ���������, ������� ���������� ��� ����������� ����� (������ �������� � �������� �������� ������������� ����, ������ �������� � �������� ����, � ������� ���������� �����������).
go
drop proc MoveRoot
CREATE PROCEDURE MoveRoot(@old_uzel int, @new_uzel int )
AS  
BEGIN  
DECLARE @nold hierarchyid, @nnew hierarchyid  
SELECT @nold = hid FROM Table_1 WHERE UserId = @old_uzel ;  -- �������� ��� ����, ������� ����� ������������� �� ����� ��� ���������
  
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
BEGIN TRANSACTION  
SELECT @nnew = hid FROM Table_1 WHERE UserId = @new_uzel ;  -- �������� ��� ���� ������ ��������
  
SELECT @nnew = @nnew.GetDescendant(max(hid), NULL)   
FROM Table_1 WHERE hid.GetAncestor(1)=@nnew ;  -- �������� ��� ���� ������������� ������� ������ ��������
 ---- ������������� ������ ��� ���� ������ �� ����� ��� ���������
UPDATE Table_1   
SET hid = hid.GetReparentedValue(@nold, @nnew)  
--oldRoot
--������ hierarchyid �� ���� ����, �������������� ������� ��������, ������� ��������� ��������.
--newRoot
--������ hierarchyid , �������������� ����, ������� ������� oldRoot ������, ����� ����������� ���� �������� ����.
WHERE hid.IsDescendantOf(@nold) = 1 ;  
  --IsDescendantOf(<parent>) � ���������, �������� �� ���� ��������, ����������� ����� �������� ��������.
 commit;
  END ;  
GO  
----
exec MoveRoot 1,2
select hid.ToString(), hid.GetLevel(), * from Table_1