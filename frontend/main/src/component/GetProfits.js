import React from "react";

import { arbitPool } from "../util/interact";
import { getProfit } from "../util/interact";


const Verify = () => {


    return (
        <div>
            <button type="button" onClick={arbitPool}>Arbit</button>
            <button type="button" onClick={getProfit}>Profit</button>

        </div>
    );

}

export default Verify;