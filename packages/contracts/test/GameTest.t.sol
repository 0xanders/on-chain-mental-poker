// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import { MudV2Test } from "@latticexyz/std-contracts/src/test/MudV2Test.t.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { Game, GameData } from "../src/codegen/tables/Game.sol";
import { Commitment, CommitmentData } from "../src/codegen/tables/Commitment.sol";
import { HandCard, HandCardData } from "../src/codegen/tables/HandCard.sol";
import { GameState } from "../src/codegen/Types.sol";

contract GameTest is MudV2Test {
  IWorld public world;
  address public Alice = address(0x001);
  address public Bob = address(0x002);
  address public Carl = address(0x003);

  function setUp() public override {
    super.setUp();
    world = IWorld(worldAddress);
  }

  function testWorldExists() public {
    uint256 codeSize;
    address addr = worldAddress;
    assembly {
      codeSize := extcodesize(addr)
    }
    assertTrue(codeSize > 0);
  }

  function testCreateGame() public {
    vm.startPrank(Alice);
    bytes32 gameId = bytes32("0x1");
    world.createGame(gameId);

    // assertEq(Game.getState(world, gameId), GameState.Join);

    vm.expectRevert("Invalid Player");
    world.joinInGame(gameId);
    vm.stopPrank();

    vm.startPrank(Bob);
    world.joinInGame(gameId);
    vm.stopPrank();

    vm.startPrank(Carl);
    world.joinInGame(gameId);
    vm.stopPrank();

    // assertEq(Game.getState(world, gameId), GameState.Shuffle);

    address[] memory players = Game.getPlayers(world, gameId);
    assertEq(players[0], Alice);
    assertEq(players[1], Bob);
    assertEq(players[2], Carl);

    //----------GameState.Shuffle--------
    bytes32 msgToSign = "0xPoker";
    bytes32 resultOfSign;
    bytes32 secretKey_Alice = "0xAlice";
    bytes32 secretKey_Bob = "0xBob";
    bytes32 secretKey_Carl = "0xCarl";
    bytes32[52] memory cardsHash;
    bytes32[52] memory cards = world.getCards();

    vm.startPrank(Alice);
    for (uint i = 0; i < cards.length; i++) {
      cardsHash[i] = world.rc4EncryptBytes32(cards[i], secretKey_Alice);
    }
    resultOfSign = world.rc4EncryptBytes32(msgToSign, secretKey_Alice);
    world.shuffleAndSave(gameId, msgToSign, resultOfSign, cardsHash);
    vm.stopPrank();

    vm.startPrank(Bob);
    for (uint i = 0; i < cardsHash.length; i++) {
      cardsHash[i] = world.rc4EncryptBytes32(cardsHash[i], secretKey_Bob);
    }

    resultOfSign = world.rc4EncryptBytes32(msgToSign, secretKey_Bob);
    world.shuffleAndSave(gameId, msgToSign, resultOfSign, cardsHash);
    vm.stopPrank();

    vm.startPrank(Carl);
    for (uint i = 0; i < cardsHash.length; i++) {
      cardsHash[i] = world.rc4EncryptBytes32(cardsHash[i], secretKey_Carl);
    }
    resultOfSign = world.rc4EncryptBytes32(msgToSign, secretKey_Carl);
    world.shuffleAndSave(gameId, msgToSign, resultOfSign, cardsHash);
    vm.stopPrank();
  }
}
