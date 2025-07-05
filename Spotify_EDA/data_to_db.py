import re
from spotipy.oauth2 import SpotifyClientCredentials
import spotipy
import pandas as pd
import matplotlib.pyplot as plt
import mysql.connector
import os
from dotenv import load_dotenv


load_dotenv()

# set uping client credentials 
id=os.getenv('SPOTIPY_CLIENT_ID')
c_key=os.getenv('SPOTIPY_CLIENT_SECRET')

sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(
    client_id=id,
    client_secret=c_key
))
# MySQL Database Connection
db_config = {
    'host': 'localhost',           # Change to your MySQL host
    'user': 'root',       # Replace with your MySQL username
    'password': '5103',   # Replace with your MySQL password
    'database': 'spotify_db'       # Replace with your database name
}

# # Connect to the database
connection = mysql.connector.connect(**db_config)
cursor = connection.cursor()

# Read track URLs from file
file_path = "track_urls.txt"
with open(file_path, 'r') as file:
    track_urls = file.readlines()

# Process each URL
for track_url in track_urls:
    track_url = track_url.strip()  # Remove any leading/trailing whitespace
    try:
        # Extract track ID from URL
        track_id = re.search(r'track/([a-zA-Z0-9]+)', track_url).group(1)

        # Fetch track details from Spotify API
        track = sp.track(track_id)

        # Extract metadata
        track_data = {
            'Track Name': track['name'],
            'Artist': track['artists'][0]['name'],
            'Album': track['album']['name'],
            'Popularity': track['popularity'],
            'Duration (minutes)': track['duration_ms'] / 60000
        }

        # Insert data into MySQL
        insert_query = """
        INSERT INTO spotify_tracks (track_name, artist, album, popularity, duration_minutes)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(insert_query, (
            track_data['Track Name'],
            track_data['Artist'],
            track_data['Album'],
            track_data['Popularity'],
            track_data['Duration (minutes)']
        ))
        connection.commit()

        print(f"Inserted: {track_data['Track Name']} by {track_data['Artist']}")

    except Exception as e:
        print(f"Error processing URL: {track_url}, Error: {e}")

# Close the connection
cursor.close()
connection.close()

print("All tracks have been processed and inserted into the database.")



# # Full track URL (example: Shape of You by Ed Sheeran)
# track_url = "https://open.spotify.com/track/3n3Ppam7vgaVa1iaRUc9Lp"

# # Extract track ID directly from URL
# track_id = re.search(r'track/([a-zA-Z0-9]+)', track_url).group(1)

# # Fetch track details
# track = sp.track(track_id)

# # Extract metadata
# track_data = {
#     'Track Name': track['name'],
#     'Artist': track['artists'][0]['name'],
#     'Album': track['album']['name'],
#     'Popularity': track['popularity'],
#     'Duration (minutes)': track['duration_ms'] / 60000
# }

# # Insert data into MySQL
# insert_query = """
# INSERT INTO spotify_tracks (track_name, artist, album, popularity, duration_minutes)
# VALUES (%s, %s, %s, %s, %s)
# """
# cursor.execute(insert_query, (
#     track_data['Track Name'],
#     track_data['Artist'],
#     track_data['Album'],
#     track_data['Popularity'],
#     track_data['Duration (minutes)']
# ))
# connection.commit()

# print(f"Track '{track_data['Track Name']}' by {track_data['Artist']} inserted into the database.")

# # Close the connection
# cursor.close()
# connection.close()