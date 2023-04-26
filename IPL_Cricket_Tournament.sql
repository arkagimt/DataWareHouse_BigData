CREATE DATABASE IPL_Cricket_Tournament;

USE IPL_Cricket_Tournament;

CREATE TABLE Matches_Facts (
    match_id INT PRIMARY KEY,
    team_id_1 INT,
    team_id_2 INT,
    winning_team_id INT,
    toss_winner_id INT,
    stadium_id INT,
    umpire_1_id INT,
    umpire_2_id INT,
    season_id INT,
    date_id INT,
    total_runs_scored INT,
    total_wickets_taken INT,
    player_of_match_id INT,
    FOREIGN KEY (team_id_1) REFERENCES Teams(team_id),
    FOREIGN KEY (team_id_2) REFERENCES Teams(team_id),
    FOREIGN KEY (winning_team_id) REFERENCES Teams(team_id),
    FOREIGN KEY (toss_winner_id) REFERENCES Teams(team_id),
    FOREIGN KEY (stadium_id) REFERENCES Stadiums(stadium_id),
    FOREIGN KEY (umpire_1_id) REFERENCES Umpires(umpire_id),
    FOREIGN KEY (umpire_2_id) REFERENCES Umpires(umpire_id),
    FOREIGN KEY (season_id) REFERENCES Seasons(season_id),
    FOREIGN KEY (date_id) REFERENCES Date(date_id),
    FOREIGN KEY (player_of_match_id) REFERENCES Players(player_id)
);

CREATE TABLE Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(255),
    team_city VARCHAR(255)
);

CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(255),
    date_of_birth DATE,
    nationality VARCHAR(255),
    batting_style VARCHAR(255),
    bowling_style VARCHAR(255)
);

CREATE TABLE Stadiums (
    stadium_id INT PRIMARY KEY,
    stadium_name VARCHAR(255),
    city VARCHAR(255),
    capacity INT
);

CREATE TABLE Umpires (
    umpire_id INT PRIMARY KEY,
    umpire_name VARCHAR(255),
    nationality VARCHAR(255)
);

CREATE TABLE Seasons (
    season_id INT PRIMARY KEY,
    year INT
);

CREATE TABLE Date (
    date_id INT PRIMARY KEY,
    date DATE,
    day INT,
    month INT,
    year INT,
    day_of_week VARCHAR(255)
);



