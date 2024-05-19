USE testingsystem;
-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
DROP VIEW IF EXISTS view_sale_account;
CREATE VIEW view_sale_account AS 
select 
		a.*,
        b.DepartmentName
from testingsystem.`account` a 
left join testingsystem.department b on a.DepartmentID = b.DepartmentID
where b.DepartmentName = 'Sale';
-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
DROP VIEW IF EXISTS view_account_w_max_group;
CREATE VIEW view_account_w_max_group AS 
SELECT a.* FROM `account` as a 
INNER JOIN 
(SELECT 
		a.accountid,
        count(a.groupid) AS count_group
FROM groupaccount AS a 

GROUP BY 1 
HAVING count(groupid) = (
SELECT max(count_group)
FROM 
(SELECT 
		accountid,
        count(groupid) AS count_group
FROM groupaccount 
GROUP BY 1) AS a 
)
) AS b on a.accountid = b.accountid
;
-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi
DROP VIEW IF EXISTS view_long_content;
CREATE VIEW view_long_content AS 
SELECT 
		Content,LENGTH(Content) AS len_of_content
FROM question
WHERE LENGTH(Content) > 300;
DELETE FROM question WHERE LENGTH(Content) > 300
;
-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
DROP VIEW IF EXISTS view_department_more_employ;
CREATE VIEW view_department_more_employ AS 
SELECT
		d.DepartmentName,
        b.positionname,
        count(accountid) as cnt_employees
FROM testingsystem.`account` a 

LEFT JOIN testingsystem.department d on a.DepartmentID = d.DepartmentID
LEFT JOIN testingsystem.position b on a.positionid = b.positionid
GROUP BY 1,2 
HAVING count(accountid) = (
SELECT MAX(cnt_employees) AS max_employess
FROM 
(SELECT
		d.DepartmentName,
        b.positionname,
        count(accountid) as cnt_employees
FROM testingsystem.`account` a 

LEFT JOIN testingsystem.department d on a.DepartmentID = d.DepartmentID
LEFT JOIN testingsystem.position b on a.positionid = b.positionid
GROUP BY 1,2) AS a
)
;
-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
DROP VIEW IF EXISTS view_nguyen_question;
CREATE VIEW view_nguyen_question AS 
SELECT q.*,a.fullname

FROM question AS q 

LEFT JOIN `account` a ON q.creatorid = a.accountid
WHERE (a.fullname LIKE 'Nguyen%' OR a.fullname LIKE 'Nguyễn%')
;
SELECT * FROM view_nguyen_question






