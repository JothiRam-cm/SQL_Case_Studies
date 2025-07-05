# 🎵 Spotify Public Tracks Data - EDA using SQL and Python

## 📦 Project Overview

This project involves collecting Spotify public tracks data using the [Spotify Developer API](https://developer.spotify.com/documentation/web-api/) and performing Exploratory Data Analysis (EDA) using SQL and Python. The goal is to uncover patterns and insights from the collected music data.

---

## 🔧 Key Features

✅ Collected Spotify public tracks data using the Spotify Developer URL
✅ Stored the data in a structured format (e.g., Database or CSV)
✅ Performed detailed EDA using SQL queries
✅ Used Python for data extraction, processing, and interaction with the API
✅ Derived insights related to tracks, artists, albums, and popularity

---

## 📊 Tools & Technologies

* Spotify Developer API
* SQL (for querying and EDA)
* Python (for data collection and processing)

---

## 🗂️ Project Structure

```
spotify-sql-eda/
├── spotify_track_data.csv                  # Collected raw dataset
├── spotify_track_data_analysis.sql         # SQL scripts for EDA
├── data_to_db.py                           # Python scripts for API data collection
├── README.md                               # Project documentation
└── requirements.txt                        # Python dependencies
```

---

## 🚀 Getting Started

1. Clone the repository

   ```bash
   git clone https://github.com/JothiRam-cm/SQL_Case_Studies.git
   cd SQL_Case_Studies/Spotify_EDA

   ```

2. Install dependencies

   ```bash
   pip install -r requirements.txt
   ```

3. Collect Data

   * Run the Python script inside the `python_scripts/` folder to collect Spotify track data using the API.

4. Perform EDA

   * Use SQL queries inside the `sql_queries/` folder to explore and analyze the dataset.

---

## 📌 Insights Derived

* Most popular tracks and artists
* Album comparisons based on popularity
* Frequency of tracks across different albums
* Relationship between track popularity and other attributes (if applicable)

---

## 🔑 Requirements

* Valid Spotify Developer Account with API credentials
* Python 3.x installed
* SQL environment (e.g., MySQL, SQLite, PostgreSQL)

---

## 📚 References

* [Spotify Web API Documentation](https://developer.spotify.com/documentation/web-api/)
* [SQL Documentation (W3Schools)](https://www.w3schools.com/sql/)
* [Python Official Documentation](https://docs.python.org/3/)

---

## ✨ Future Improvements

* Automate periodic data collection
* Integrate with a database management system
* Expand analysis to include more attributes (e.g., audio features)

---

## 🤝 Contribution

Contributions and suggestions are welcome! Feel free to open an issue or submit a pull request.

---

Author: Jothi Ram CM
License: MIT
