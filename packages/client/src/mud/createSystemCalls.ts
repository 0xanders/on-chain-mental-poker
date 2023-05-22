import { getComponentValue } from "@latticexyz/recs";
import { awaitStreamValue } from "@latticexyz/utils";
import { ClientComponents } from "./createClientComponents";
import { SetupNetworkResult } from "./setupNetwork";
import {ethers} from "ethers";
import { world } from "./world";
export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  { worldSend, txReduced$, singletonEntity }: SetupNetworkResult,
  { Game }: ClientComponents
) {
  const createGame = async (gameId: string) => {
    const byte32GameId = ethers.utils.formatBytes32String(gameId);
    const gameEntity = world.registerEntity({ id: byte32GameId })
    const tx = await worldSend("createGame", [byte32GameId]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(Game, gameEntity);
  };
  const joinInGame = async (gameId: string) => {
    const byte32GameId = ethers.utils.formatBytes32String(gameId);
    const gameEntity = world.registerEntity({ id: byte32GameId })
    const tx = await worldSend("joinInGame", [byte32GameId]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(Game, gameEntity);
  };
  const shuffleAndSave = async (gameId: string, msgToSign: string, resultOfSign: string, cardsHash: Array<string>) => {
    const byte32GameId = ethers.utils.formatBytes32String(gameId);
    const gameEntity = world.registerEntity({ id: byte32GameId })
    const tx = await worldSend("shuffleAndSave", [byte32GameId, msgToSign, resultOfSign, cardsHash]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(Game, gameEntity);
  };
  const dealCards = async (gameId: string) => {
    const byte32GameId = ethers.utils.formatBytes32String(gameId);
    const gameEntity = world.registerEntity({ id: byte32GameId })
    const tx = await worldSend("dealCards", [byte32GameId]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(Game, gameEntity);
  };
  const decryptForOthers = async (gameId: string, others: Array<string>, tempCardsHash: Array<string>) => {
    const byte32GameId = ethers.utils.formatBytes32String(gameId);
    const gameEntity = world.registerEntity({ id: byte32GameId })
    const tx = await worldSend("dealCards", [byte32GameId, others, tempCardsHash]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
    return getComponentValue(Game, gameEntity);
  };
  return {
    createGame,
    joinInGame,
    shuffleAndSave,
    dealCards,
    decryptForOthers
  };
}
