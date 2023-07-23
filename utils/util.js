import _ from 'lodash';
import { Platform, PermissionsAndroid } from 'react-native';
import RNFS from 'react-native-fs';
import Share from 'react-native-share';
import Config from 'react-native-config';
import Web3 from '../web3';
import localStorage from './async.storage';
import LocalStorage from './async.storage';
const BASE_ENDPOINT = Config.DEFAULT_ENDPOINT;

/**
 *
 * @param {Promise}     asyncPromise        Async Promise
 * @param {Number}      timeLimit           Time limit
 * @returns {Promise}
 */
export const asyncSetTimeout = async (asyncPromise, timeLimit, errMsg) => {
    let timeoutHandle;
    const timeoutPromise = new Promise((_resolve, reject) => {
        timeoutHandle = setTimeout(
            () => reject(errMsg),
            timeLimit
        );
    });

    return Promise.race([asyncPromise, timeoutPromise]).then(result => {
        clearTimeout(timeoutHandle);
        return result;
    });
};

/**
 * Share QRCoda data to someone
 *
 * @param {string} fileName
 * @param {Svg} QRref
 * @param {function} setQRref
 * @returns     {Promise<boolean>}
 */
export const shareToQR = async (fileName, QRref, setQRref) => {
    // permission check
    if (Platform.OS === 'android' &&
        !(await hasAndroidPermission())) {
        return false;
    }
    // null check
    if (_.isNil(QRref)) {
        return false;
    }

    QRref.toDataURL(async (data) => {
        let filePath = RNFS.CachesDirectoryPath + `/${fileName}.png`;
        try {
            await RNFS.writeFile(filePath, data, 'base64');
            await Share.open({
                url: 'file://' + filePath,
                title: 'KEY'
            });
        }
        finally {
            setQRref(undefined);
        }
    });
    return true;
};

/**
 * check whether android device has writing permisson
 *
 * @returns {Promise<boolean>}
 */
export const hasAndroidPermission = async () => {
    const permission = PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE;

    const hasPermission = await PermissionsAndroid.check(permission);
    // permission check
    if (hasPermission) {
        return true;
    }

    // status check
    const status = await PermissionsAndroid.request(permission);
    return status === 'granted';
};

/**
 *
 * @param {string|number} blockHashOrBlockNumber block hash or block number
 * @param {string} locale specify the language
 * @return { Promise<string>}
 */
export const getBlockDateTime = async (blockHashOrBlockNumber, locale='en') => {
    const web3 = new Web3.Web3Interface(BASE_ENDPOINT);
    return web3.getBlockDateTime(blockHashOrBlockNumber, locale);
};

export const getNetworkId = async () => {
    const web3 = new Web3.Web3Interface(BASE_ENDPOINT);
    return web3.net.getId();
};
/**
 *
 * @param {Promise} promiseFunction
 * @param {Number}  timeout ms
 * @return {Promise<*>}
 */
export async function functionWithTimeOut(promiseFunction, timeout) {
    await LocalStorage.storeData('IS_TIMEOUT', 'false');
    let timer;
    const res = await Promise.race([
        promiseFunction,
        new Promise(resolve => {
            timer = setTimeout(() => resolve('timeout'), timeout);
        })
    ]).finally(() => clearTimeout(timer));

    if (res === 'timeout') {
        await LocalStorage.storeData('IS_TIMEOUT', 'true');
        throw new Error(`${timeout}ms timeout`);
    }
    return res;

}

const util = {
    asyncSetTimeout,
    shareToQR,
    hasAndroidPermission,
    getBlockDateTime,
    functionWithTimeOut,
    getNetworkId
};

export default util;
