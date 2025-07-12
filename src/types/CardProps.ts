export type CardProps = {
    title: string;
    props: [
        {
            property: string;
            value: string;
        }
    ];
    slots?: [
        {
            number: string;
            props: [
                {
                    property: string;
                    value: string;
                }
            ];
        }
    ];
};