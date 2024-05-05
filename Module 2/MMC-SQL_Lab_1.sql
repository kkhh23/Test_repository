create DATABASE Testing_System_Db
;
use Testing_System_Db;
create table department(
DepartmentID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
DepartmentName VARCHAR(50)
);
create table `Position`(
PositionID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
PositionName VARCHAR(50)
);
create table account(
    AccountID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Email VARCHAR(50),
    Username VARCHAR(50),
    FullName VARCHAR(50),
    DepartmentID INT,
    PositionID INT,
    CreateDate DATE
);
create table `Group`(
    GroupID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
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
    TypeID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    TypeName VARCHAR(50)
);
create table CategoryQuestion(
    CategoryID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    CategoryName VARCHAR(50)
);
create table Question(
    QuestionID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Content VARCHAR(50),
    CategoryID INT,
    TypeID INT,
    CreatorID INT,
    CreateDate DATE
);
create table answer(
    AnswerID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Content VARCHAR(50),
    QuestionID INT,
    isCorrect BOOLEAN
);
create table exam(
    ExamID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
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