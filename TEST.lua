Player =  Player or require "Player"

player1 = Player:New()
print( player1 )

player2 = Player:New()
print( player2 )

--player1:CreateFSM()
--player2:CreateFSM()
print( "--------" )
print( player1.fsm )
print( player2.fsm )

print( "--------" )

print( player1.Turn )
print( player2.Turn )
player2:SetTurn( 1 )
print( player1.Turn )
print( player2.Turn )
player2.Turn = 0
print( player1.Turn )
print( player2.Turn )

print( "--------" )
player1:Update()

player1:Update()
player1:Update()

player2:Update()

player2:Update()

player2:Update()