import solc from 'solc';
import { compileImports, writeCompiledContractAbiAndBytecode } from './readWrite.js';

/**
 * compile the sol file located in basePath
 * @param {string} basePath   path of the sol file from the project root directory
 * @param {string} contractName contract name
 * @returns {object} compiledResult
 */
export default function (basePath, contractName) {
    const sources = {};
    compileImports(basePath, sources);
    var input = {
        language: 'Solidity',
        sources: sources,
        settings: {
            optimizer: { enabled: true },
            outputSelection: {
                '*': {
                    '*': ['*'],
                },
            },
        },
    };
    const output = solc.compile(JSON.stringify(input));

    const contract = JSON.parse(output);
    if(Array.isArray(contract.errors)) {
        const errors = contract.errors.filter( el => el.type !== 'Warning');
        if(errors.length > 0){
            console.debug(errors);
        }
    }
    writeCompiledContractAbiAndBytecode(contract, contractName, basePath);
    return contract;
}
