import logo from './logo.svg';
import './App.css';
import KakfaMessageRequest from './components/KafkaMessageRequest';
import Clock from './components/Clock';
import KafkaMessage from "./components/KafkaMessage";


let domContainer = document.querySelector('#KafkaMessage');
function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        
        
        <KafkaMessage />
        
        {/* <Clock /> */}  
       
      </header>
    </div>
  );
}

export default App;
