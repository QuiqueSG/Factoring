import React from "react";
import { useState } from "react";
import { txBuyTFA } from "../util/interact";


const BuyTFAForm = () => {

    const [values, setValues] = useState({
        ethAmount: "",
    });

    const [submitted, setSubmitted] = useState(false);

    const handleEthAmountInputChange = (event) => {
        setValues({...values, ethAmount: event.target.value || ""});
    }

    const handleSubmit = (event) => {
        event.preventDefault();
        setSubmitted(true);
        txBuyTFA(values.ethAmount);
    }
    //UI

    return (
        <div className="form-container">
            <h5> Buy TFAs </h5>
            <form className="register-form" onSubmit={handleSubmit}>
                {submitted ? <div className="success-message">Sended!</div> : null}
                <input
                    onChange={handleEthAmountInputChange}
                    value={values.ethAmount}
                    className="form-field"
                    type="number"
                    placeholder="1 ETH"
                    name="ethAmount">
                </input>
                <button
                    className="form-field"
                    type="submit">
                        Buy
                </button>

            </form>

        </div>
    );
};

export default BuyTFAForm;