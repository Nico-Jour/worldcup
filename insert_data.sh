#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
#insert teams into teams table and get their ids
then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
echo "winner_id:" $WINNER_ID

if [[ -z $WINNER_ID ]]
then
  INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  echo "insertWinnerResult" $INSERT_WINNER_RESULT

 WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
echo $WINNER_ID
fi

OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
echo "opponent_id:" $OPPONENT_ID

if [[ -z $OPPONENT_ID ]]
then
  INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  echo "insertOpponentResult" $INSERT_OPPONENT_RESULT

  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  echo $OPPONENT_ID
fi
#insert games into game table
echo $WINNER_ID $OPPONENT_ID
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into games, $WINNER_ID $OPPONENT_ID"
    fi
fi
done
