#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games,teams" )
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != winner  ]]
then
# select team_id from the teams table for winner  
TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
TEAM_ID_2=$($PSQL "select team_id from teams where name='$OPPONENT'")
# if not found 
  if [[ -z $TEAM_ID ]]
  then
  # insert this winner team into the teams table
  INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
  # if insert is done , echo the team name
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
    echo inserted into teams , $WINNER
    fi
  fi
fi
# for opponent teams , if not found
if [[ -z $TEAM_ID_2 ]]
then
if [[ $OPPONENT != opponent ]]
then
# insert this opponent team into the teams table
INSERT_TEAM_RESULT_2=$($PSQL "insert into teams(name) values('$OPPONENT')")
# if insert is done , echo the opponent 
    if [[ $INSERT_TEAM_RESULT_2 == "INSERT 0 1" ]]
    then
    echo inserted into teams , $OPPONENT
    fi
fi
fi
done
# for the games table 
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR,'$ROUND','$WINNER_ID','$OPPONENT_ID',$WINNER_GOALS,$OPPONENT_GOALS)")
if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
then
echo "inserted into games , $YEAR $ROUND $WINNER"
fi
done