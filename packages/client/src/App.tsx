import { useComponentValue } from "@latticexyz/react";
import { useMUD } from "./MUDContext";
import './App.css';
import { world } from "./mud/world";
import { ethers } from "ethers";
import { useEffect, useState } from "react";
import { Poker } from "./Poker";
import { useMount } from "ahooks";
import { GameState, URLSearchParams } from "./util";
import { SyncState } from "@latticexyz/network";
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
        default:
            return 'Create'
    }
}
const playerNames = ['Alice', 'Bob', 'Carl']
export const App = () => {
    const { walletAddress, components: { Game, LoadingState }, network: { singletonEntity }, systemCalls: { createGame, joinInGame } } = useMUD();
    const [gameId, setGameId] = useState('')
    const [errorTip, setErrorTips] = useState('');
    const [isJoinedGame, setIsJoinedGame] = useState(false)
    const byte32GameId = ethers.utils.formatBytes32String(gameId);
    const gameEntity = world.registerEntity({ id: byte32GameId })
    const game = useComponentValue(Game, gameEntity);
    console.log('game-----')
    console.log(game)
    const loadingState = useComponentValue(LoadingState, singletonEntity, {
        state: SyncState.CONNECTING,
        msg: 'Connecting',
        percentage: 0,
    })
    const createOrJoinGame = async () => {
        try {
            if (game && !game?.players.includes(walletAddress)) {
                await joinInGame(gameId)
            } else if (!game) {
                await createGame(gameId)
            }
            setIsJoinedGame(true)
            const params = URLSearchParams();
            const urlGameId = params.get('gameId') || ''
            const worldAddress = params.get('worldAddress') || ''
            const rpc = params.get('rpc') || ''
            const wsRpc = params.get('wsRpc') || ''
            if (!urlGameId) {
                window.location.href = `${window.location.origin}/?dev=true&worldAddress=${worldAddress}&rpc=${rpc}&wsRpc=${wsRpc}&gameId=${gameId}`
            }
        } catch (error) {
            console.log(error)
            if (game && !game?.players.includes(walletAddress)) {
                setErrorTips('The game has already started, cannot continue to join')
            } else if (!game) {
                setErrorTips('The game has already created, cannot continue to create')
            }
            const st = setTimeout(() => {
                clearTimeout(st)
                setErrorTips('')
            }, 3000)
        }
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
    })
    return (
        <div className={'app'}>
            <div className={'game-warp'}>
                <span>State: <span>{getGameState(game?.state)}</span></span>
                <span>Wallet: <span>{walletAddress}</span></span>
            </div>
            {
                isJoinedGame ? <Poker game={game} gameId={gameId} /> : <>
                    <div className={'form-warp'}>
                        <div className={'form'}>
                            <input value={gameId} placeholder={'Please enter gameID'} onChange={(e: any) => {
                                setGameId(e.target.value || '')
                            }} />
                            <button onClick={createOrJoinGame}>{game ? 'Join Game' : 'Create Game'}</button>
                            {
                                errorTip && <span className={'error-tips'}>{errorTip}</span>
                            }
                        </div>
                    </div>
                </>
            }
        </div>
    );
};
