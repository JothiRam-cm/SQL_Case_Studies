select * from spotify_tracks; 

# List all tracks in the table.
select track_name from spotify_tracks;

# inference
# there are totaly nine tracks
# there are two tracks with similar name both are from same artist  the killers (may be dublicate but popularity is different )

# Display all tracks by artist 'Muse'
select * from spotify_tracks where artist = 'Muse'; 
	# inferece
	# muse have two tracks 1.Time is Running Out 2.Uprising

# Find the track with the highest popularity.
select * from spotify_tracks where popularity = (select max(popularity) from spotify_tracks); 

	# inference
	# there is only one track with higest popularity with 93

# List all tracks where duration is more than 4 minutes.
select * from spotify_Tracks where duration_minutes > 4; 
	
    # inference
	# three tracks having duration more than 4 minutes and popularity 
    # for these tracks are significantly high compare to others 

# Count the total number of tracks in the table.
select count(*) from spotify_tracks; 

# inference
# total of 9 tracks but one is dublicate 
# so total of distinct tracks are 8  

# Get all distinct artist names.
select distinct artist from spotify_tracks;
# inference
# there are 7 distinct artist 
# because muse and The killers (same track)  has two tracks 

# Find all tracks whose name contains 'Mr.'.
select * from spotify_tracks where track_name like 'Mr.%';
# inference
# there are two tracks starts like this  'Mr.'
# both are simmilar but difference in popularity 

# Show all tracks from the album 'Hot Fuss'.
select * from spotify_tracks where album = 'Hot Fuss';

#inference 
# two tracks from similar tracks from Hot Fuss name Mr. Brightside 

# List the tracks with popularity between 50 and 90.
select * from spotify_tracks where popularity between 50 and 90;

# inference 
# there are four tracks with popularity range  between 50 and 90

# Sort the tracks in descending order of popularity.
select * from spotify_tracks order by popularity desc;


# Count how many tracks each artist has.
select artist,count(distinct track_name) cnt_tracks from spotify_tracks group by artist; 
# inference
# the artists The Killers and Muse has two tracks 
# but all others has single if dublicate allowed  
# if dublicates are not allowed means Muse alone has two tracks 

# Find the average duration of all tracks.
select track_name,  round(avg(duration_minutes),2) avg_duration from spotify_tracks group by track_name order by avg_duration;

# inference 
# max hig avg duration is 5.08 min  by uprising
# min avg duration is 3.69 min  by  lover

-- ---------------------
use spotify_db;      -- |
desc spotify_tracks; -- |
-- ---------------------

# Show the average popularity per artist.
select artist , round(avg(popularity),2) avg_popularity from spotify_tracks group by artist order by avg_popularity;

# inference 
# max avg_popularity is 93.00 by the artist The Police 
# min avg_popularity is 24.00 byt the artist Eduard Abramyan

# Display the albums that have more than 1 track listed.
select * from spotify_tracks where (album,2) in (select album,count(track_name) from spotify_tracks group by album) ;


-- Find duplicate track names with different popularity scores.
select track_name,popularity from (select count(track_name)over(partition by track_name  order by track_name) rnk , track_name,popularity from spotify_tracks) t where rnk >= 2;

-- List tracks whose duration is above the average duration.
select * from spotify_tracks where duration_minutes > (select avg(duration_minutes) from spotify_tracks);
-- Find the top 3 most popular tracks per artist.
select * from (select *,dense_rank()over(order by popularity desc) rnk from spotify_tracks) t where rnk between 1 and 3;

-- Identify artists who have at least one track with popularity > 80.
select * from spotify_tracks where popularity > 80;

-- List track names along with the length category (Short, Medium, Long):
select *, 
(case 
when duration_minutes < 3 then 'Short' 
when duration_minutes between 3 and 4 then 'Medium'
else 'Long' end) as length_category
from spotify_tracks;

-- Short: < 3 min

-- Medium: 3–4 min

-- Long: > 4 min

-- Group tracks by album and show the max popularity in each album.
select * from (select *, dense_rank()over(partition by album order by popularity desc) rnk from spotify_tracks)t where rnk = 1;


-- Create a view TopTracks that shows tracks with popularity > 85.
create view popularity_view as 
select * from spotify_tracks where popularity > 85;

-- Use a self join to compare popularity of tracks with the same name but different albums.
SELECT 
    *
FROM
    spotify_tracks s1
        JOIN
    spotify_tracks s2 ON s1.album != s2.album
        AND s1.track_name = s2.track_name;