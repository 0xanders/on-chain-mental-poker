type Props = {
    game: {
        state: number
        turn: number
        cardIndex: number
        players: Array<string>
    }
};

export const Poker = (props: Props) => {
    props.game.players.includes()
    return (
        <>
            666: {props.game?.state}
        </>
    );
};
