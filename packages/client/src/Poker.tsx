type Props = {
    game: {
        state: number
        turn: number
        cardIndex: number
        players: Array<string>
    }
};

export const Poker = (props: Props) => {
    return (
        <div className={'poker-warp'}>
            <div className={'poker-item poker-left'}>
                <span className={'poker-card'}>🂠</span>
            </div>
            <div className={'poker-item poker-right'}>
                <span className={'poker-card'}>🂠</span>
            </div>
            <div className={'poker-item poker-self'}>
                <span className={'poker-card'}>🂠</span>
            </div>
        </div>
    );
};
