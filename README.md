# Dark Souls TXT

Dark Souls TXT is a minimalist game running through the command line. 

You're an undead who has to find the Moonlight Greatsword to be able to kill Artorias.

## Getting started

```ruby darksouls_txt.rb```

By default the game will be launch with 10 rooms. You can specify the number of room to generate:

```ruby darksouls_txt.rb 15```

The number of room has to be between 5 and 500.

## Game logic

When you launch the game, a dungeon with linked rooms is randomly generated. One room has a weapon inside and another has the boss.

The goal of the game is simply to kill the boss.

### Move

Simply write the desired direction. Possible directions are automatically suggested. Rooms that you did not visit are displayed this way: ```[ x ]```

### Run

When you meet the boss, you have either the choice to run or to fight. 

If you run, you have 1/3 chance to escape. If you fail, it's game over.

### Fight

If you fight the boss without a weapon, you have 1/2 chance to kill him. If you fail, it's a game over.

With the weapon, you kill him for sure and the game is won.
