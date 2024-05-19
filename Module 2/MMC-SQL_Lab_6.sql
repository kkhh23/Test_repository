USE testingsystem;
-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó
DROP PROCEDURE IF EXISTS print_account;
DELIMITER $$
CREATE PROCEDURE print_account(IN department_name VARCHAR(100))
BEGIN
    SELECT a.*
    FROM `account` a 
    LEFT JOIN department d on d.departmentid = a.departmentid
    WHERE d.departmentname = department_name;
END $$
DELIMITER ;
-- Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS print_num_of_account;
DELIMITER $$
CREATE PROCEDURE print_num_of_account()
BEGIN
    SELECT d.departmentname, COUNT(a.AccountID) AS total_account 
    FROM `account` a 
    LEFT JOIN department d on d.departmentid = a.departmentid
    GROUP BY departmentname;
END $$
DELIMITER ;
CALL print_num_of_account
;
-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
DROP PROCEDURE IF EXISTS CountQuestionsByTypeAndMonth;
DELIMITER $$
CREATE PROCEDURE CountQuestionsByTypeAndMonth(IN current_month INT)
BEGIN
    DECLARE current_month VARCHAR(2);

    SELECT typeid, COUNT(*) AS question_count
    FROM question
    WHERE MONTH(CreateDate) = current_month
    GROUP BY typeid;
END $$
DELIMITER ;
CALL CountQuestionsByTypeAndMonth(10)
;
-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
DROP PROCEDURE IF EXISTS CheckMostQuestion;
DELIMITER $$
CREATE PROCEDURE CheckMostQuestion(OUT p_questionid INT,OUT p_typename VARCHAR(50),OUT p_cnt_question INT)
BEGIN
    SELECT a.questionid, tq.TypeName, COUNT(tq.typeid) AS cnt_question INTO  p_questionid, p_typename,p_cnt_question
    FROM testingsystem.question AS a 
    LEFT JOIN testingsystem.ExamQuestion eq ON a.questionid = eq.questionid
    LEFT JOIN testingsystem.typequestion tq ON a.typeid = tq.typeid
    CROSS JOIN 
    (
        SELECT MAX(cnt_question) AS max_question
        FROM
        (
            SELECT questionid, COUNT(examid) AS cnt_question FROM testingsystem.examquestion GROUP BY questionid
        ) a 
    ) AS b
    GROUP BY 1,2,b.max_question
    HAVING COUNT(tq.typeid) = b.max_question;
END $$
DELIMITER ;
-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
CALL CheckMostQuestion(@questionid,@TypeName,@cnt_question);
SELECT @TypeName
;
-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
-- chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của
-- người dùng nhập vào
DROP PROCEDURE IF EXISTS print_account_by_condition;
DELIMITER $$
CREATE PROCEDURE print_account_by_condition(IN department_name VARCHAR(50),IN user_name VARCHAR(50))
BEGIN
    SELECT a.*
    FROM `account` a 
    LEFT JOIN department d on d.departmentid = a.departmentid
    WHERE (d.departmentname = department_name OR a.username = user_name);
END $$
DELIMITER ;
CALL print_account_by_condition('Sale','')
;
/*
Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và
trong store sẽ tự động gán:
username sẽ giống email nhưng bỏ phần @..mail đi
positionID: sẽ có default là developer
departmentID: sẽ được cho vào 1 phòng chờ
*/
insert into department (DepartmentID,DepartmentName)
values (11,N'Phòng Chờ')
;
DROP PROCEDURE IF EXISTS createuser;
DELIMITER $$
CREATE PROCEDURE createuser(IN p_fullName VARCHAR(50),IN p_email VARCHAR(50))
BEGIN
	DECLARE v_username VARCHAR(50);
    DECLARE v_positionID INT;
    DECLARE v_departmentID INT;
    SET v_username = SUBSTRING_INDEX(p_email, '@', 1);
    INSERT INTO `account` (AccountID, email, username,FullName,DepartmentID, positionID, CreateDate)
    VALUES (null,p_email, v_username , p_fullName, 11,1,current_date);
END$$
DELIMITER ;
call createuser('test_user','test_user_email@gmail.com')
;
-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
DROP PROCEDURE IF EXISTS checkcontent;
DELIMITER $$
CREATE PROCEDURE checkcontent(IN in_questionType ENUM('Essay', 'Multiple-Choice'))
BEGIN
	select 
		a.QuestionID,
        a.content,
        a.CreatorID,
        b.typename as question_type_name
        
	from testingsystem.question a 

	left join testingsystem.typequestion b on a.TypeID = b.TypeID
    WHERE b.typename = in_questionType
    ;
END$$
DELIMITER ;
CALL checkcontent('Essay')
;
-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
DROP PROCEDURE IF EXISTS delexam;
DELIMITER $$
CREATE PROCEDURE delexam(IN in_examid INT)
BEGIN
	DELETE FROM exam WHERE examid = in_examid;
END$$
DELIMITER ;
/*
Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử dụng
store ở câu 9 để xóa)
Sau đó in số lượng record đã remove từ các table liên quan trong khi removing
*/
-- Câu này nâng cao quá nợ câu này nha Đăng    
/*
Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng nhập
vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng ban
default là phòng ban chờ việc
*/
DROP PROCEDURE IF EXISTS updatedep;
DELIMITER $$
CREATE PROCEDURE updatedep(IN in_dep INT)
BEGIN
	SELECT *,'Updated account info' as actions 
    FROM `account` 
    WHERE departmentid = in_dep;
	UPDATE `account`
	SET departmentid = 11
	WHERE departmentid = in_dep;
END $$
DELIMITER ;
CALL updatedep(4)
;
-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
DROP PROCEDURE IF EXISTS checkexam;
DELIMITER $$
CREATE PROCEDURE checkexam()
BEGIN
	SELECT 
		MONTH(createdate),
		count(`code`) AS total_question 
	FROM exam 
	WHERE YEAR(createdate) = 2024 
	GROUP BY 1;
END $$
DELIMITER ;
CALL checkexam
;
/*
Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng
gần đây nhất
(Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng")
*/
DROP TABLE IF EXISTS `year_month`;
CREATE TABLE `year_month`(year_num INT ,month_num INT);
INSERT INTO `year_month`(year_num,month_num) 
VALUES
						(2020,1),
                        (2020,2),
                        (2020,3),
                        (2020,4),
                        (2020,5),
                        (2020,6),
                        (2020,7),
                        (2020,8),
                        (2020,9),
                        (2020,10),
                        (2020,11),
                        (2020,12);
DROP PROCEDURE IF EXISTS checkexam_l6m;
DELIMITER $$
CREATE PROCEDURE checkexam_l6m()
BEGIN
	SELECT 
			t1.month_num,
			CASE 
			WHEN SUM(t2.total_question) > 0 THEN SUM(t2.total_question)
			ELSE 'No question in 6months' END AS total_question_l6m

	FROM `year_month` t1 

	LEFT JOIN 
	(SELECT 
			MONTH(createdate) AS month_num,YEAR(createdate) AS year_num,
			count(`code`) AS total_question 
		FROM exam 
		WHERE YEAR(createdate) = 2020
		GROUP BY 1,2) t2 ON t1.year_num = t2.year_num AND t2.month_num between t1.month_num - 6 and t1.month_num

	GROUP BY 1; 
END $$
DELIMITER ;
CALL checkexam_l6m


