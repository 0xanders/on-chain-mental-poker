import { useMUD } from "./MUDContext";
import { useComponentValue } from "@latticexyz/react";
import { useMount } from "ahooks";
import { useEffect, useState } from "react";
import { GameState, getSecretKey, encryptArray, randowArray, substrWalletText4 } from "./util";
import { encrypt } from "./rc4";
import { ethers } from "ethers";
import { world } from "./mud/world";
type Props = {
    gameId: string,
    game: {
        state: number
        turn: number
        cardIndex: number
        players: Array<string>
        cardsHash: Array<string>
    }
};
export const Poker = (props: Props) => {
    const {walletAddress, components: { HandCard }, systemCalls: { shuffleAndSave }} = useMUD();
    const byte32GameId = ethers.utils.formatBytes32String(props.gameId);
    const encodedData = ethers.utils.solidityPack(['bytes32', 'address'], [byte32GameId, walletAddress]);
    const handCardId = ethers.utils.keccak256(encodedData);
    const handCardEntity = world.registerEntity({ id: handCardId });
    const handCard = useComponentValue(HandCard, handCardEntity);
    console.log('handCard-----')
    console.log(handCard)
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
    const clickTool = () => {
        debugger
        if (props.game.state === GameState.Shuffle) {
            let cardArr = [...props.game.cardsHash];
            const secretKey = getSecretKey();
            // cardArr = encryptArray(cardArr, secretKey);
            // cardArr = randowArray(cardArr);
            const msgToSign = "0xPoker";
            const resultOfSign = encrypt(msgToSign, secretKey) as string;
            shuffleAndSave(props.gameId, msgToSign, resultOfSign, cardArr)
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
                    props.game.state !== GameState.Join &&
                    <span className={`btn-tool disable`} onClick={clickTool}>
                        {
                             props.game.state === GameState.Shuffle && <>Shuffle</>
                        }
                        {
                             props.game.state === GameState.DealCards && <>DealCards</>
                        }
                        {
                             props.game.state === GameState.DecryptForOthers && <>DecryptForOthers</>
                        }
                        {
                             props.game.state === GameState.UploadSecret && <>UploadSecret</>
                        }
                       </span>
                }
                <span className={'poker-user'}>{leftPlayer.wallet ? substrWalletText4(leftPlayer.wallet) : '?'}</span>
            </div>
            <div className={'poker-item poker-right'}>
                <span className={'poker-card'}>🂠</span>
                {
                    props.game.state !== GameState.Join &&
                    <span className={`btn-tool disable`} onClick={clickTool}>
                        {
                             props.game.state === GameState.Shuffle && <>Shuffle</>
                        }
                        {
                             props.game.state === GameState.DealCards && <>DealCards</>
                        }
                        {
                             props.game.state === GameState.DecryptForOthers && <>DecryptForOthers</>
                        }
                        {
                             props.game.state === GameState.UploadSecret && <>UploadSecret</>
                        }
                       </span>
                }
                <span className={'poker-user'}>{rightPlayer.wallet ? substrWalletText4(rightPlayer.wallet) : '?'}</span>
            </div>
            <div className={'poker-item poker-self'}>
                <span className={'poker-card'}>🂠</span>
                {
                    props.game.state !== GameState.Join &&
                    <span className={`btn-tool ${props.game.turn === selfPlayer.turnIdx ? '' : 'disable'}`} onClick={clickTool}>
                        {
                             props.game.state === GameState.Shuffle && <>Shuffle</>
                        }
                        {
                             props.game.state === GameState.DealCards && <>DealCards</>
                        }
                        {
                             props.game.state === GameState.DecryptForOthers && <>DecryptForOthers</>
                        }
                        {
                             props.game.state === GameState.UploadSecret && <>UploadSecret</>
                        }
                       </span>
                }
                <span className={'poker-user'}>YOU</span>
            </div>
        </div>
    );
};
