use sakila;

-- 1. Write a query to find what is the total business done by each store.

SELECT SUM(store_id) AS total_business
FROM inventory 
group by store_id;

-- 2. Convert the previous query into a stored procedure. -- 3. 

DELIMITER //
CREATE PROCEDURE CalculateTotalBusinessByStore()
BEGIN
    SELECT store_id, SUM(store_id) AS total_business
    FROM inventory
    GROUP BY store_id;
END //
DELIMITER ;

CALL CalculateTotalBusinessByStore();

-- 3.  stored procedure that takes the input for store_id and displays the total sales for that store.

DELIMITER //
CREATE PROCEDURE CalculateTotalSalesByStore()
BEGIN
    SELECT store_id, SUM(store_id) AS total_sales
    FROM inventory
    GROUP BY store_id;
END //
DELIMITER ;

CALL CalculateTotalSalesByStore();

-- 4. Update the previous query. 
-- Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 
-- Call the stored procedure and print the results.

DELIMITER //

CREATE PROCEDURE CalculateTotalBusinessByStoreNew(IN store_id_param INT, OUT total_sales_value FLOAT)
BEGIN
    SELECT SUM(amount) INTO total_sales_value
    FROM payment
    WHERE store_id = store_id_param;
END //

DELIMITER ;

-- Declare variables

SET @total_sales := 0.0;

-- Call the stored procedure
CALL CalculateTotalBusinessByStoreNew(YourDesiredStoreID, total_sales);

-- Print the result
SELECT @total_sales AS total_sales;

-- 5

DELIMITER //

CREATE PROCEDURE CalculateTotalBusinessAndFlagByStore(IN store_id_param INT, OUT total_sales FLOAT, OUT flag VARCHAR(10))
BEGIN
    -- Declare variables
    DECLARE total_sales_local FLOAT;
    DECLARE flag_local VARCHAR(10);

    -- Your logic to calculate total sales
    SELECT SUM(amount) INTO total_sales_local
    FROM payment
    WHERE store_id = store_id_param;

    -- Set the OUT parameters
    SET @total_sales := 0.0;

    -- Determine the flag based on the total sales value
    IF total_sales_local > 30000 THEN
        SET flag_local = 'green_flag';
    ELSE
        SET flag_local = 'red_flag';
    END IF;

    SET flag = flag_local;
END //

DELIMITER ;

-- Declare variables
SET @total_sales := 0.0;
SET @flag := '';

-- Call the stored procedure and store the results in variables
CALL CalculateTotalBusinessAndFlagByStore(YourDesiredStoreID, @total_sales, @flag);

-- Print the results
SELECT @total_sales AS total_sales, @flag AS flag;



