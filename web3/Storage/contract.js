import Constants from '../../utils/constants.js';
import Web3Interface from '../web3/web3.interface.js';
import CompiledStorage from './compiled.js';

export default class Contract extends Web3Interface {
    constructor(endpoint, deployedAddress) {
        super(endpoint);
        this.instance = new this.eth.Contract(CompiledStorage.abi, deployedAddress);
        this.contractMethods = this.instance.methods;
        this.contractAddress = deployedAddress;
    }

    /**
     *
     * @param {string} tokenAddress
     * @param {string} userEthAddress
     * @param {string} userEthPrivateKey
     * @param {number} gas
     * @return {Promise<TransactionReceipt>}
     */
    async updatenumber(
        number,
        userEthAddress,
        userEthPrivateKey,
        gas = Constants.DEFAULT_REGISTER_GAS,
    ) {
        return this.sendContractCall(
            this.contractMethods.store(number),
            userEthAddress,
            userEthPrivateKey,
            gas,
        );
    }

    async getnumber() {
        return this.localContractCall(
            this.contractMethods.retrieve(),
        );
    }
}
