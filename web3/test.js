import CompiledStorage from "./Storage/compiled.js";


import Web3 from "web3";

const web3 = new Web3("http://0.0.0.0:8545");

const ContractAddress = "0xb05b2c8242bc9690ffd9e4f2ef15a74a31194702";

const storage = new web3
    .eth
    .Contract(CompiledStorage.abi, ContractAddress);



let txDescription = {
    from: "0x3152727d3a2ee8a0f4bf8322b1dc49f63599b1d1da2604bda5fcb480f5c8ce3f",
}

await storage.methods.store("4").send(txDescription).then(console.log);

await storage
    .methods
    .retrieve()
    .call()
    .then(console.log);

