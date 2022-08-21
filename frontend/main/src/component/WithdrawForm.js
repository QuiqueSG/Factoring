import React from "react";
import { useState } from "react";
import { txWithdraw } from "../util/interact";


const WithdrawForm = () => {

    const [values, setValues] = useState({
        ethAmount: "",
    });

    const [submitted, setSubmitted] = useState(false);

    const handleEthAmountInputChange = (event) => {
        setValues({...values, ethAmount: event.target.value});
    }

    const handleSubmit = (event) => {
        event.preventDefault();
        setSubmitted(true);
        txWithdraw(values.ethAmount);
    }
    //UI

    return (
        <div className="form-container">
            <h5> Withdraw Liquidity ETH </h5>
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
                        Withdraw
                </button>

            </form>

        </div>
    );
};

export default WithdrawForm;