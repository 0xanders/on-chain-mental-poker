import { useComponentValue } from "@latticexyz/react";
import { useMUD } from "./MUDContext";
import { ethers } from "ethers";

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
          const byte32GameId = ethers.utils.formatBytes32String('100');
          console.log("new counter value:", await createGame(byte32GameId));
        }}>
          createGame
      </button>
    </>
  );
};
