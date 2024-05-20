CREATE DATABASE testingproject;
USE testingproject;
DROP TABLE IF EXISTS customer;
CREATE TABLE customer(
			customerid TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            `name` VARCHAR(50),
            phone BIGINT,
            email VARCHAR(50),
            address VARCHAR(50),
            note VARCHAR(50)
            );
DROP TABLE IF EXISTS car;
CREATE TABLE car(
			carid TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            maker ENUM('HONDA','TOYOTA','NISSAN'),
            model VARCHAR(50),
            `year` INT,
            color VARCHAR(50),
            note VARCHAR(50)
            );
DROP TABLE IF EXISTS car_order;
CREATE TABLE car_order(
			orderid TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            customerid TINYINT UNSIGNED,
            carid TINYINT UNSIGNED ,
            amount INT DEFAULT 1,
            saleprice INT,
            orderdate DATETIME,
            deliverydate DATETIME,
            deliveryaddress VARCHAR(50),
			`status` enum('0','1','2') DEFAULT '0',
            note VARCHAR(100),
			FOREIGN KEY(customerid) REFERENCES customer(customerid) ON DELETE CASCADE,
			FOREIGN KEY(carid) REFERENCES car(carid) ON DELETE CASCADE
            );
INSERT INTO customer( `name`,		 phone, 		email, 					address,			 note)
VALUES 				('Nguyen Van A','0123918319','a_nguyenvan@yahoo.com',N'Bên kia bờ sông','gọi trước khi giao'),
					('Van B','092222222','bebe@hotmail.com',N'Kế nhà hàng xóm','Chỉ nhắn tin'),
                    ('Thi C','0899999999','thi_c_c@yahoo.com',N'191 Bến Cát',' '),
                    ('Hoang D','0782919123','d_va_d@yahoo.com',N'Trước cây me','Đúng giờ'),
                    ('Nhat E','091283578','e_them_e@yahoo.com',N'Gần cuối đường C',' ');
INSERT INTO car(maker, model, `year`, color,		 note)
VALUES         ('HONDA','CRV','2021','Black Special','Special Edition'),
			   ('HONDA','CIVIC','2024','Red','Standard'),
               ('TOYOTA','FORTURNER','2020','White','Standard'),
               ('TOYOTA','CROSS','2021','BLUE','Special Edition'),
               ('NISSAN','Sunny ','2024','Orange','New Model');
INSERT INTO car_order( carid,customerid, amount, saleprice, orderdate, deliverydate, deliveryaddress, `status`, note)
VALUES 		( '1','1','100000','80000','2021-04-04','2021-05-03',N'Kế tiệm','1',N'Không có gì'),
			( '2','2','130000','80000','2023-06-04','2023-05-11',N'Kế tiệm','1',N'Không có gì'),
            ( '3','3','200000','80000','2021-04-12','2021-05-03',N'Kế tiệm','1',N'Không có gì'),
            ( '4','4','154000','80000','2022-11-04','2022-03-02',N'Kế tiệm','1',N'Không có gì'),
            ( '5','5','780000','80000','2020-04-11','2020-02-03',N'Kế tiệm','1',N'Không có gì')
;

/*
2. Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã
mua và sắp sếp tăng dần theo số lượng oto đã mua
*/
SELECT 
        b.`name`,
        count(c.carid) AS total_car
        
FROM car_order AS c 

LEFT JOIN customer AS b ON c.customerid = b.customerid

GROUP BY 1
ORDER BY 2 DESC;
/*
3. Viết hàm (không có parameter) trả về tên hãng sản xuất đã bán được
nhiều oto nhất trong năm nay.
*/
DROP FUNCTION IF EXISTS get_top_car_maker;
DELIMITER $$
CREATE FUNCTION get_top_car_maker()
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE top_maker VARCHAR(50);
    
    SELECT b.maker
    INTO top_maker
    FROM car_order c
    LEFT JOIN car b ON c.carid = b.carid
    GROUP BY 1
    ORDER BY COUNT(c.carid) DESC
    LIMIT 1;
    
    RETURN top_maker;
END $$
DELIMITER ;
/*
4. Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của
những năm trước. In ra số lượng bản ghi đã bị xóa.
*/
DROP PROCEDURE IF EXISTS delorder;
DELIMITER $$
CREATE PROCEDURE delorder()
BEGIN
    SELECT COUNT(*) AS "số lượng đơn hàng bị xóa" FROM car_order WHERE YEAR(orderdate) = YEAR(CURRENT_DATE - INTERVAL '1' YEAR) AND `status` = '2';
	DELETE FROM car_order WHERE YEAR(orderdate) = YEAR(CURRENT_DATE - INTERVAL '1' YEAR) AND `status` = '2' ;

END$$
DELIMITER ;
CALL delorder
;
/*
5. Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các đơn
hàng đã đặt hàng bao gồm: tên của khách hàng, mã đơn hàng, số lượng
oto và tên hãng sản xuất.
*/
DROP PROCEDURE IF EXISTS printorderinfo;
DELIMITER $$
CREATE PROCEDURE printorderinfo(IN customer_id INT)
BEGIN
    SELECT 
			c.orderid,
            b.`name`,
            d.maker,
            count(c.carid) AS total_car
            
    FROM car_order AS c
	LEFT JOIN customer AS b ON c.customerid = b.customerid
    LEFT JOIN car AS d ON c.carid = d.carid
    WHERE c.customerid = customer_id
    GROUP BY 1,2,3;
END$$
DELIMITER ;
CALL printorderinfo(1)
;
/* 
6. Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ
vào database (DeliveryDate < OrderDate + 15).
*/
DROP TRIGGER IF EXISTS check_delivery_date;
DELIMITER $$
CREATE TRIGGER check_delivery_date
BEFORE INSERT ON car_order
FOR EACH ROW
BEGIN
    IF (DATE(NEW.deliverydate) > DATE_ADD(DATE(NEW.orderdate), INTERVAL 15 DAY)) THEN
        SIGNAL SQLSTATE '12345' 
        SET MESSAGE_TEXT = 'Delivery date must be at least 15 days after order date.';
    END IF;
END$$
DELIMITER ;
