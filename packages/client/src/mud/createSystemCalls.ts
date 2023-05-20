import { getComponentValue } from "@latticexyz/recs";
import { awaitStreamValue } from "@latticexyz/utils";
import { ClientComponents } from "./createClientComponents";
import { SetupNetworkResult } from "./setupNetwork";
import {ethers} from "ethers";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  { worldSend, txReduced$, singletonEntity }: SetupNetworkResult,
  { Game }: ClientComponents
) {
  const createGame = async (gameId: string) => {
    // str to byte32
    const byte32Str = ethers.utils.formatBytes32String(gameId);
    const tx = await worldSend("createGame", [byte32Str]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(Game, singletonEntity);
  };
  const joinGame = async (gameId: string) => {
    // str to byte32
    const byte32Str = ethers.utils.formatBytes32String(gameId);
    const tx = await worldSend("joinInGame", [byte32Str]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(Game, singletonEntity);
  };
  return {
    createGame,
    joinGame
  };
}
