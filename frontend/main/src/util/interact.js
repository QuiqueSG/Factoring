const Web3 = require('web3');
const web3 = new Web3(window.ethereum);
const contractABI = require("../contract-abi.json");
const contractAddress = "0x4f359E2b813707756918C10CC737273995DDc84e";
let account = "0x0000000000000000000000000000000000000000" ;

export const factoringContract = new web3.eth.Contract(
    contractABI,
    contractAddress
  );

export const connectWallet = async () => {
    if (window.ethereum) {
        try {
            const addressArray = await window.ethereum.request({
                method: "eth_requestAccounts",
            });
            const obj = {
                status: "✅ Account connected successfully.",
                address: addressArray[0],
            };
            account = addressArray[0];
            return obj;
        }
        catch(error){
            return {
                address: "",
                status: "Error: " + error.message,
            };
        }
    }
    else{
        return {
            address: "",
            status: "You must install Metamask in your browser or use one compatible like Chrom or Firefox."
        };
    }
};

export const getCurrentWalletConnected = async () => {
  if (window.ethereum){
    try {
        const addressArray = await window.ethereum.request({
            method: "eth_accounts",
        });

        if (addressArray.length > 0){
            account = addressArray[0];
            return {
                address: addressArray[0],
                status: "✅ Current account connected succesfully.",
            };

        }
        else {
            return {
                address: "",
                status: "🦊 Connect to Metamask using the top right button.",
            }
        }
    }
    catch(error) {
        return {
            address: "",
            status: "Error " + error.message,
        };
    }
  }
  else {
    return {
        address: "",
        status: "You must install Metamask in your browser or use one compatible like Chrom or Firefox.",
    };
  }

};

export const loadCurrentRate = async () => { 
    const rate = await factoringContract.methods.INTrate().call();
    const rateDec = parseFloat(Web3.utils.fromWei(rate, 'ether'));
    return rateDec.toFixed(2) + '%';
};

export const loadCurrentUserETH = async (address) => { 
    const myEthers = await factoringContract.methods.ETHbalance(address).call();
    const myEthersDec = parseFloat(Web3.utils.fromWei(myEthers, 'ether'));
    return myEthersDec;
};

export const loadCurrentUserTFA = async (address) => { 
    const myTokens = await factoringContract.methods.TFAbalance(address).call();
    const myTokensDec = parseFloat(Web3.utils.fromWei(myTokens, 'ether'));
    return myTokensDec + ' TFA';
};

export const loadPoolETH = async () => { 
    const myEthers = await factoringContract.methods.LPether().call();
    const myEthersDec = parseFloat(Web3.utils.fromWei(myEthers, 'ether'));
    return myEthersDec;
};

export const loadPoolTFA = async () => { 
    const myTokens = await factoringContract.methods.LPtokens().call();
    const myTokensDec = parseFloat(Web3.utils.fromWei(myTokens, 'ether'));
    return myTokensDec;
};

async function transaction(txFunc){
    const address = account;
    if (!window.ethereum || address === null) {
        return {
            status:
            "💡 Connect your Metamask wallet to update the message on the blockchain.",
        };
    }

    const transactionParameters = {
        to: contractAddress,
        from: address,
        data: txFunc,
    };

    try{
        const txHash = await window.ethereum.request({
            method: "eth_sendTransaction",
            params: [transactionParameters],
        });

        return {
            status: "✅ Transaction sended!"
        };
    }
    catch(error){
        return {
            status: "F " + error.message,
        };
    }


}

async function transactionPayable(eth, txFunc){
    const address = account;
    const wei = web3.utils.toWei(eth, 'ether');
    if (!window.ethereum || address === null) {
        return {
            status:
            "💡 Connect your Metamask wallet to update the message on the blockchain.",
        };
    }


    const transactionParameters = {
        to: contractAddress,
        from: address,
        data: txFunc,
        value: web3.utils.toHex(wei),
    };

    try{
        const txHash = await window.ethereum.request({
            method: "eth_sendTransaction",
            params: [transactionParameters],
        });

        return {
            status: "✅ Transaction sended!"
        };
    }
    catch(error){
        return {
            status: "F " + error.message,
        };
    }


}

export const newDocument = async (name, price, expDays) => {
    const priceWei = web3.utils.toWei(price, 'ether');
    return transaction(factoringContract.methods.DOCnewFile(name, priceWei, expDays).encodeABI());
};

export const verifyDocument = async () => {
    return transaction(factoringContract.methods.DOCvalidate().encodeABI());
};

export const denyDocument = async () => {
    return transaction(factoringContract.methods.DOCdeny().encodeABI());
};

export const startLP = async (numberTokens, ether) => {
    return transactionPayable(ether, factoringContract.methods.start(numberTokens).encodeABI());    
};

export const txBuyTFA = async (ether) => {
    return transactionPayable(ether, factoringContract.methods.LPbuyERC().encodeABI());
};

export const swapETH = async (tokens) => {
    const tokensTFA = web3.utils.toWei(tokens, 'ether');
    return transaction(factoringContract.methods.LPbuyETH(tokensTFA).encodeABI());    
};

export const txDeposit = async (ether) => {
    return transactionPayable(ether, factoringContract.methods.LPdeposit().encodeABI());
}

export const txWithdraw = async (ether) => {
    const wei = web3.utils.toWei(ether, 'ether');
    return transactionPayable(factoringContract.methods.LPgetLiquidity(wei).encodeABI());
}

export const arbitPool = async () => {
    return transaction(factoringContract.methods.FINarbit().encodeABI());
}

export const getProfit = async () => {
    return transaction(factoringContract.methods.FINgetProfit().encodeABI());
}

export const restart = async () => {
    return transaction(factoringContract.methods.restart().encodeABI());
}