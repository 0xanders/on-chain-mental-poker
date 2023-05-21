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
    const [leftPlayer, setLeftPlayer] = useState('')
    const [rightPlayer, setRightPlayer] = useState('')
    useEffect(() => {

    }, [walletAddress, props.game])
    return (
        <div className={'poker-warp'}>
            <div className={'poker-item poker-left'}>
                <span className={'poker-card'}>🂠</span>
                <span className={'poker-user'}>{substrWalletText4(leftPlayer)}</span>
            </div>
            <div className={'poker-item poker-right'}>
                <span className={'poker-card'}>🂠</span>
                <span className={'poker-user'}>{substrWalletText4(rightPlayer)}</span>
            </div>
            <div className={'poker-item poker-self'}>
                <span className={'poker-card'}>🂠</span>
                <span className={'poker-user'}>{substrWalletText4(walletAddress)}</span>
            </div>
        </div>
    );
};
