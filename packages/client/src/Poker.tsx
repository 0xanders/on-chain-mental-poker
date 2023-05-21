import { useMUD } from "./MUDContext";
import { useMount } from "ahooks";
import { useEffect, useState } from "react";
import { substrWalletText4 } from "./util"
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
        wallet: ''
    })
    const [leftPlayer, setLeftPlayer] = useState({
        wallet: ''
    })
    const [rightPlayer, setRightPlayer] = useState({
        wallet: ''
    })
    useEffect(() => {
        setSelfPlayer({
            wallet: walletAddress
        })
        if (props.game.players) {
            const players = [...props.game.players]
            const idx = players.indexOf(walletAddress)
            players.splice(idx, 1)
            if (players.length >= 1) {
                setLeftPlayer({
                    wallet: players[0]
                })
                players.splice(0, 1)
            }
            if (players.length >= 1) {
                setRightPlayer({
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
                <span className={'poker-user'}>{leftPlayer.wallet ? substrWalletText4(leftPlayer.wallet) : '?'}</span>
            </div>
            <div className={'poker-item poker-right'}>
                <span className={'poker-card'}>🂠</span>
                <span className={'poker-user'}>{rightPlayer.wallet ? substrWalletText4(rightPlayer.wallet) : '?'}</span>
            </div>
            <div className={'poker-item poker-self'}>
                <span className={'poker-card'}>🂠</span>
                <span className={'poker-user'}>{selfPlayer.wallet ? substrWalletText4(selfPlayer.wallet) : '?'}</span>
            </div>
        </div>
    );
};
