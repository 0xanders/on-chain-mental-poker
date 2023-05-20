import { useComponentValue } from "@latticexyz/react";
import { useMUD } from "./MUDContext";
import './app.scss';
import { world } from "./mud/world";
import {ethers} from "ethers";
export const App = () => {
  const {
    components: { Game },
    systemCalls: { createGame, joinInGame },
    network,
  } = useMUD();
  const byte32GameId = ethers.utils.formatBytes32String('100');
  const gameEntity = world.registerEntity({ id: byte32GameId })
  const game = useComponentValue(Game, gameEntity);
  console.log('game-----')
  console.log(game)
  return (
    <>
      <div>
          gameState: <span>{game?.state}</span>
          singletonEntity: <span></span>
      </div>
        <div className={'form'}>
            <input placeholder={'Please enter gameID'}/>
            <div className={'button-warp'}>
                <button>Create Game</button>
                <button>Join Game</button>
            </div>
        </div>
      <button
        type="button"
        onClick={async (event) => {
          event.preventDefault();
            await createGame('100')
            // await joinInGame('100')
        }}>
          createGame
      </button>
    </>
  );
};
