import React from "react";
import { useState } from "react";
import { swapETH } from "../util/interact";

const SwapETHForm = () => {

    const [values, setValues] = useState({
        tokenAmount: "",
    });

    const [submitted, setSubmitted] = useState(false);

    const handleTokenAmountInputChange = (event) => {
        setValues({...values, tokenAmount: event.target.value || ""});
    }

    const handleSubmit = (event) => {
        event.preventDefault();
        setSubmitted(true);
        swapETH(values.tokenAmount);
    }
    //UI

    return (
        <div className="form-container">
            <h5> Swap TFA for ETH </h5>
            <form className="register-form" onSubmit={handleSubmit}>
            {submitted ? <div className="success-message">Sended!</div> : null}
                <input
                    onChange={handleTokenAmountInputChange}
                    value={values.tokenAmount}
                    className="form-field"
                    type="number"
                    placeholder="1000 TFAs"
                    name="tokenAmount">
                </input>
                <button
                    className="form-field"
                    type="submit">
                        Swap
                </button>

            </form>

        </div>
    );
};

export default SwapETHForm;