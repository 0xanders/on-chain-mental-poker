import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  enums: {
    GameState: ["Join","Shuffle", "DealCards","DecryptForOthers", "UploadSecret","Error","Finished"],
  },

  tables: {
    Game: {
      dataStruct: true,
      keySchema: {
        id: "bytes32",
      },
      schema: {
        state: "GameState",
        maxPlayers: "uint256",
        players: "address[]",
        turn: "uint8",
        cardsHash: "bytes32[52]",
        cardIndex:"uint8",
        winner:"address"
      },
    },
    Commitment: {
      keySchema: {
        gameId: "uint256",
        player: "address"
      },
      schema: {
        msgToSign: "bytes32",
        resultOfSign: "bytes32",
        key: "bytes32"
      },
    },
    
    HandCard: {
      keySchema: {
        gameId: "uint256",
        player: "address"
      },
      schema: {
        tempCardHash:"bytes32",
        cardHash: "bytes32",
        card:"uint32"
      },
    }

  },
});
