
import Web3 from "web3";
import CompiledStorage from "./Storage/compiled.js";


const web3 = new Web3(Web3.givenProvider || "http://0.0.0.0:8545");



web3.eth.defaultAccount = "0x9f6159c085141b3e50971F26ffC85BC86cFAb94e";

const MyContract = new web3.eth.Contract(CompiledStorage.abi, "0xb4D1dAe798Cd7cf31BB492A42C0dE4E9CeA131D2");

await MyContract.methods.store("22").send({ from: web3.eth.defaultAccount });

await MyContract.methods.retrieve().call().then(console.log);




await MyContract.methods.store("213123123").send({ from: web3.eth.defaultAccount });

await MyContract.methods.retrieve().call().then(console.log);



// await web3.eth.getAccounts(console.log);

