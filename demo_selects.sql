-- demo_selects.sql
-- Тестови SELECT заявки (поне 5)

-- 1) Всички отбори в лигата
SELECT t.id, t.name, t.city, l.name AS league_name, l.season
FROM teams t
JOIN leagues l ON l.id = t.league_id
ORDER BY t.id;

-- 2) Играчите по отбор (пример: отбор id = 1)
SELECT p.id, p.first_name, p.last_name, p.shirt_no, p.position, t.name AS team
FROM players p
JOIN teams t ON t.id = p.team_id
WHERE t.id = 1
ORDER BY p.shirt_no;

-- 3) Всички мачове с имена на отборите и резултат (ако има)
SELECT m.id,
       l.name AS league,
       m.match_date,
       ht.name AS home_team,
       at.name AS away_team,
       m.status,
       m.home_goals,
       m.away_goals
FROM matches m
JOIN leagues l ON l.id = m.league_id
JOIN teams ht ON ht.id = m.home_team_id
JOIN teams at ON at.id = m.away_team_id
ORDER BY m.match_date;

-- 4) Справка за голове по играч (голмайстори)
SELECT p.first_name, p.last_name, t.name AS team, COUNT(*) AS goals
FROM match_events e
JOIN players p ON p.id = e.player_id
JOIN teams t ON t.id = p.team_id
WHERE e.event_type = 'GOAL'
GROUP BY p.first_name, p.last_name, t.name
ORDER BY goals DESC, p.last_name;

-- 5) Справка за картони по играч (жълти/червени)
SELECT p.first_name, p.last_name, t.name AS team,
       SUM(CASE WHEN e.card_type = 'YELLOW' THEN 1 ELSE 0 END) AS yellow_cards,
       SUM(CASE WHEN e.card_type = 'RED' THEN 1 ELSE 0 END) AS red_cards
FROM match_events e
JOIN players p ON p.id = e.player_id
JOIN teams t ON t.id = p.team_id
WHERE e.event_type = 'CARD'
GROUP BY p.first_name, p.last_name, t.name
ORDER BY red_cards DESC, yellow_cards DESC, p.last_name;

-- 6) (Бонус) Класиране (само изиграни мачове)
-- Точки: победа=3, равен=1, загуба=0
WITH played AS (
  SELECT league_id, home_team_id AS team_id, home_goals AS gf, away_goals AS ga
  FROM matches WHERE status = 'played'
  UNION ALL
  SELECT league_id, away_team_id AS team_id, away_goals AS gf, home_goals AS ga
  FROM matches WHERE status = 'played'
),
agg AS (
  SELECT league_id, team_id,
         COUNT(*) AS games,
         SUM(gf) AS goals_for,
         SUM(ga) AS goals_against,
         SUM(CASE WHEN gf > ga THEN 1 ELSE 0 END) AS wins,
         SUM(CASE WHEN gf = ga THEN 1 ELSE 0 END) AS draws,
         SUM(CASE WHEN gf < ga THEN 1 ELSE 0 END) AS losses,
         SUM(CASE WHEN gf > ga THEN 3 WHEN gf = ga THEN 1 ELSE 0 END) AS points
  FROM played
  GROUP BY league_id, team_id
)
SELECT t.name AS team,
       a.games, a.wins, a.draws, a.losses,
       a.goals_for, a.goals_against,
       (a.goals_for - a.goals_against) AS goal_diff,
       a.points
FROM agg a
JOIN teams t ON t.id = a.team_id
WHERE a.league_id = 1
ORDER BY a.points DESC, goal_diff DESC, t.name;
