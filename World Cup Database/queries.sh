#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(GREATEST(winner_goals, opponent_goals)) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams FULL JOIN games ON teams.team_id = games.winner_id WHERE year=2018 AND round='Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT w.name FROM games g LEFT JOIN teams w ON g.winner_id = w.team_id WHERE g.year=2014 AND g.round='Eighth-Final' UNION SELECT o.name FROM games g LEFT JOIN teams o ON g.opponent_id = o.team_id WHERE g.year=2014 AND g.round='Eighth-Final'")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT(w.name) FROM games g LEFT JOIN teams w ON g.winner_id = w.team_id LEFT JOIN teams o ON g.opponent_id = o.team_id ORDER BY w.name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT g.year, w.name FROM games g LEFT JOIN teams w ON g.winner_id = w.team_id LEFT JOIN teams o ON g.opponent_id = o.team_id WHERE round='Final' ORDER BY w.name DESC")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"
