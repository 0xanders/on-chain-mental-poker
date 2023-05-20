type Props = {
    game: {
        state: number
        turn: number
        cardIndex: number
    }
};

export const Poker = (props: Props) => {
    return (
        <>
            666: {props.game?.state}
        </>
    );
};
