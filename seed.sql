-- seed.sql
-- Първи тестови данни

-- 1) Лига
INSERT INTO leagues (name, season) VALUES
('ITPG Varna League', '2025/2026');

-- 2) Отбори (4 отбора)
INSERT INTO teams (league_id, name, city, founded_year) VALUES
(1, 'Черноморец', 'Варна', 1920),
(1, 'Спартак', 'Варна', 1918),
(1, 'Добруджа', 'Добрич', 1919),
(1, 'Ботев', 'Шумен', 1921);

-- 3) Играчите (10 играчи)
-- Team 1: Черноморец
INSERT INTO players (team_id, first_name, last_name, shirt_no, position, birth_date) VALUES
(1, 'Иван', 'Петров', 1,  'GK', '2004-03-12'),
(1, 'Николай', 'Георгиев', 5, 'DF', '2003-11-20'),
(1, 'Даниел', 'Илиев', 10, 'MF', '2004-07-05');

-- Team 2: Спартак
INSERT INTO players (team_id, first_name, last_name, shirt_no, position, birth_date) VALUES
(2, 'Георги', 'Димитров', 9,  'FW', '2003-01-14'),
(2, 'Петър', 'Стоянов', 4,  'DF', '2004-09-02'),
(2, 'Алекс', 'Колев', 8,  'MF', '2003-06-30');

-- Team 3: Добруджа
INSERT INTO players (team_id, first_name, last_name, shirt_no, position, birth_date) VALUES
(3, 'Мартин', 'Николов', 7,  'FW', '2004-02-25'),
(3, 'Калин', 'Вълчев', 6,  'MF', '2003-12-10');

-- Team 4: Ботев
INSERT INTO players (team_id, first_name, last_name, shirt_no, position, birth_date) VALUES
(4, 'Стефан', 'Тодоров', 11, 'FW', '2003-05-19'),
(4, 'Борис', 'Христов', 2,  'DF', '2004-10-08');

-- 4) Мачове (2 мача)
-- Мач 1: изигран с резултат
INSERT INTO matches (league_id, match_date, stadium, home_team_id, away_team_id, status, home_goals, away_goals) VALUES
(1, '2026-02-10 18:00:00', 'Стадион Варна', 1, 2, 'played', 2, 1);

-- Мач 2: насрочен без резултат
INSERT INTO matches (league_id, match_date, stadium, home_team_id, away_team_id, status, home_goals, away_goals) VALUES
(1, '2026-02-20 17:30:00', 'Градски стадион', 3, 4, 'scheduled', NULL, NULL);

-- 5) Събития (поне 1 мач с резултат → добавяме голове и картони към мач 1)
-- В мач 1: Черноморец (team 1) срещу Спартак (team 2) 2:1
-- Гол: Даниел Илиев (player 3) 23'
INSERT INTO match_events (match_id, player_id, event_minute, event_type, card_type) VALUES
(1, 3, 23, 'GOAL', NULL);

-- Гол: Георги Димитров (player 4) 40'
INSERT INTO match_events (match_id, player_id, event_minute, event_type, card_type) VALUES
(1, 4, 40, 'GOAL', NULL);

-- Гол: Даниел Илиев (player 3) 78'
INSERT INTO match_events (match_id, player_id, event_minute, event_type, card_type) VALUES
(1, 3, 78, 'GOAL', NULL);

-- Картон: Николай Георгиев (player 2) 55' жълт
INSERT INTO match_events (match_id, player_id, event_minute, event_type, card_type) VALUES
(1, 2, 55, 'CARD', 'YELLOW');

-- Картон: Петър Стоянов (player 5) 88' червен
INSERT INTO match_events (match_id, player_id, event_minute, event_type, card_type) VALUES
(1, 5, 88, 'CARD', 'RED');
