# 🎵 Spotify Public Tracks Data - EDA using SQL and Python

## 📦 Project Overview

This project involves collecting public track data from Spotify using the [Spotify Developer API](https://developer.spotify.com/documentation/web-api/) and performing Exploratory Data Analysis (EDA) using SQL and Python. The goal is to uncover patterns and insights regarding track popularity, artists, albums, and duration.

The project consists of:
1.  **Data Extraction**: Python scripts to fetch data from Spotify API.
2.  **Data Storage**: Storing the data into a MySQL database and CSV files.
3.  **Data Analysis**: SQL scripts to query the database and derive insights.

---

## 🛠️ Tech Stack

*   **Programming Language**: Python, SQL
*   **Database**: MySQL
*   **API**: Spotify Web API
*   **Python Libraries**:
    *   `spotipy`: Spotify API client
    *   `pandas`: Data manipulation
    *   `matplotlib`: Visualization
    *   `mysql-connector-python`: Database connection
    *   `python-dotenv`: Environment configuration

---

## 🗂️ Project Structure

```text
spotify-sql-eda/
├── data_extract_transform.py       # Script to fetch single track data, save to CSV, and visualize
├── data_to_db.py                   # Script to fetch multiple tracks from URLs and insert into MySQL
├── spotify_track_data.csv          # Output CSV file from data_extract_transform.py
├── spotify_track_data_analysis.sql # SQL queries for detailed EDA
├── track_urls.txt                  # Input file containing Spotify track URLs
├── requirements.txt                # Python dependencies
└── readme.md                       # Project documentation
```

---

## 🔧 Prerequisites

Before running the project, ensure you have the following:

*   **Python 3.x** installed.
*   **MySQL Server** installed and running.
*   **Spotify Developer Account**: You need a `Client ID` and `Client Secret`. Create an app at [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/).

---

## 🚀 Setup & Installation

### 1. Clone the Repository

```bash
git clone https://github.com/JothiRam-cm/SQL_Case_Studies.git
cd SQL_Case_Studies/Spotify_EDA
```

### 2. Install Dependencies

Install the required Python libraries:

```bash
pip install -r requirements.txt
```

*Note: Key dependencies include `spotipy`, `pandas`, `matplotlib`, `mysql-connector-python`, `python-dotenv`.*

### 3. Configure Environment Variables

Create a `.env` file in the project root directory and add your Spotify API credentials:

```env
SPOTIPY_CLIENT_ID='your_client_id_here'
SPOTIPY_CLIENT_SECRET='your_client_secret_here'
```

### 4. Database Setup

Before running the batch processing script, you need to create the database and table in MySQL.

1.  Log in to MySQL.
2.  Run the following SQL commands:

```sql
CREATE DATABASE IF NOT EXISTS spotify_db;
USE spotify_db;

CREATE TABLE IF NOT EXISTS spotify_tracks (
    track_name VARCHAR(255),
    artist VARCHAR(255),
    album VARCHAR(255),
    popularity INT,
    duration_minutes FLOAT
);
```

---

## 📖 Usage

### A. Single Track Analysis (`data_extract_transform.py`)

This script fetches data for a single hardcoded track URL, saves it to `spotify_track_data.csv`, and displays a bar chart of Popularity vs Duration.

1.  Open `data_extract_transform.py`.
2.  (Optional) Update the `tract_url` variable with a Spotify track URL of your choice.
3.  Run the script:
    ```bash
    python data_extract_transform.py
    ```

### B. Batch Data Collection to Database (`data_to_db.py`)

This script reads a list of track URLs from `track_urls.txt`, fetches their metadata, and inserts them into the `spotify_db` MySQL database.

1.  Ensure `track_urls.txt` contains the Spotify URLs you want to analyze (one per line).
2.  Update the `db_config` dictionary in `data_to_db.py` with your MySQL credentials (user, password).
3.  Run the script:
    ```bash
    python data_to_db.py
    ```

### C. SQL Exploratory Data Analysis

Open `spotify_track_data_analysis.sql` in your SQL client (e.g., MySQL Workbench) connected to `spotify_db`. Execute the queries to perform analysis.

---

## 📊 Key Insights & Analysis

The SQL analysis (`spotify_track_data_analysis.sql`) covers the following aspects:

1.  **Basic Statistics**:
    *   Total number of tracks and distinct artists.
    *   Identification of duplicate tracks (same name, different albums/popularity).

2.  **Popularity Analysis**:
    *   **Highest Popularity**: Identified the single track with the highest popularity score (93).
    *   **Average Popularity by Artist**: "The Police" had the highest average popularity (93.00), while "Eduard Abramyan" had the lowest (24.00).
    *   **Popularity Distribution**: Tracks grouped by popularity ranges (e.g., 50-90).

3.  **Duration Analysis**:
    *   **Long Tracks**: Identified tracks longer than 4 minutes (typically having high popularity).
    *   **Average Duration**: Calculated average duration per track. "Uprising" had the highest (5.08 min) and "Lover" the lowest (3.69 min).
    *   **Categorization**: Tracks classified as 'Short' (<3 min), 'Medium' (3-4 min), or 'Long' (>4 min).

4.  **Artist & Album Insights**:
    *   **Track Counts**: "The Killers" and "Muse" have multiple tracks in the dataset.
    *   **Album Analysis**: Identified albums with multiple tracks (e.g., "Hot Fuss").

---

## 🗄️ Database Schema

**Table**: `spotify_tracks`

| Column Name        | Data Type | Description                                      |
| ------------------ | --------- | ------------------------------------------------ |
| `track_name`       | VARCHAR   | Name of the track                                |
| `artist`           | VARCHAR   | Name of the primary artist                       |
| `album`            | VARCHAR   | Name of the album                                |
| `popularity`       | INT       | Popularity score (0-100)                         |
| `duration_minutes` | FLOAT     | Duration of the track in minutes                 |

---

## 🤝 Contribution

Contributions are welcome! Feel free to open an issue or submit a pull request.

---

**Author**: Jothi Ram CM
