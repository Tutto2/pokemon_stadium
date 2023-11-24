# Pokemon Battle Simulator

## Description
This project is a Pokemon battle simulator developed in Ruby. It allows players to create Pokemon teams and engage in exciting battles.

### Features
**Pokemon:** The pokemon folder contains the logic related to the object 'Pokemon', including their initialization, stats and characteristics.

**Pokedex:** This folder contains all the pokemons that have been created and allows to add new pokemon with all of their characteristics and moves

**Types:** Here is defined the type table and their interactions

**Moves:** The moves folder includes the implementation of moves that Pokemon can perform during battles. It has a 'concerns' folder with the logic related to special features of some moves

**Actions:** The actions folder manages the actions that players can take during a battle, including the action_queue.

**Trainer:** The trainer.rb file defines the Trainer class, representing each player in the game.

**Battleground:** The battleground.rb file is the main file that starts the game with the command battleground.init_game(a, b), where a is the number of players, and b is the list of Pokemon available for the battle.

## Requirements
Ruby (version 2.7.4)

## Instalation
1. Clone the repository: https://github.com/Tutto2/pokemon_stadium
2. Navigate to the project directory
3. Run the game initiation command: ruby battleground.rb

## Usage
Start the game with 2 players and a list of Pokemon
Battleground.init_game(2, [pokemons])

## Contribution
If you want to contribute to this project, follow these steps:

1. Fork the project.
2. Create a new branch (git checkout -b feature/new-feature).
3. Make your changes and commit (git commit -am 'Add new feature').
4. Push the branch (git push origin feature/new-feature).
5. Open a Pull Request.
