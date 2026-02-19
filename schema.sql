-- schema.sql
-- Схема за управление на футболно първенство (PostgreSQL / стандартен SQL)

DROP TABLE IF EXISTS match_events;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS leagues;

CREATE TABLE leagues (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    season      VARCHAR(20)  NOT NULL,
    CONSTRAINT uq_league_name_season UNIQUE (name, season)
);

CREATE TABLE teams (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    league_id   INT NOT NULL,
    name        VARCHAR(100) NOT NULL,
    city        VARCHAR(100),
    founded_year INT,
    CONSTRAINT fk_teams_leagues
        FOREIGN KEY (league_id) REFERENCES leagues(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_team_in_league UNIQUE (league_id, name),
    CONSTRAINT chk_founded_year CHECK (founded_year IS NULL OR (founded_year BETWEEN 1850 AND 2100))
);

CREATE TABLE players (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    team_id     INT NOT NULL,
    first_name  VARCHAR(60) NOT NULL,
    last_name   VARCHAR(60) NOT NULL,
    shirt_no    INT NOT NULL,
    position    VARCHAR(20) NOT NULL,
    birth_date  DATE,
    CONSTRAINT fk_players_teams
        FOREIGN KEY (team_id) REFERENCES teams(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_shirt_no_per_team UNIQUE (team_id, shirt_no),
    CONSTRAINT chk_shirt_no CHECK (shirt_no BETWEEN 1 AND 99),
    CONSTRAINT chk_position CHECK (position IN ('GK','DF','MF','FW'))
);

CREATE TABLE matches (
    id            INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    league_id     INT NOT NULL,
    match_date    TIMESTAMP NOT NULL,
    stadium       VARCHAR(120),
    home_team_id  INT NOT NULL,
    away_team_id  INT NOT NULL,
    status        VARCHAR(12) NOT NULL DEFAULT 'scheduled',
    home_goals    INT,
    away_goals    INT,
    CONSTRAINT fk_matches_leagues
        FOREIGN KEY (league_id) REFERENCES leagues(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_matches_home_team
        FOREIGN KEY (home_team_id) REFERENCES teams(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_matches_away_team
        FOREIGN KEY (away_team_id) REFERENCES teams(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_home_away_different CHECK (home_team_id <> away_team_id),
    CONSTRAINT chk_match_status CHECK (status IN ('scheduled','played')),
    CONSTRAINT chk_goals_nonnegative CHECK (
        (home_goals IS NULL OR home_goals >= 0) AND
        (away_goals IS NULL OR away_goals >= 0)
    ),
    -- Ако мачът е 'played', резултатът трябва да е попълнен.
    CONSTRAINT chk_result_when_played CHECK (
        (status = 'scheduled' AND home_goals IS NULL AND away_goals IS NULL)
        OR
        (status = 'played' AND home_goals IS NOT NULL AND away_goals IS NOT NULL)
    )
);

CREATE TABLE match_events (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    match_id    INT NOT NULL,
    player_id   INT NOT NULL,
    event_minute INT NOT NULL,
    event_type  VARCHAR(10) NOT NULL,  -- 'GOAL' или 'CARD'
    card_type   VARCHAR(6),            -- 'YELLOW' или 'RED' (само при CARD)
    CONSTRAINT fk_events_matches
        FOREIGN KEY (match_id) REFERENCES matches(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_events_players
        FOREIGN KEY (player_id) REFERENCES players(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_event_minute CHECK (event_minute BETWEEN 0 AND 130),
    CONSTRAINT chk_event_type CHECK (event_type IN ('GOAL','CARD')),
    CONSTRAINT chk_card_type CHECK (
        (event_type = 'GOAL' AND card_type IS NULL)
        OR
        (event_type = 'CARD' AND card_type IN ('YELLOW','RED'))
    )
);
