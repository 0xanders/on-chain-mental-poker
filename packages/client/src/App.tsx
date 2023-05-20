import { useComponentValue } from "@latticexyz/react";
import { useMUD } from "./MUDContext";
import './app.css';
export const App = () => {
  const {
    components: { Game },
    systemCalls: { createGame, joinGame },
    network: { singletonEntity },
  } = useMUD();

  const game = useComponentValue(Game, singletonEntity);
  console.log('game-----')
  console.log(game)
  return (
    <>
      <div>
          gameState: <span>{game?.state}</span>
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
            // await createGame('100')
            await joinGame('100')
        }}>
          createGame
      </button>
    </>
  );
};
