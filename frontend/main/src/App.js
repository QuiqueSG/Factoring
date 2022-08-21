import FactoringMain from './FactoringMain';
import NewDocForm from './component/Factoring';
import StartLPForm from './component/StartLPForm';
import BuyTFAForm from './component/BuyTFAForm';
import SwapETHForm from './component/SwapETHForm';
import DepositForm from './component/DepositForm';
import WithdrawForm from './component/WithdrawForm';
import Verify from './component/Verify';
import GetProfits from './component/GetProfits'
import './App.css';

function App() {
  return (
    <body className="App">

        <body>
        <div class="container"> 
          <div class="row">
            <div class="col border border-primary"><NewDocForm /> </div>
            <div class="col border border-primary"><StartLPForm /> </div>
          </div>

          <div class="row border border-primary">
            <div class="col border border-primary"><BuyTFAForm /> </div>
            <div class="col border border-primary"><SwapETHForm /> </div>
          </div>

          <div class="row border border-primary">
            <div class="col border border-primary"><DepositForm /> </div>
            <div class="col border border-primary"><WithdrawForm /> </div>
          </div>


        </div>
        
        <hr></hr> 
          <GetProfits />
        <hr></hr> 
          <Verify />

        </body>

        <hr></hr>
        <FactoringMain></FactoringMain>


    </body>
  );
}

export default App;
