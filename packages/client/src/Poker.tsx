import { useMUD } from "./MUDContext";
import { useMount } from "ahooks";
import { useEffect, useState } from "react";
import { GameState, CARDS, getKey, substrWalletText4 } from "./util";
type Props = {
    game: {
        state: number
        turn: number
        cardIndex: number
        players: Array<string>
        cardArr: Array<string>
    }
};
export const Poker = (props: Props) => {
    const {walletAddress, systemCalls: { shuffleAndSave }} = useMUD();
    const [selfPlayer, setSelfPlayer] = useState({
        turnIdx: 0,
        wallet: ''
    })
    const [leftPlayer, setLeftPlayer] = useState({
        turnIdx: 1,
        wallet: ''
    })
    const [rightPlayer, setRightPlayer] = useState({
        turnIdx: 2,
        wallet: ''
    })
    const clickTool = (type: string) => {
        if (type === 'Shuffle') {
            // let cardArr = [...CARDS]
            // if (props.game.turn !== 0) {
            //     cardArr = [...props.game.cardArr]
            // }
            // cardArr = encryptArray(cardArr, getKey())
            // cardArr = randowArray(cardArr)
            // shuffleAndSave('gameId', 'msgToSign', 'resultOfSign', cardArr)
        }
    }
    useEffect(() => {
        setSelfPlayer({
            turnIdx: 0,
            wallet: walletAddress
        })
        if (props.game.players) {
            const players = [...props.game.players]
            const idx = players.indexOf(walletAddress)
            players.splice(idx, 1)
            if (players.length >= 1) {
                setLeftPlayer({
                    turnIdx: 1,
                    wallet: players[0]
                })
                players.splice(0, 1)
            }
            if (players.length >= 1) {
                setRightPlayer({
                    turnIdx: 2,
                    wallet: players[0]
                })
                players.splice(0, 1)
            }
        }
    }, [walletAddress, props.game])
    return (
        <div className={'poker-warp'}>
            <div className={'poker-item poker-left'}>
                <span className={'poker-card'}>🂠</span>
                {
                    props.game.state === GameState.Shuffle &&
                    <span className={`btn-tool ${props.game.turn === leftPlayer.turnIdx ? '' : 'disable'}`}
                       onClick={() => {
                           clickTool('Shuffle')
                       }}>Shuffle</span>
                }
                <span className={'poker-user'}>{leftPlayer.wallet ? substrWalletText4(leftPlayer.wallet) : '?'}</span>
            </div>
            <div className={'poker-item poker-right'}>
                <span className={'poker-card'}>🂠</span>
                {
                    props.game.state === GameState.Shuffle &&
                    <span className={`btn-tool ${props.game.turn === rightPlayer.turnIdx ? '' : 'disable'}`}
                          onClick={() => {
                              clickTool('Shuffle')
                          }}>Shuffle</span>
                }
                <span className={'poker-user'}>{rightPlayer.wallet ? substrWalletText4(rightPlayer.wallet) : '?'}</span>
            </div>
            <div className={'poker-item poker-self'}>
                <span className={'poker-card'}>🂠</span>
                {
                    props.game.state === GameState.Shuffle &&
                    <span className={`btn-tool ${props.game.turn === selfPlayer.turnIdx ? '' : 'disable'}`}
                          onClick={() => {
                              clickTool('Shuffle')
                          }}>Shuffle</span>
                }
                <span className={'poker-user'}>YOU</span>
            </div>
        </div>
    );
};
