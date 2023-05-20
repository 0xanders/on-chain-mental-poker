import { useComponentValue } from "@latticexyz/react";
import { useMUD } from "./MUDContext";

export const App = () => {
  const {
    components: { Game },
    systemCalls: { createGame },
    network: { singletonEntity },
  } = useMUD();

  const game = useComponentValue(Game, singletonEntity);
  console.log('game-----')
  console.log(game)
  return (
    <>
      <div>
        Counter: <span>{game?.cardHash}</span>
      </div>
      <button
        type="button"
        onClick={async (event) => {
          event.preventDefault();
          console.log("new counter value:", await createGame('100'));
        }}>
          createGame
      </button>
    </>
  );
};
