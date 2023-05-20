import { useComponentValue } from "@latticexyz/react";
import { useMUD } from "./MUDContext";
import './app.css';
import { world } from "./mud/world";
import {ethers} from "ethers";
import {useState} from "react";
export const App = () => {
  const {
    components: { Game },
    systemCalls: { createGame, joinInGame },
    network,
  } = useMUD();
  const [gameId, setGameId] = useState('')
  const byte32GameId = ethers.utils.formatBytes32String(gameId);
  const gameEntity = world.registerEntity({ id: byte32GameId })
  const game = useComponentValue(Game, gameEntity);
  console.log('game-----')
  console.log(game)
  const createOrJoinGame = () => {
      if (game) {
          joinInGame(gameId)
      } else {
          createGame(gameId)
      }
  }
  return (
    <>
      <div>
          gameState: <span>{game?.state}</span>
          singletonEntity: <span></span>
      </div>
        <div className={'form'}>
            <input placeholder={'Please enter gameID'} onChange={(e: any) => {
                setGameId(e.target.value || '')
            }}/>
            <div className={'button-warp'} onClick={createOrJoinGame}>
                <button>{game ? 'Join Game' : 'Create Game'}</button>
            </div>
        </div>
    </>
  );
};
