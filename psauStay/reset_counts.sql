-- Reset all status counts by updating records
USE HotelBooking;

-- Update all RoomRequests to have a consistent status
UPDATE RoomRequests SET Status = 'Pending' WHERE Status NOT IN ('Approved', 'Rejected', 'Pending', 'Waitlist');

-- Update all Reservation records to have a consistent status  
UPDATE [dbo].[Reservation] SET Status = 'Pending' WHERE Status NOT IN ('Approved', 'Rejected', 'Pending', 'Waitlisted');

-- Optional: If you want to completely clear the tables
-- DELETE FROM RoomRequests;
-- DELETE FROM [dbo].[Reservation];

-- Check the results
SELECT 'RoomRequests' as TableName, Status, COUNT(*) as Count 
FROM RoomRequests 
GROUP BY Status 
ORDER BY Count DESC;

SELECT 'Reservation' as TableName, Status, COUNT(*) as Count
FROM [dbo].[Reservation]
GROUP BY Status
ORDER BY Count DESC;
