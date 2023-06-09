/* Autogenerated file. Do not edit manually. */

import { TableId } from "@latticexyz/utils";
import { defineComponent, Type as RecsType, World } from "@latticexyz/recs";

export function defineContractComponents(world: World) {
  return {
    Game: (() => {
      const tableId = new TableId("", "Game");
      return defineComponent(
        world,
        {
          state: RecsType.Number,
          maxPlayers: RecsType.BigInt,
          turn: RecsType.Number,
          cardIndex: RecsType.Number,
          winner: RecsType.String,
          cardsHash: RecsType.StringArray,
          players: RecsType.StringArray,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    Commitment: (() => {
      const tableId = new TableId("", "Commitment");
      return defineComponent(
        world,
        {
          msgToSign: RecsType.String,
          resultOfSign: RecsType.String,
          key: RecsType.String,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
    HandCard: (() => {
      const tableId = new TableId("", "HandCard");
      return defineComponent(
        world,
        {
          tempCardHash: RecsType.String,
          cardHash: RecsType.String,
          card: RecsType.String,
        },
        {
          metadata: {
            contractId: tableId.toHexString(),
            tableId: tableId.toString(),
          },
        }
      );
    })(),
  };
}
