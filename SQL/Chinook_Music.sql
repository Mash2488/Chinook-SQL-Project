-- total artist and total album

SELECT 
    COUNT(DISTINCT ArtistId) AS total_artists, 
    COUNT(DISTINCT AlbumId) AS total_albums
FROM Album;

-- most artist-id album

SELECT
	ArtistId,
	COUNT(AlbumId) 
FROM Album
GROUP BY ArtistId
ORDER BY COUNT(AlbumID) DESC;

-- most artist album

SELECT 
    artist.Name,
    COUNT(album.AlbumId) AS AlbumCount
FROM Album AS album
JOIN Artist AS artist
    ON album.ArtistId = artist.ArtistId
GROUP BY artist.ArtistId
ORDER BY AlbumCount DESC
LIMIT 15;

-- top artist per genre

SELECT
	track.GenreId,
	genre.Name,
	COUNT(DISTINCT artist.ArtistId) AS total_artist
FROM Track AS track
INNER JOIN Album AS album 
	ON track.AlbumId=album.AlbumId
INNER JOIN Genre AS genre 
	ON track.GenreId=genre.GenreId
INNER JOIN Artist AS artist 
	ON album.ArtistId=artist.ArtistId
GROUP BY genre.Name
ORDER BY total_artist DESC
LIMIT 10;

-- most artist per genre %

SELECT
    genre.Name,
    COUNT(DISTINCT artist.ArtistId) AS total_artist,
    (COUNT(DISTINCT artist.ArtistId) * 100.0 / 
     (SELECT COUNT(DISTINCT artist.ArtistId) FROM Artist AS artist)) AS percentage
FROM Track AS track
INNER JOIN Album AS album 
    ON track.AlbumId = album.AlbumId
INNER JOIN Genre AS genre 
    ON track.GenreId = genre.GenreId
INNER JOIN Artist AS artist 
    ON album.ArtistId = artist.ArtistId
GROUP BY genre.Name
ORDER BY percentage DESC
LIMIT 10;

-- top spend customer

SELECT
	c.FirstName,
	c.LastName,
	c.CustomerId,
	SUM(i.total) AS sum_total
FROM Customer AS c
INNER JOIN Invoice AS i
	ON c.CustomerId=i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY sum_total DESC;

-- overall top spend country

SELECT
	c.Country,
	c.State,
	c.City,
	SUM(i.total) AS sum_total
FROM Invoice AS i
LEFT JOIN Customer AS c
	ON c.CustomerId=i.CustomerId
GROUP BY c.Country, c.State, c.City
ORDER BY sum_total DESC
LIMIT 20;

-- most customers per country

SELECT
	COUNT(CustomerId) AS total_customers,
	Country
FROM Customer
GROUP BY Country
ORDER BY total_customers DESC
LIMIT 10;

-- top avg country spend

SELECT
    c.Country,
    SUM(i.Total) / COUNT(DISTINCT c.CustomerId) AS avg_spending
FROM Invoice AS i
LEFT JOIN Customer AS c
    ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY avg_spending DESC;

-- state breakdown

SELECT
	c.State,
	c.Country,
	SUM(i.total) AS sum_total
FROM Customer AS c
LEFT JOIN Invoice AS i
	ON c.CustomerId=i.CustomerId
WHERE c.Country = 'USA'
GROUP BY c.State
ORDER BY sum_total DESC;

-- usa state percents

SELECT
    c.State,
    SUM(i.Total) AS sum_total,
    (SUM(i.Total) * 100.0) / 
    (SELECT SUM(i.Total) 
     FROM Invoice AS i
     INNER JOIN Customer AS c ON c.CustomerId = i.CustomerId
     WHERE c.Country = 'USA') AS percent_total_sales
FROM Customer AS c
LEFT JOIN Invoice AS i 
    ON c.CustomerId = i.CustomerId
WHERE c.Country = 'USA'
GROUP BY c.State
ORDER BY percent_total_sales DESC;

-- monthly total

SELECT 
	strftime('%m', InvoiceDate) AS month,
	strftime('%Y', InvoiceDate) AS year,
	SUM(total) AS sum_total
FROM Invoice
GROUP BY year, month
ORDER BY year, month;

-- yearly total

SELECT
	strftime('%Y', InvoiceDate) AS year,
	SUM(total) AS sum_total
FROM Invoice
GROUP BY year
ORDER BY year;

--top 5

SELECT 
    c.Country, 
    SUM(i.Total) AS total_sales,
    (SUM(i.Total) * 100.0 / (SELECT SUM(Total) FROM Invoice)) AS percent_of_total_sales
FROM Invoice AS i
LEFT JOIN Customer AS c 
    ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY total_sales DESC
LIMIT 5;

-- top per year

SELECT
	c.Country,
	strftime('%Y', i.InvoiceDate) AS year,
	SUM(i.total) AS sum_total
FROM Invoice AS i
LEFT JOIN Customer AS c
	ON c.CustomerId=i.CustomerId
GROUP BY year, c.Country
ORDER BY year, sum_total DESC;

-- top 5 per year

SELECT
	c.Country,
	strftime('%Y', i.InvoiceDate) AS year,
	SUM(i.total) AS sum_total
FROM Invoice AS i
LEFT JOIN Customer AS c
	ON c.CustomerId=i.CustomerId
WHERE c.Country IN ('USA', 'Canada', 'France', 'Brazil', 'Germany')
GROUP BY year, c.Country
ORDER BY year, sum_total DESC;

-- investigating california

SELECT
	c.State,
	c.Country,
	COUNT(DISTINCT c.CustomerId) AS total_customers,
	SUM(i.Total) AS sum_total,
	SUM(i.Total) / COUNT(DISTINCT c.CustomerId) AS avg_spend_cust
FROM Customer AS c
LEFT JOIN Invoice AS i
	ON c.CustomerId=i.CustomerId
WHERE c.Country = 'USA'
GROUP BY c.State
ORDER BY sum_total DESC;

--investigating czech republic

SELECT
	c.Country,
	COUNT(DISTINCT c.CustomerId) AS total_customers,
	SUM(i.Total) AS sum_total,
	SUM(i.Total) / COUNT(DISTINCT c.CustomerId) AS avg_spend_cust
FROM Customer AS c
LEFT JOIN Invoice AS i
	ON c.CustomerId=i.CustomerId
WHERE c.Country = 'Czech Republic'
GROUP BY c.Country
ORDER BY sum_total DESC;

--investigating chile hungary ireland

SELECT
	c.Country,
	COUNT(DISTINCT c.CustomerId) AS total_customers,
	SUM(i.Total) AS sum_total,
	SUM(i.Total) / COUNT(DISTINCT c.CustomerId) AS avg_spend_cust
FROM Customer AS c
LEFT JOIN Invoice AS i
	ON c.CustomerId=i.CustomerId
WHERE c.Country IN ('Chile', 'Hungary', 'Ireland', 'Czech Republic')
GROUP BY c.Country
ORDER BY sum_total DESC;

--most purchase genre by Country

SELECT
	c.Country,
	g.Name AS genre,
	COUNT(IL.TrackId) AS num_purchases
FROM InvoiceLine AS IL
JOIN Invoice AS i
	ON IL.InvoiceId = i.InvoiceId
JOIN Customer AS c
	ON i.CustomerId = c.CustomerId
JOIN Track AS t
	ON IL.TrackId = t.TrackId
JOIN Genre AS g
	ON t.GenreId = g.GenreId
GROUP BY c.Country, g.Name
ORDER BY num_purchases DESC;

--top 5 music buying countries

SELECT
    c.Country,
    COUNT(IL.TrackId) AS num_purchases
FROM InvoiceLine AS IL
JOIN Invoice AS i
    ON IL.InvoiceId = i.InvoiceId
JOIN Customer AS c
    ON i.CustomerId = c.CustomerId
GROUP BY c.Country
ORDER BY num_purchases DESC
LIMIT 5;

--top 5 genre purchase by country 

SELECT
    c.Country,
    g.Name AS genre,
    COUNT(IL.TrackId) AS num_purchases
FROM InvoiceLine AS IL
JOIN Invoice AS i
    ON IL.InvoiceId = i.InvoiceId
JOIN Customer AS c
    ON i.CustomerId = c.CustomerId
JOIN Track AS t
    ON IL.TrackId = t.TrackId
JOIN Genre AS g
    ON t.GenreId = g.GenreId
WHERE c.Country IN ('USA', 'Canada', 'France', 'Brazil', 'Germany')
GROUP BY c.Country, g.Name
ORDER BY num_purchases DESC;

-- album vs tracks

SELECT
    a.AlbumId,
    COUNT(t.TrackId) AS total_tracks,
    COUNT(IL.TrackId) AS purchased_tracks
FROM Album AS a
INNER JOIN Track AS t
    ON a.AlbumId = t.AlbumId
LEFT JOIN InvoiceLine AS IL
    ON IL.TrackId = t.TrackId
GROUP BY a.AlbumId;

SELECT
    a.AlbumId,
    COUNT(t.TrackId) AS total_tracks,
    COUNT(IL.TrackId) AS purchased_tracks,
    CASE 
        WHEN COUNT(IL.TrackId) = COUNT(t.TrackId) THEN 'Album Purchase'
        ELSE 'Track Purchase'
    END AS purchase_type
FROM Album AS a
INNER JOIN Track AS t
    ON a.AlbumId = t.AlbumId
LEFT JOIN InvoiceLine AS IL
    ON IL.TrackId = t.TrackId
GROUP BY a.AlbumId;

WITH album_v_tracks AS (
	SELECT
			CASE
				WHEN COUNT(IL.TrackId) = COUNT(t.TrackId) THEN 'Album Purchase'
				ELSE 'Track Purchase'
			END AS purchase_type
	FROM Album AS a
	INNER JOIN Track AS t
		ON a.AlbumId=t.AlbumId
	LEFT JOIN InvoiceLine AS IL
		ON IL.TrackId=t.TrackId
	GROUP BY a.AlbumId
)
SELECT
	purchase_type,
	COUNT(*) AS total_purchases,
	(COUNT(*) * 100 / (SELECT COUNT(*) FROM album_v_tracks)) AS percentage
FROM album_v_tracks
GROUP BY purchase_type;

-- most popular Artist

SELECT 
	Artist.Name,
	SUM(Track.UnitPrice * InvoiceLine.Quantity) AS total_revenue
FROM Track AS Track
JOIN InvoiceLine AS InvoiceLine
	ON Track.TrackId = InvoiceLine.TrackId
JOIN Album AS Album
	ON Album.AlbumId = Track.AlbumId
JOIN Artist AS Artist
	ON Artist.ArtistId = Album.ArtistId
GROUP BY Artist.Name
ORDER BY total_revenue DESC
LIMIT 20;

SELECT 
    c.Country,
    COUNT(CASE WHEN g.Name = 'Classical' THEN IL.TrackId END) AS classical_purchases,
    COUNT(IL.TrackId) AS total_purchases,
    (COUNT(CASE WHEN g.Name = 'Classical' THEN IL.TrackId END) * 100.0 / COUNT(IL.TrackId)) AS classical_percentage
FROM InvoiceLine AS IL
JOIN Invoice AS i 
    ON IL.InvoiceId = i.InvoiceId
JOIN Customer AS c 
    ON i.CustomerId = c.CustomerId
JOIN Track AS t 
    ON IL.TrackId = t.TrackId
JOIN Genre AS g 
    ON t.GenreId = g.GenreId
GROUP BY c.Country
ORDER BY classical_percentage DESC
LIMIT 10;











	
	
	



