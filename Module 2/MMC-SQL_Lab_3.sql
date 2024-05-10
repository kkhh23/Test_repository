-- Q2
select * from testing_system_db.department;
-- Q3
select * from testing_system_db.department where departmentname='Sale'
;
-- Q4
select * from testing_system_db.account where length(fullname) = (select max(length(fullname)) from testing_system_db.account) 
;
-- Q5 
select * from testing_system_db.account where length(fullname) = (select max(length(fullname)) from testing_system_db.account) and accountid = 3
;
-- Q6
select * from testing_system_db.group where createdate < cast('2019-12-20 00:00:00' as datetime)
;
-- Q7
select questionid,count(content) from testing_system_db.answer group by 1 having count(content) >= 4;
-- Q8
select * from testing_system_db.exam where duration >= 60 and createdate < cast('2019-12-20 00:00:00' as datetime);
-- Q9
select * from testing_system_db.`group` order by createdate desc limit 5
;
-- Q10
select count(*) from testing_system_db.account where departmentid = 2
;
-- Q11
select * from testing_system_db.account where fullname like 'D%o'
;
-- Q12
Delete from exam 
where createdate < cast('2019-12-20 00:00:00' as datetime);
-- Q13
delete from question 
where content like 'Câu hỏi___%'
;
-- Q14
UPDATE account
SET fullname = 'Lô Văn Đề', email = 'lo.vande@mmc.edu.vn'
WHERE accountid = 5
;
-- Q15
UPDATE groupaccount
SET groupid = 4
WHERE accountid = 5;
