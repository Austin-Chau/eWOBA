USE lahman2016;

SELECT * FROM Master;
SELECT * FROM Weights;
SELECT 
	CONCAT(wOBAs.nameFirst, ' ', wOBAs.nameLast) AS name,
	wOBAs.yearID, 
    ROUND(wOBA, 3) AS wOBA,
    ROUND(wOBA_5_Days, 3) AS wOBA_5_Days,
    ROUND(wOBA_10_Days, 3) AS wOBA2_10_Days
FROM (
	SELECT  Master.nameFirst,
			Master.nameLast,
			Batting.playerID, 
			Batting.yearID, 
			((Weights.wBB * BB) + (Weights.wHBP * HBP) + (Weights.w1B * (H - 2B - 3B - HR)) + (Weights.w2B * 2B) + (Weights.w3B * 3B) + (Weights.wHR * HR))/(AB + BB - IBB + SF + HBP) as wOBA,
			((newWeights.wBB * BB) + (newWeights.wHBP * HBP) + (newWeights.w1B * (H - 2B - 3B - HR)) + (newWeights.w2B * 2B) + (newWeights.w3B * 3B) + (newWeights.wHR * HR))/(AB + BB - IBB + SF + HBP) as fiveYears,
			((Weights10.wBB * BB) + (Weights10.wHBP * HBP) + (Weights10.w1B * (H - 2B - 3B - HR)) + (Weights10.w2B * 2B) + (Weights10.w3B * 3B) + (Weights10.wHR * HR))/(AB + BB - IBB + SF + HBP) as tenYears
    FROM Batting INNER JOIN Weights ON Batting.yearID = Weights.season 
	INNER JOIN newWeights ON Batting.yearID = newWeights.season
    INNER JOIN Weights10 ON Batting.yearID = Weights10.season
    INNER JOIN Master ON Master.playerID = Batting.playerID
	WHERE yearID > 1950 AND yearID < 2008 AND AB > 50) AS wOBAs
WHERE wOBA != NULL OR wOBA != 0;