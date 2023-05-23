import { useMUD } from "./MUDContext";
import { useComponentValue, useEntityQuery } from "@latticexyz/react";
import { useMount } from "ahooks";
import { useEffect, useState } from "react";
import { GameState, getSecretKey, encryptCard, encryptCards, asciiToHex, randowArray, utf8Key, encryptMsg, substrWalletText4 } from "./util";
import { encrypt } from "./rc4";
import { BigNumber, ethers } from "ethers";
import { world } from "./mud/world";
import { createDatabase, createDatabaseClient } from "@latticexyz/store-cache";
import config from "../../contracts/mud.config";
import { PokerCards, CardType } from "./mud/cards";
const playerNames = ['Alice', 'Bob', 'Carl']
type Props = {
    gameId: string,
    game: {
        state: number
        turn: number
        cardIndex: number
        players: Array<string>
        cardsHash: Array<string>,
        winner: string
    }
};
export const Poker = (props: Props) => {
    const {
        walletAddress,
        components: { HandCard },
        network: { storeCache },
        systemCalls: { shuffleAndSave, dealCards, decryptForOthers, uploadSecretKey } } = useMUD();
    const byte32GameId = ethers.utils.formatBytes32String(props.gameId);
    const encodedData = ethers.utils.solidityPack(['bytes32', 'address'], [byte32GameId, walletAddress]);
    const handCardId = ethers.utils.keccak256(encodedData);
    const handCardEntity = world.registerEntity({ id: handCardId });
    const handCard = useComponentValue(HandCard, handCardEntity);
    const [selfCard, setSelfCard] = useState({
        value: '🂠',
        color: '#000'
    } as CardType);
    const [playerCards, setPlayerCards] = useState([] as Array<CardType>);
    const [loadingBtn, setLoadingBtn] = useState(false);
    const clickTool = () => {
        if (loadingBtn) return;
        setLoadingBtn(true);
        try {
            if (props.game.state === GameState.Shuffle) {
                let cardArr = [...props.game.cardsHash];
                const secretKey = getSecretKey();
                cardArr = encryptCards(cardArr, secretKey);
                cardArr = randowArray(cardArr);
                const msgToSign = "0xPoker";
                const msgToSignHex = asciiToHex(msgToSign);
                const msgToSignByte = ethers.utils.hexZeroPad(msgToSignHex, 32);
                const resultOfSign = encryptMsg(msgToSign, secretKey);
                shuffleAndSave(props.gameId, msgToSignByte, resultOfSign, cardArr)
            } else if (props.game.state === GameState.DealCards) {
                dealCards(props.gameId)
            } else if (props.game.state === GameState.DecryptForOthers) {
                const otherPlayers = [...props.game.players]
                const selfIdx = otherPlayers.indexOf(walletAddress)
                otherPlayers.splice(selfIdx, 1)
                const tempCardsHash = otherPlayers.map((walletStr) => {
                    const otherEncodedData = ethers.utils.solidityPack(['bytes32', 'address'], [byte32GameId, walletStr]);
                    const otherHandCardId = ethers.utils.keccak256(otherEncodedData);
                    const result = storeCache.tables.HandCard.get({ id: otherHandCardId })
                    return result.tempCardHash
                })
                const secretKey = getSecretKey();
                const tempCardsHashByte32 = encryptCards(tempCardsHash, secretKey);
                decryptForOthers(props.gameId, otherPlayers, tempCardsHashByte32)
            } else if (props.game.state === GameState.UploadSecret) {
                const secretKey = getSecretKey();
                const msgToSignHex = asciiToHex(secretKey);
                const msgToSignByte = ethers.utils.hexZeroPad(msgToSignHex, 32);
                uploadSecretKey(props.gameId, msgToSignByte)
            }
        } catch (error) {
            setLoadingBtn(false)
        }
    }
    useEffect(() => {
        if (props.game.state === GameState.UploadSecret && handCard?.tempCardHash) {
            const secretKey = getSecretKey();
            const cardByte32 = encryptCard(handCard?.tempCardHash, secretKey)
            const intValue = (Number(BigNumber.from(cardByte32).toString(10)) - 1).toString()
            setSelfCard(PokerCards[intValue] as CardType)
        } else if (props.game.state === GameState.Finished) {
            const showCards = props.game.players.map((walletStr) => {
                const otherEncodedData = ethers.utils.solidityPack(['bytes32', 'address'], [byte32GameId, walletStr]);
                const otherHandCardId = ethers.utils.keccak256(otherEncodedData);
                const result = storeCache.tables.HandCard.get({ id: otherHandCardId })
                const intValue = (Number(BigNumber.from(result.card).toString(10)) - 1).toString()
                return PokerCards[intValue] as CardType;
            })
            setPlayerCards(showCards);
        }
    }, [props.game, handCard])
    useEffect(() => {
        setLoadingBtn(false)
    }, [props.game?.turn])
    return (
        <div className={'poker-warp'}>
            {
                props.game.players.map((wallet, idx) => {
                    return <>
                        <div key={Math.random()} className={'poker-item'}>
                            {
                                playerCards.length > 0 ?
                                    <span className={'poker-card'} style={{
                                        color: playerCards[idx]?.color
                                    }}>
                                        {playerCards[idx]?.value}
                                    </span> :
                                    <span className={`poker-card ${props.game.state <= 2 ? 'no-card' : ''}`} style={{
                                        color: (wallet === walletAddress ? selfCard.color : '#000')
                                    }}>
                                        {(props.game.state > 2 && props.game.state !== GameState.Finished) ? (wallet === walletAddress ? selfCard.value : '🂠') : '?'}
                                    </span>
                            }
                            {
                                (props.game.state !== GameState.Join && props.game.state !== GameState.Finished) &&
                                <span className={`btn-tool ${wallet === walletAddress && loadingBtn ? 'loading-btn' : ''} ${wallet === walletAddress && props.game.turn === idx ? '' : 'disable'}`} onClick={clickTool}>
                                    {
                                        props.game.turn === idx && <span className={'turn-user'} />
                                    }
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
                            {
                                props.game.state === GameState.Finished &&
                                <span className={`btn-tool ${props.game.winner === wallet ? 'winner' : 'fail'}`}>
                                    {
                                        props.game.winner === wallet ? 'Winner' : 'Loser'
                                    }
                                </span>
                            }
                            <span className={'poker-user'}>
                                {playerNames[idx]} --&nbsp;
                                {
                                    wallet === walletAddress ? "YOU" : (wallet ? substrWalletText4(wallet) : '?')
                                }
                            </span>
                        </div>
                    </>
                })
            }
        </div>
    );
};
