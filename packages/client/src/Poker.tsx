import { useMUD } from "./MUDContext";
import { useMount } from "ahooks";
import { useEffect, useState } from "react";
import { GameState, substrWalletText4 } from "./util"
type Props = {
    game: {
        state: number
        turn: number
        cardIndex: number
        players: Array<string>
    }
};
export const Poker = (props: Props) => {
    const {walletAddress} = useMUD();
    const [selfPlayer, setSelfPlayer] = useState({
        wallet: '',
        state: GameState.Join
    })
    const [leftPlayer, setLeftPlayer] = useState({
        wallet: '',
        state: GameState.Join
    })
    const [rightPlayer, setRightPlayer] = useState({
        wallet: '',
        state: GameState.Join
    })
    useEffect(() => {
        setSelfPlayer({
            wallet: walletAddress,
            state: GameState.Join
        })
        if (props.game.players) {
            const players = [...props.game.players]
            const idx = players.indexOf(walletAddress)
            players.splice(idx, 1)
            if (players.length >= 1) {
                setLeftPlayer({
                    wallet: players[0],
                    state: GameState.Join
                })
                players.splice(0, 1)
            }
            if (players.length >= 1) {
                setRightPlayer({
                    wallet: players[0],
                    state: GameState.Join
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
                    leftPlayer.state === GameState.Shuffle && <span className={'btn-tool'}>Shuffle</span>
                }
                {
                    leftPlayer.state === GameState.DealCards && <span className={'btn-tool'}>DealCards</span>
                }
                {
                    leftPlayer.state === GameState.DecryptForOthers && <span className={'btn-tool'}>Decrypt</span>
                }
                {
                    leftPlayer.state === GameState.UploadSecret && <span className={'btn-tool'}>UploadSecret</span>
                }
                <span className={'poker-user'}>🧑‍🚒 {leftPlayer.wallet ? substrWalletText4(leftPlayer.wallet) : '?'}</span>
            </div>
            <div className={'poker-item poker-right'}>
                <span className={'poker-card'}>🂠</span>
                {
                    rightPlayer.state === GameState.Shuffle && <span className={'btn-tool'}>Shuffle</span>
                }
                {
                    rightPlayer.state === GameState.DealCards && <span className={'btn-tool'}>DealCards</span>
                }
                {
                    rightPlayer.state === GameState.DecryptForOthers && <span className={'btn-tool'}>Decrypt</span>
                }
                {
                    rightPlayer.state === GameState.UploadSecret && <span className={'btn-tool'}>UploadSecret</span>
                }
                <span className={'poker-user'}>👩‍🚀 {rightPlayer.wallet ? substrWalletText4(rightPlayer.wallet) : '?'}</span>
            </div>
            <div className={'poker-item poker-self'}>
                <span className={'poker-card'}>🂠</span>
                {
                    selfPlayer.state === GameState.Shuffle && <span className={'btn-tool'}>Shuffle</span>
                }
                {
                    selfPlayer.state === GameState.DealCards && <span className={'btn-tool'}>DealCards</span>
                }
                {
                    selfPlayer.state === GameState.DecryptForOthers && <span className={'btn-tool'}>Decrypt</span>
                }
                {
                    selfPlayer.state === GameState.UploadSecret && <span className={'btn-tool'}>UploadSecret</span>
                }
                <span className={'poker-user'}>👨‍🎨 {selfPlayer.wallet ? substrWalletText4(selfPlayer.wallet) : '?'}</span>
            </div>
        </div>
    );
};
