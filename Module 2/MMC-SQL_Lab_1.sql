use Testing_System_Db;
create table department(
DepartmentID INT,
DepartmentName VARCHAR(50));
create table `Position`(
PositionID INT,
PositionName VARCHAR(50)
);
create table account(
    AccountID INT,
    Email VARCHAR(50),
    Username VARCHAR(50),
    FullName VARCHAR(50),
    DepartmentID INT,
    PositionID INT,
    CreateDate DATE
);
create table `Group`(
    GroupID INT,
    GroupName VARCHAR(50),
    CreatorID INT,
    CreateDate DATE
);
create table GroupAccount(
    GroupID INT,
    AccountID INT,
    JoinDate DATE
);
create table TypeQuestion(
    TypeID INT,
    TypeName VARCHAR(50)
);
create table CategoryQuestion(
    CategoryID INT,
    CategoryName VARCHAR(50)
);
create table Question(
    QuestionID INT,
    Content VARCHAR(50),
    CategoryID INT,
    TypeID INT,
    CreatorID INT,
    CreateDate DATE
);
create table answer(
    AnswerID INT,
    Content VARCHAR(50),
    QuestionID INT,
    isCorrect BOOLEAN
);
create table exam(
    ExamID INT,
    Code VARCHAR(50),
    Title VARCHAR(50),
    CategoryID INT,
    Duration TIMESTAMP,
    CreatorID INT,
    CreateDate DATE
);
create table ExamQuestion(
    ExamID INT,
    QuestionID INT
)