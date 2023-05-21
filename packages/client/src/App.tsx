import { useComponentValue } from "@latticexyz/react";
import { getBurnerWallet } from "@latticexyz/std-client";
import { useMUD } from "./MUDContext";
import './App.css';
import { world } from "./mud/world";
import { ethers } from "ethers";
import { useEffect, useState } from "react";
import { Poker } from "./Poker";
import { useMount } from "ahooks";
import { URLSearchParams } from "./util";
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
    const [walletAddress, setWalletAddress] = useState('')
    const [isJoinedGame, setIsJoinedGame] = useState(false)
    const byte32GameId = ethers.utils.formatBytes32String(gameId);
    const gameEntity = world.registerEntity({ id: byte32GameId })
    const game = useComponentValue(Game, gameEntity);
    console.log('game-----')
    console.log(game)
    const createOrJoinGame = async () => {
        if (game && !game?.players.includes(walletAddress)) {
            await joinInGame(gameId)
        } else if (!game){
            await createGame(gameId)
        }
        setIsJoinedGame(true)
        window.location.href = `${window.location.href}&gameId=${gameId}`
    }
    useEffect(() => {
        if (game) {
            const joined = game?.players.includes(walletAddress)
            setIsJoinedGame(joined)
        } else {
            setIsJoinedGame(false)
        }
    }, [game, walletAddress])
    useMount(() => {
        const params = URLSearchParams();
        const gameId = params.get('gameId') || ''
        if (gameId) {
            setGameId(gameId)
        } else {
            setIsJoinedGame(false)
        }
        let privateKey = getBurnerWallet().value
        let wallet = new ethers.Wallet(privateKey);
        setWalletAddress(wallet.address.toLowerCase())
    })
    return (
    <>
        {
            isJoinedGame ? <Poker game={game}/> : <>
                <ul className={'game-warp'}>
                    <li>state: <span>{game?.state}({getGameState(game?.state)})</span></li>
                    <li>turn: <span>{game?.turn}</span></li>
                    <li>cardIndex: <span>{game?.cardIndex}</span></li>
                    {/*<li>winner: <span>{game?.winner}</span></li>*/}
                    {/*<li>cardsHash: <span>{game?.cardsHash}</span></li>*/}
                    <li>players: <span>{game?.players}</span></li>
                </ul>
                <div className={'form'}>
                    <input value={gameId} placeholder={'Please enter gameID'} onChange={(e: any) => {
                        setGameId(e.target.value || '')
                    }}/>
                    <button onClick={createOrJoinGame}>{game ? 'Join Game' : 'Create Game'}</button>
                </div>
            </>
        }
    </>
  );
};
