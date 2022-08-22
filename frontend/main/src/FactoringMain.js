import React from "react";
import { useEffect, useState } from "react";
import {
  factoringContract as factoringContract,
  connectWallet,
  loadCurrentRate as loadCurrentRate,
  loadCurrentUserTFA as loadCurrentUserTFA,
  loadCurrentUserETH as loadCurrentUserETH,
  loadPoolETH as loadPoolETH,
  loadPoolTFA as loadPoolTFA,
  getCurrentWalletConnected,
  restart,
} from "./util/interact.js";

const FactoringMain = () => {
  //state variables
  const [walletAddress, setWallet] = useState("");
  const [status, setStatus] = useState("🦊 Connect to Metamask using the top right button.");

  const [rate, setRate] = useState("0%");
  const [userTokens, setUserTokens] = useState("0 TFA"); //default message
  const [userEther, setUserEther] = useState("0 ETH"); //default message
  const [poolEther, setPoolEther] = useState("0"); //default message
  const [poolTokens, setPoolTokens] = useState("0"); //default message
  const [expDate, setExpDate] = useState("");

  let dir;
  let started = false;


  //called only once
  useEffect(async () => {
    
    const {address, status} = await getCurrentWalletConnected();
    setWallet(address);
    dir = address;

    setStatus(status);

    const rate = await loadCurrentRate();
    setRate(rate);

    const myEther = await loadCurrentUserETH(address);
    setUserEther(myEther); 

    addSmartContractListener();
    addWalletListener();

    if(started){
      await loadState();
    }

  }, []);

  async function reload(){
    const {address, status} = await getCurrentWalletConnected();
    setWallet(address);
    setStatus(status);
    dir = address;
    await loadState()
  }
  async function loadState() { 
    const myEther = await loadCurrentUserETH(dir);
    setUserEther(myEther);

    const myTokens = await loadCurrentUserTFA(dir);
    setUserTokens(myTokens);

    const ethPool = await loadPoolETH();
    setPoolEther(ethPool);

    const tokensPool = await loadPoolTFA();
    setPoolTokens(tokensPool);
    
    const rate = await loadCurrentRate();
    setRate(rate);
  }

  async function addSmartContractListener() { //TODO: implement
    factoringContract.events.NewDocument({}, async (error, data) => {
        if (error) {
          setStatus("F " + error.message);
        }
        else{
          const myEther = await loadCurrentUserETH(dir);
          setUserEther(myEther);
          console.log(data.returnValues.daysRemaining); 
          const date = new Date(data.returnValues.daysRemaining * 1000);
          setExpDate(date.toLocaleDateString())
          setStatus("✅ New Document added! " + data.returnValues.filename);
        }
    });

    factoringContract.events.DOCValidated({}, async (error, data) => {
      if (error) {
        setStatus("F " + error.message);
      }
      else{

        const myEther = await loadCurrentUserETH(dir);
        setUserEther(myEther); 
        setRate(rate);
        setStatus("✅ Document verified!");
      }
    });
    

    factoringContract.events.StartLP({}, async (error, data) => {
      if (error) {
        setStatus("F " + error.message);
      }
      else{
        loadState();      
        setStatus("✅ Liquidity Pool created succesfully!");
        started = true;
      }
    });

    factoringContract.events.BuyERC({}, async (error, data) => {
      if (error) {
        setStatus("F " + error.message);
      }
      else{

        await reload();
        setStatus("✅ Transaction succesful!");
      }
    });

    factoringContract.events.BuyETH({}, async (error, data) => {
      if (error) {

        setStatus("F " + error.message);
      }
      else{

        await reload(); 

        setStatus("✅ Transaction succesful!");
      }
    });

    factoringContract.events.DepositLP({}, async (error, data) => {
      if (error) {
        
        setStatus("F " + error.message);
      }
      else{

        await reload(); 
        setStatus("✅ Transaction succesful!");
      }
    });

    factoringContract.events.WithdrawLP({}, async (error, data) => {
      if (error) {
        setStatus("F " + error.message);
      }
      else{
        
        await reload();  
        setStatus("✅ Transaction succesful!");
      }
    });
  }

  function addWalletListener() { //TODO: implement
    if (window.ethereum){
      window.ethereum.on("accountChanged", (accounts) => {
        if (accounts.length > 0){
          setWallet(accounts[0]);
          dir = accounts[0];
          setStatus("✅ Account change detected!");
        }
        else{
          setWallet("");
          setStatus("🦊 Connect to Metamask using the top right button.");
        }
      })
    }
    else{
      setStatus("🦊 You must install Metamask, a virtual Ethereum wallet, in your browser.");
    }
  }

  const connectWalletPressed = async () => { //TODO: implement
    const walletResponse = await connectWallet();
    setStatus(walletResponse.status);
    setWallet(walletResponse.address);
    await reload();

  };

  async function reinit(){
    await restart();
    await reload();
    setPoolTokens("0");
    setPoolEther("0");

  }

  //the UI of our component
  return (
    <div id="container">
        <div id="test">

        <button id="walletButton" onClick={connectWalletPressed}>
          {walletAddress.length > 0 ? (
            "Connected: " +
            String(walletAddress).substring(0, 6) +
            "..." +
            String(walletAddress).substring(38)
          ) : (
            <span>Connect Wallet</span>
          )}
        </button>

        <h5 style={{ paddingTop: "50px" }}>Factoring:</h5>
        <p> <span> {expDate != "" ? ("Expire Date: " + expDate) : ("")} </span></p>
        <p> <span> Interest Rate: {rate} </span></p>
        <p> <span> User ETH: {userEther} </span></p>
        <p> <span> User TFA: {userTokens} </span></p>
        <p> <span> {poolTokens > 0 ? ("Pool TFA: " + poolTokens) : ("")} </span></p>
        <p> <span> {poolEther > 0 ? ("Pool ETH: " + poolEther) : ("")} </span></p>

        <div>
          <p id="status">{status}</p>
        </div>

        <div class="d-grid gap-3">
          <div>
            <button type="button" class="btn btn-primary" onClick={reload}>Reload</button>
          </div>
          <div>
            <button type="button" class="btn btn-danger" onClick={reinit}>Restart</button>
          </div>
        </div>






      </div>
    </div>


  );
};

export default FactoringMain;
