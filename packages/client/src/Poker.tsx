import { useMUD } from "./MUDContext";
import { useComponentValue } from "@latticexyz/react";
import { useMount } from "ahooks";
import { useEffect, useState } from "react";
import { GameState, getSecretKey, encryptArray, randowArray, utf8Key, substrWalletText4 } from "./util";
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
    const {walletAddress, components: { HandCard }, systemCalls: { shuffleAndSave, dealCards }} = useMUD();
    
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
        wallet: ''
    })
    const [rightPlayer, setRightPlayer] = useState({
        wallet: ''
    })
    const clickTool = () => {
        debugger
        if (props.game.state === GameState.Shuffle) {
            let cardArr = [...props.game.cardsHash];
            const secretKey = getSecretKey();

            const keyBytes32 = ethers.utils.formatBytes32String(secretKey);
            const keyStr = ethers.utils.toUtf8String(keyBytes32);

            cardArr = encryptArray(cardArr, secretKey);
            // cardArr = randowArray(cardArr);

            const msgToSign = ethers.utils.formatBytes32String("0xPoker");
            const msgToSign2 = ethers.utils.toUtf8String(msgToSign);
            let resultOfSign = encrypt(msgToSign2, keyStr);

            resultOfSign = ethers.utils.hexlify(ethers.utils.toUtf8Bytes(resultOfSign))

            shuffleAndSave(props.gameId, msgToSign, resultOfSign, cardArr)
        } else if (props.game.state === GameState.DealCards) {
            dealCards(props.gameId)
        } else if (props.game.state === GameState.DecryptForOthers) {
            // dealCards(props.gameId)
        }
    }
    useEffect(() => {
        if (props.game.players) {
            const players = [...props.game.players]
            const idx = players.indexOf(walletAddress)
            setSelfPlayer({
                turnIdx: idx,
                wallet: walletAddress
            })
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
