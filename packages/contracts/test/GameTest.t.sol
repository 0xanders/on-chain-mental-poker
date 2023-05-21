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
    

    vm.startPrank(Alice);
    cardsHash = Game.getCardsHash(world, gameId); // get Current cardsHash from world
    for (uint i = 0; i < cardsHash.length; i++) {
      // shuffle is not done here, the client should to the shuffle works 
      cardsHash[i] = world.rc4EncryptBytes32(cardsHash[i], secretKey_Alice); // encrypt cardsHash with secretKey
    }
    resultOfSign = world.rc4EncryptBytes32(msgToSign, secretKey_Alice);
    world.shuffleAndSave(gameId, msgToSign, resultOfSign, cardsHash);
    vm.stopPrank();

    vm.startPrank(Bob);
    cardsHash = Game.getCardsHash(world, gameId); // get Current cardsHash from world
    for (uint i = 0; i < cardsHash.length; i++) {
      cardsHash[i] = world.rc4EncryptBytes32(cardsHash[i], secretKey_Bob); // encrypt cardsHash with secretKey
    }

    resultOfSign = world.rc4EncryptBytes32(msgToSign, secretKey_Bob);
    world.shuffleAndSave(gameId, msgToSign, resultOfSign, cardsHash);
    vm.stopPrank();

    vm.startPrank(Carl);
    cardsHash = Game.getCardsHash(world, gameId); // get Current cardsHash from world
    for (uint i = 0; i < cardsHash.length; i++) {
      cardsHash[i] = world.rc4EncryptBytes32(cardsHash[i], secretKey_Carl); // encrypt cardsHash with secretKey
    }
    resultOfSign = world.rc4EncryptBytes32(msgToSign, secretKey_Carl);
    world.shuffleAndSave(gameId, msgToSign, resultOfSign, cardsHash);
    vm.stopPrank();

    assertTrue(Game.getState(world, gameId) == GameState.DealCards, "current game state should  be DealCards");


    // ----- dealCards
    vm.startPrank(Alice);
    world.dealCards(gameId);
    vm.stopPrank();

    vm.startPrank(Bob);
    world.dealCards(gameId);
    vm.stopPrank();

    vm.startPrank(Carl);
    world.dealCards(gameId);
    vm.stopPrank();


    assertTrue(Game.getState(world, gameId) == GameState.DecryptForOthers, "current game state should  be DecryptForOthers");

    // ----  decryptCard for others
    address[] memory others = new address[](2);
    bytes32[] memory tempCardsHash = new bytes32[](2);

    // Alice 
    vm.startPrank(Alice);
    others[0] = Bob;
    others[1] = Carl;
    
    tempCardsHash[0] = HandCard.getTempCardHash(world, gameId, Bob);
    tempCardsHash[1] = HandCard.getTempCardHash(world, gameId, Carl);
    
    tempCardsHash[0] = world.rc4EncryptBytes32(tempCardsHash[0], secretKey_Alice);
    tempCardsHash[1] = world.rc4EncryptBytes32(tempCardsHash[1], secretKey_Alice);

    world.decryptCard(gameId,others, tempCardsHash);
    vm.stopPrank();

    
    // Bob
    vm.startPrank(Bob);
    others[0] = Alice;
    others[1] = Carl;
    
    tempCardsHash[0] = HandCard.getTempCardHash(world, gameId, Alice);
    tempCardsHash[1] = HandCard.getTempCardHash(world, gameId, Carl);
    
    tempCardsHash[0] = world.rc4EncryptBytes32(tempCardsHash[0], secretKey_Bob);
    tempCardsHash[1] = world.rc4EncryptBytes32(tempCardsHash[1], secretKey_Bob);

    world.decryptCard(gameId,others, tempCardsHash);
    vm.stopPrank();

    // Carl
    vm.startPrank(Carl);
    others[0] = Alice;
    others[1] = Bob;
    
    tempCardsHash[0] = HandCard.getTempCardHash(world, gameId, Alice);
    tempCardsHash[1] = HandCard.getTempCardHash(world, gameId, Bob);
    
    tempCardsHash[0] = world.rc4EncryptBytes32(tempCardsHash[0], secretKey_Carl);
    tempCardsHash[1] = world.rc4EncryptBytes32(tempCardsHash[1], secretKey_Carl);

    world.decryptCard(gameId,others, tempCardsHash);
    vm.stopPrank();
    
    assertTrue(Game.getState(world, gameId) == GameState.UploadSecret, "current game state should  be UploadSecret");

    
    vm.startPrank(Alice);
    world.uploadSecretKey(gameId,secretKey_Alice);
    vm.stopPrank(); 

    vm.startPrank(Bob);
    world.uploadSecretKey(gameId,secretKey_Bob);
    vm.stopPrank(); 

    vm.startPrank(Carl);
    world.uploadSecretKey(gameId,secretKey_Carl);
    vm.stopPrank();
    
    assertTrue(Game.getState(world, gameId) == GameState.Finished, "current game state should be Finished");    
  }
}
