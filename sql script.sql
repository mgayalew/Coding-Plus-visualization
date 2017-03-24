
--SQL Script to create table, extract data  and more 
-------------------------------------------------------------------
-- a. Create an sql script for creating a table with correct types
-------------------------------------------------------------------
	--Create a table with its name as Ganesh
     	CREATE TABLE Ganesh(Product char(2), Period date , Actual numeric, Target numeric );

	-- Insert values to the table 
		INSERT INTO Ganesh(Product, Period, Actual, Target) VALUES
		('a',	TO_DATE('01/01/16', 'DD/MM/YYYY'),	30,	100),
		('a',	TO_DATE('02/01/16', 'DD/MM/YYYY'),	400, 200),
		('a',	TO_DATE('03/01/16', 'DD/MM/YYYY'),	50, 250),
		('a',	TO_DATE('04/01/16', 'DD/MM/YYYY'),	200, 300),
		('a',	TO_DATE('05/01/16', 'DD/MM/YYYY'),	300, 200),
		('a',	TO_DATE('06/01/16', 'DD/MM/YYYY'),	150, 100),
		('a',	TO_DATE('07/01/16', 'DD/MM/YYYY'),	80, 100),
		('a',	TO_DATE('08/01/16', 'DD/MM/YYYY’),	200, 200),
		('a',	TO_DATE('09/01/16', 'DD/MM/YYYY'),	150, 200),
		('a',	TO_DATE('10/01/16', 'DD/MM/YYYY'),	250, 300),
		('a',	TO_DATE('11/01/16', 'DD/MM/YYYY'),	450, 400),
		('a',	TO_DATE('12/01/16', 'DD/MM/YYYY'),	550, 500) ;
-----------------------------------------------------------------------------------
--b.  Write a script and text files as to how I will import this csv into the table
-----------------------------------------------------------------------------------
 
 	-- Import CSV file ;
		BULK INSERT imported_file
		FROM 'C:\MLMBT\Ganesh.csv'
		WITH
		(FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n')
		GO ;

	-- Insert data values from the imported CSV file ;	
		INSERT 	Ganesh 
		(Product, Period, Actual, Target) 
		SELECT 	Product, Period, Actual, Target 
		FROM imported_file ;

 	--OR, we can directly copy the values from the csv file using the following code 
   		COPY Ganesh FROM  "C:\MLMBT\Ganesh.csv" , DELIMITER ',' CSV HEADER; 

-----------------------------------------------------------------------------------
--c. Write an sql script for showing me the running sum of actuals
-----------------------------------------------------------------------------------
	SELECT DISTINCT a.Product, a.Period, a.Actual, a.Target, SUM(b.Actual) as ActualRuningSum
	FROM Ganesh a, Ganesh b 
	where b.Period <= a.Period
    GROUP BY a.Period


-----------------------------------------------------------------------------------
--d.Write an sql script showing the previous month vs current month difference of actuals.
-----------------------------------------------------------------------------------	
	SELECT a.Product, a.Period, a.Actual, a.Target, b.Actual - a.Actual as ActualDif
	FROM Ganesh a, Ganesh b 
	where DATEDIFF(month, a.Period, b.Period)=1 ;
-----------------------------------------------------------------------------------
--e.  Write an sql script showing each row and the total sum of actuals in each row

    SELECT Product, Period, Actual, Target, (select sum(Actual) from Ganesh) as SumActual	
    FROM Ganesh;
-----------------------------------------------------------------------------------       
--f.  The python script will take the excel file and convert to a utf8 text csv file
 -----------------------------------------------------------------------------------
    -- We can easly read and write using pandas library in python 
	import pandas as pd
    mydata= pd.read_excel("Ganesh.xlsx", sheetname= "Sheet1") -- to read excel file in python 
    mydata.to_csv("mydata.csv", index=False ) --to write csv file by ignoring the indexes of the data frame 
    
 -----------------------------------------------------------------------------------   
--g.  The unix shell script will remove the header row .
 -----------------------------------------------------------------------------------
    sed -i '1d' Ganesh.txt   -- Remove header row from Ganesh.txt
-----------------------------------------------------------------------------------    
--h.  The unix shell will create 12 files one for each month with no header row.
-----------------------------------------------------------------------------------	
    split -l 1 Ganesh.txt GaneshPerRow  --Created file names will be GaneshPerRowaa,GaneshPerRowab, ..., GaneshPerRowal


