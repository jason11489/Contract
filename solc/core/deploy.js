import fs from 'fs';
import path from 'path';
import url from 'url';
import Constants from './constants';
import sendTransaction from './sendTransaction';

const __dirname = path.dirname(url.fileURLToPath(import.meta.url));
console.log(__dirname);
const compiledPath = path.join(__dirname, '../compiled');
const CONTRACT_NAME = 'Storage';
const compiledContractPath = path.join(compiledPath, CONTRACT_NAME);

async function deploy(web3) {
    const abi = JSON.parse(
        fs.readFileSync(path.join(compiledContractPath, 'abi.json'), 'utf8')
    );
    const bytecode = fs.readFileSync(
        path.resolve(compiledContractPath, 'bytecode'),
        'utf8'
    );

    const deployCall = new web3
        .eth
        .Contract(abi)
        .deploy({data: bytecode});
    const receipt = await sendTransaction(
        web3,
        deployCall,
        Constants.DEFAULT_DEPLOY_GAS
    );

    return receipt.contractAddress;
}

export default deploy;
