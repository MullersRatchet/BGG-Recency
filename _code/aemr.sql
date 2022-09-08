--Count the number of valid (Status = Approved) outage events for 2016
SELECT 
Count(Status = "Approved") AS Total_Number_Outage_Events,
Status,
Reason
FROM AEMR
WHERE 
Status = "Approved" AND
(YEAR(Start_Time) = 2016)
GROUP BY Reason, Status
ORDER BY Reason
;

--Count the number of valid (Status = Approved) outage events sorted by reason
SELECT 
Count(Status = "Approved") AS Total_Number_Outage_Events,
Status,
Reason
FROM AEMR
WHERE 
Status = "Approved" AND
(YEAR(Start_Time) = 2017)
GROUP BY Reason, Status
ORDER BY Reason
;

--Calculate average duration (days) for each approved outage type for 2016 - 2017
SELECT
Status,
Reason,
Count(Status = "Approved") AS Total_Number_Outage_Events,
ROUND((AVG(TIMESTAMPDIFF(MINUTE,Start_Time, End_Time))/1440),2) AS Average_Outage_Duration_Time_Days,
YEAR(Start_Time) AS Year
FROM AEMR
WHERE Status = "Approved" 
AND (Year (Start_Time) = 2016 OR Year(Start_Time) = 2017)
GROUP BY Reason, Year(Start_Time)
ORDER BY Reason, Year(Start_Time)
;

--Count approved outage in 2016 and order by reason and month
SELECT 
Status,
Reason,
Count(Status = "Approved") AS Total_Number_Outage_Events,
MONTH(Start_Time) AS Month
FROM AEMR
WHERE YEAR(Start_Time) = 2016 AND
Status = "Approved"
GROUP BY Reason, MONTH(Start_Time)
ORDER BY Reason, MONTH(Start_Time)
;

--Count approved outage in 2017 and order by reason and month
SELECT
Status,
Reason,
Count(Status = "Approved") AS Total_Number_Outage_Events,
MONTH(Start_Time) AS Month
FROM AEMR
WHERE YEAR(Start_Time) = 2017 AND
Status = "Approved"
GROUP BY Reason, MONTH(Start_Time)
ORDER BY Reason, MONTH(Start_Time)
;

--Count total number of all approved outages in 2016 and 2017 and order by month and year
SELECT 
Status,
Count(Status = "Approved") AS Total_Number_Outage_Events,
MONTH(Start_Time) AS Month,
YEAR(Start_Time) AS Year
FROM AEMR
WHERE (YEAR(Start_Time) = 2016 OR YEAR(Start_Time) = 2017) AND
Status = "Approved"
GROUP BY MONTH(Start_Time), Year(Start_Time)
ORDER BY MONTH(Start_Time), Year(Start_Time)
;

--Count approved outages for 2016 and order by participant code and status
SELECT 
Count(Status = "Approved") AS Total_Number_Outage_Events,
Participant_Code,
Status,
YEAR(Start_Time) AS Year
FROM AEMR
WHERE (YEAR(Start_Time) = 2016 OR YEAR(Start_Time) = 2017) AND
Status = "Approved"
GROUP BY Year(Start_Time), Participant_Code
ORDER BY Year(Start_Time), Participant_Code
;

--Show average duration of all aproved outage types for particpant codes and year
SELECT 
Participant_Code,
Status,
YEAR(Start_Time) AS Year,
ROUND((AVG(TIMESTAMPDIFF(MINUTE,Start_Time, End_Time))/1440),2) AS Average_Outage_Duration_Time_Days
FROM AEMR
WHERE (YEAR(Start_Time) = 2016 OR YEAR(Start_Time) = 2017) AND
Status = "Approved"
GROUP BY Year(Start_Time), Participant_Code
ORDER BY Average_Outage_Duration_Time_Days DESC
;

--Count the number of approved forced outages for 2016 and 2017 and order by reason and year
SELECT 
Count(Status = "Approved") AS Total_Number_Outage_Events,
Reason,
Year(Start_Time) AS Year
FROM AEMR
WHERE 
Status = "Approved" AND
Reason = "Forced" AND
(YEAR(Start_Time) = 2016 OR YEAR(Start_Time) = 2017)
GROUP BY Year
ORDER BY Year
;

--Calculate proportion of outages that ere forced for 2016 and 2017
SELECT 
SUM(CASE WHEN Reason = "Forced" THEN 1 ELSE 0 END) AS Total_Number_Forced_Outage_Events,
Count(Status = "Approved") AS Total_Number_Outage_Events,
ROUND((SUM(CASE WHEN Reason = "Forced" THEN 1 ELSE 0 END)/Count(Status = "Approved"))*100,2) AS Forced_Outage_Percentage,
Year(Start_Time) AS Year
FROM AEMR
WHERE 
Status = "Approved" AND
(YEAR(Start_Time) = 2016 OR YEAR(Start_Time) = 2017)
GROUP BY Year
ORDER BY Year
;

--Calculate average duration of forced outages and average energy lost for 2016 and 2017
SELECT 
Status,
Year(Start_Time) AS Year,
ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
ROUND(AVG(TIMESTAMPDIFF(MINUTE,Start_Time, End_Time)),2) AS Average_Outage_Duration_Time_Minutes
FROM AEMR
WHERE 
Status = "Approved" AND
Reason = "Forced" AND
(YEAR(Start_Time) = 2016 OR YEAR(Start_Time) = 2017)
GROUP BY Year
ORDER BY Year
;

--Calculate the average duration of outage events for 2016 and 2017 and order by year
SELECT 
Status,
Reason,
Year(Start_Time) AS Year,
ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
ROUND(AVG(TIMESTAMPDIFF(MINUTE,Start_Time, End_Time)),2) AS Average_Outage_Duration_Time_Minutes
FROM AEMR
WHERE 
Status = "Approved" AND
(YEAR(Start_Time) = 2016 OR YEAR(Start_Time) = 2017)
GROUP BY Reason, Year
ORDER BY Year
;

--Calculate average duration of forced outages and average energy lost for each participant code
SELECT
Participant_Code,
Status,
Year(Start_Time) AS Year,
ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
ROUND(AVG(TIMESTAMPDIFF(MINUTE,Start_Time, End_Time))/1440,2) AS Average_Outage_Duration_Time_Days
FROM AEMR
WHERE 
Status = "Approved" AND
Reason = "Forced" AND
(YEAR(Start_Time) = 2016 OR YEAR(Start_Time) = 2017)
GROUP BY Year, Participant_Code
ORDER BY Avg_Outage_MW_Loss DESC
;

--Calculate average outage loss and overall summed outage loss for each participant code and ordered by year
SELECT
Participant_Code,
Facility_Code,
Status,
Year(Start_Time) AS Year,
ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
ROUND(SUM(Outage_MW),2) AS Summed_Energy_Lost
FROM AEMR
WHERE 
Status = "Approved" AND
Reason = "Forced" AND
(YEAR(Start_Time) = 2016 OR YEAR(Start_Time) = 2017)
GROUP BY Year, Participant_Code, Facility_Code
ORDER BY Summed_Energy_Lost DESC
;
