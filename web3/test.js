import CompiledStorage from "./Storage/compiled.js";
// import Web3 from "./index.js"; const storage = new Web3     .Storage
// .Contract(CompiledStorage.abi, CompiledStorage.bytecode); let userAddress;
// await storage     .eth     .getAccounts()     .then(e => (userAddress =
// e[2])); await storage.updatenumber("3", userAddress); const get_number =
// await storage.getnumber(); await storage     .updatenumber("544",
// userAddress)     .then(console.log(get_number));

import Web3 from "web3";

const web3 = new Web3("http://192.168.0.45:8545");

const ContractAddress = '0x275171AFD6055f153e7a6edAF95dBa41Ec92edf4';

const storage = new web3
    .eth
    .Contract(CompiledStorage.abi, ContractAddress);

storage
    .methods
    .retrieve()
    .call()
    .then(console.log);



// let txDescription = {
//     from: "0x158f574422b3aa30D8f67dbD3ABb3eB9045fFC7c",
// }

// storage
//     .methods
//     .store(22)
//     .send(txDescription)
//     .then(console.log);