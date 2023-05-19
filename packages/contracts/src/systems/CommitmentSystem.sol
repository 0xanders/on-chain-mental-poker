// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Game, GameData } from "../codegen/tables/Game.sol";
import { GameState } from "../codegen/Types.sol";

contract CommitmentSystem is System {
  function make(bytes32 gameId) public {
    GameData gameData = Game.get(gameId);
    require(gameData.players.length == gameData.maxPlayers, "Game is not full");
    
  }
}
