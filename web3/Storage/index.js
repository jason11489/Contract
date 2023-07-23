import Config from 'react-native-config';
import Contract from './contract.js';

const StorageContract = new Contract(Config.DEFAULT_ENDPOINT, Config.CONTRACT_ADDRESS);

const Storage = {
    StorageContract,
    Contract,
};

export default Storage;