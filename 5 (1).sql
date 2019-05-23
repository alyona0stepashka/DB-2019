CREATE TABLE Table_1(
  hid hierarchyid NOT NULL,
  userId int NOT NULL,
  userName nvarchar(50) NOT NULL,
CONSTRAINT PK_Table_1 PRIMARY KEY CLUSTERED 
(
  [hid] ASC
))



insert into Table_1 values(hierarchyid::GetRoot(), 1, 'Иванов');--создали корень иерархии(GetRoot — выдает уровень корня)
----это статический метод, который всегда возвращает идентификатор корня иерархии.
select * from Table_1

declare @Id hierarchyid --добавление дочернего узла
select @Id = MAX(hid) from Table_1 where hid.GetAncestor(1) = hierarchyid::GetRoot() ;--выбирает все записи, предком (прямым) которых является корень;
--GetAncestor — выдает hierarchyid предка, можно указать уровень предка, например 1 выберет непосредственного предка; 

insert into Table_1 values(hierarchyid::GetRoot().GetDescendant(@id, null), 2, 'Savenko');

declare @Id hierarchyid
select @Id = MAX(hid) from Table_1 where hid.GetAncestor(1) = hierarchyid::GetRoot() ;
insert into Table_1 values(hierarchyid::GetRoot().GetDescendant(@id, null), 3, 'Сидоров');

--GetDescendant — выдает hierarchyid потомка, принимает два параметра, с помощью которых можно управлять тем, какого именно потомка необходимо получить на выходе;
--Он принимает два параметра, с помощью которых можно указать, между какими узлами следует поместить новый узел (любой из параметров может быть равен null).
declare @phId hierarchyid
select @phId = (SELECT hid FROM Table_1 WHERE userId = 2);

declare @Id hierarchyid
select @Id = MAX(hid) from Table_1 where hid.GetAncestor(1) = @phId

insert into Table_1 values( @phId.GetDescendant(@id, null), 7, 'Смирнов');

select hid.ToString(), hid.GetLevel(), * from Table_1;
--GetLevel — выдает уровень hierarchyid;
------------------------
--2.	Создать процедуру, которая отобразит все подчиненные узлы с указанием уровня иерархии (параметр – значение узла).
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
--3.	Создать процедуру, которая добавит подчиненный узел (параметр – значение узла).
drop proc AddDocherRoot
GO  
CREATE PROCEDURE AddDocherRoot(@UserId int,@UserName nvarchar(50))  -- для добавления дочернего узла
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
--4.	Создать процедуру, которая переместит всю подчиненную ветку (первый параметр – значение верхнего перемещаемого узла, второй параметр – значение узла, в который происходит перемещение).
go
drop proc MoveRoot
CREATE PROCEDURE MoveRoot(@old_uzel int, @new_uzel int )
AS  
BEGIN  
DECLARE @nold hierarchyid, @nnew hierarchyid  
SELECT @nold = hid FROM Table_1 WHERE UserId = @old_uzel ;  -- Получаем код узла, который хотим переподчинить со всеми его потомками
  
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
BEGIN TRANSACTION  
SELECT @nnew = hid FROM Table_1 WHERE UserId = @new_uzel ;  -- Получаем код узла нового родителя
  
SELECT @nnew = @nnew.GetDescendant(max(hid), NULL)   
FROM Table_1 WHERE hid.GetAncestor(1)=@nnew ;  -- Получаем код узла максимального потомка нового родителя
 ---- Переподчиняем нужный нам узел вместе со всеми его потомками
UPDATE Table_1   
SET hid = hid.GetReparentedValue(@nold, @nnew)  
--oldRoot
--Объект hierarchyid то есть узел, представляющий уровень иерархии, который требуется изменить.
--newRoot
--Объект hierarchyid , представляющий узел, который заменит oldRoot раздел, чтобы переместить узел текущего узла.
WHERE hid.IsDescendantOf(@nold) = 1 ;  
  --IsDescendantOf(<parent>) — проверяет, является ли узел потомком, переданного через параметр родителя.
 commit;
  END ;  
GO  
----
exec MoveRoot 1,2
select hid.ToString(), hid.GetLevel(), * from Table_1