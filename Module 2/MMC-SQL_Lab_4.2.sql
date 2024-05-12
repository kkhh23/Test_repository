-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
select * from testingsystem.`account`;
-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
select * from testingsystem.`account` where createdate > cast('2010-12-20 00:00:00' as datetime);
-- Question 3: Viết lệnh để lấy ra tất cả các developer
select 
		a.*,
        b.positionname
from testingsystem.`account` a 
left join testingsystem.position b on a.positionid = b.positionid
where b.positionname = 'Dev';
-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
select 
        b.positionname,
        count(a.fullname) as total_employees
        
from testingsystem.`account` a 
left join testingsystem.position b on a.positionid = b.positionid
group by 1 
having (count(a.fullname) > 3)
;
-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều 
select 
		a.questionid,b.max_question,count(a.questionid) as cnt_question
from testingsystem.question a 
cross join 
(select max(cnt_question) as max_question
from
(select questionid,count(examid) as cnt_question from testingsystem.examquestion group by 1) a 
)  as b
left join testingsystem.ExamQuestion eq on a.questionid = eq.questionid
group by 1,b.max_question
having (count(a.questionid) = b.max_question);
-- Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
select  
		a.categoryid,b.CategoryName,count(a.questionid) as cnt_question
from testingsystem.question as a 
left join testingsystem.ExamQuestion eq on a.questionid = eq.questionid
left join testingsystem.categoryquestion as b on a.categoryid = b.categoryid
group by 1,2
;
-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
select  
		a.questionid,a.content,count(a.questionid) as cnt_question
from testingsystem.question as a 
left join testingsystem.ExamQuestion eq on a.questionid = eq.questionid
group by 1,2;
-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
select  
		a.questionid,tq.TypeName,count(tq.typeid) as cnt_answer
from testingsystem.question as a 
left join testingsystem.ExamQuestion eq on a.questionid = eq.questionid
left join testingsystem.typequestion tq on a.typeid = tq.typeid
cross join 
(select max(cnt_question) as max_question
from
(select questionid,count(examid) as cnt_question from testingsystem.examquestion group by 1) a 
)  as b
group by 1,2,b.max_question
having (count(a.questionid) = b.max_question);
-- Question 9: Thống kê số lượng account trong mỗi group
select groupid,count(accountid) as cnt_account from testingsystem.groupaccount group by 1;
-- Question 10: Tìm chức vụ có ít người nhất
select 
		a.*
from (select 
        b.positionname,
        count(accountid) as cnt_employees
from testingsystem.`account` a 
left join testingsystem.position b on a.positionid = b.positionid
group by 1 ) as a 

cross join 
(select min(cnt_employees) as min_employees from
(select 
        b.positionname,
        count(accountid) as cnt_employees
from testingsystem.`account` a 
left join testingsystem.position b on a.positionid = b.positionid
group by 1 ) min_check
) as b 
where a.cnt_employees = b.min_employees
;
-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
select 
		d.DepartmentName,
        b.positionname,
        count(accountid) as cnt_employees
from testingsystem.`account` a 

left join testingsystem.department d on a.DepartmentID = d.DepartmentID

left join testingsystem.position b on a.positionid = b.positionid
group by 1,2 ;
-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …
select 
		a.QuestionID,
        a.content,
        a.CreatorID,
        b.typename as question_type_name,
        ans.Content as answer_content
        
from testingsystem.question a 

left join testingsystem.typequestion b on a.TypeID = b.TypeID

left join testingsystem.answer ans on ans.questionid = a.questionid;
-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
select 
        b.typename as question_type_name,
        count(a.questionid) as cnt_question
        
from testingsystem.question a 

left join testingsystem.typequestion b on a.TypeID = b.TypeID
group by 1 ;
-- Question 14: Lấy ra group không có account nào
select 
		a.groupname,
        count(b.accountid) as cnt_employees
from testingsystem.`group` a 

left join testingsystem.`groupaccount` b on a.GroupID = b.GroupID

group by 1 
having count(b.accountid) = 0
;
-- Question 16: Lấy ra question không có answer nào
select 
		a.QuestionID,
        count(ans.Content) as cnt_answer
        
from testingsystem.question a 

left join testingsystem.answer ans on ans.questionid = a.questionid
group by 1 
having count(ans.Content) = 0
;
/*
Exercise 2: Union
Question 17:
a) Lấy các account thuộc nhóm thứ 1
b) Lấy các account thuộc nhóm thứ 2
c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
*/
select * from testingsystem.account 
where departmentid = 1
UNION 
select * from testingsystem.account 
where departmentid = 2 
;
/*
Question 18:
a) Lấy các group có lớn hơn 5 thành viên
b) Lấy các group có nhỏ hơn 7 thành viên
c) Ghép 2 kết quả từ câu a) và câu b)
*/
select 
		a.groupname,
        count(b.accountid) as cnt_employees
from testingsystem.`group` a 

left join testingsystem.`groupaccount` b on a.GroupID = b.GroupID

group by 1 
having count(b.accountid) > 5
UNION 
select 
		a.groupname,
        count(b.accountid) as cnt_employees
from testingsystem.`group` a 

left join testingsystem.`groupaccount` b on a.GroupID = b.GroupID

group by 1 
having count(b.accountid) < 7

