import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import pandas as pd 
import re
from dotenv import load_dotenv
import os 
import matplotlib.pyplot as plt

load_dotenv()

# set uping client credentials 
id=os.getenv('SPOTIPY_CLIENT_ID')
c_key=os.getenv('SPOTIPY_CLIENT_SECRET')

sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(
    client_id=id,
    client_secret=c_key
))

# full tract URL (Example: shape of your by ed sheeran)
tract_url = "https://open.spotify.com/track/3n3Ppam7vgaVa1iaRUc9Lp"

# extract track id from url using regex
track_id = re.search(r'track/([a-zA-Z0-9]+)',tract_url).group(1)

# fetch track details 
track = sp.track(track_id)
print(track)

# Extracting metadata 

track_data = {
    'Track Name':track['name'],
    'Artist' : track['artists'][0]['name'],
    'Album':track['album']['name'],
    'Popularity':track['popularity'],
    'Duration (minutes)':track['duration_ms']/60000
}

# Display metadata
print(f"\nTrack Name: {track_data['Track Name']}")
print(f"Artist: {track_data['Artist']}")
print(f"Album: {track_data['Album']}")
print(f"Popularity: {track_data['Popularity']}")
print(f"Duration: {track_data['Duration (minutes)']:.2f} minutes")

# Convert metadata to DataFrame
df = pd.DataFrame([track_data])
print("\nTrack Data as DataFrame:")
print(df)

# Save metadata to CSV
df.to_csv('spotify_track_data.csv', index=False)

# Visualize track data
features = ['Popularity', 'Duration (minutes)']
values = [track_data['Popularity'], track_data['Duration (minutes)']]

plt.figure(figsize=(8, 5))
plt.bar(features, values, color='skyblue', edgecolor='black')
plt.title(f"Track Metadata for '{track_data['Track Name']}'")
plt.ylabel('Value')
plt.show()