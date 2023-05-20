import { useComponentValue } from "@latticexyz/react";
import { getBurnerWallet } from "@latticexyz/std-client";
import { useMUD } from "./MUDContext";
import './App.css';
import { world } from "./mud/world";
import {ethers} from "ethers";
import { Poker } from "./Poker";
enum GameState {
    Join,
    Shuffle,
    DealCards,
    DecryptForOthers,
    UploadSecret,
    Error,
    Finished
}
const getGameState = (state: number) => {
    switch (state) {
        case GameState.Join:
            return 'Join'
        case GameState.Shuffle:
            return 'Shuffle'
        case GameState.DealCards:
            return 'DealCards'
        case GameState.DecryptForOthers:
            return 'DecryptForOthers'
        case GameState.UploadSecret:
            return 'UploadSecret'
        case GameState.Error:
            return 'Error'
        case GameState.Finished:
            return 'Finished'
        return 'Join'
    }
}
export const App = () => {
    const {components: { Game }, systemCalls: { createGame, joinInGame }} = useMUD();
    const [gameId, setGameId] = useState('')
    const [isGameing, setIsGameing] = useState(false)
    const byte32GameId = ethers.utils.formatBytes32String(gameId);
    const gameEntity = world.registerEntity({ id: byte32GameId })
    const game = useComponentValue(Game, gameEntity);
    console.log('game-----')
    console.log(game)
    const createOrJoinGame = async () => {
      if (game) {
          await joinInGame(gameId)
      } else {
          await createGame(gameId)
      }
      window.location.href = `${window.location.href}&gameId=${gameId}`
    }
    useEffect(() => {
        const params = new URLSearchParams(window.location.search);
        if (params?.gameId) {
            setGameId(params?.gameId)
            setIsGameing(true)
        }
        setIsGameing(false)
        getBurnerWallet()
    }, [window.location.search])
    return (
    <>
        {
            isGameing ? <Poker game={game}/> : <>
                <ul className={'game-warp'}>
                    <li>state: <span>{game?.state}({getGameState(game?.state)})</span></li>
                    <li>turn: <span>{game?.turn}</span></li>
                    <li>cardIndex: <span>{game?.cardIndex}</span></li>
                    {/*<li>winner: <span>{game?.winner}</span></li>*/}
                    {/*<li>cardsHash: <span>{game?.cardsHash}</span></li>*/}
                    <li>players: <span>{game?.players}</span></li>
                </ul>
                <div className={'form'}>
                    <input placeholder={'Please enter gameID'} onChange={(e: any) => {
                        setGameId(e.target.value || '')
                    }}/>
                    <button onClick={createOrJoinGame}>{game ? 'Join Game' : 'Create Game'}</button>
                </div>
            </>
        }
    </>
  );
};
