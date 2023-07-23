import _ from 'lodash';
import math from '../../../utils/math';
import constants from '../../../utils/constants';
import curve from '../../../services/cryptos/curve';
import mimc from '../../../services/cryptos/mimc';
import types from '../../../utils/types';

class AuditKey {
    constructor(pk, sk) {
        this.pk = pk;
        this.sk = sk;
    }

    toJson() {
        return JSON.stringify({
            pk: this.pk,
            sk: this.sk,
        }, null, 2);
    }

    static fromJson(auditKeyJson) {
        let { pk, sk } = JSON.parse(auditKeyJson);

        return new AuditKey(
            pk,
            sk,
        );
    }

    static keyGen() {
        let sk = math.randomFieldElement(constants.SUBGROUP_ORDER);
        let pk = curve.basePointMul(sk).toString(16);
        return new AuditKey(pk, sk.toString(16));
    }
}

class UserKey {
    constructor({ ena, pkOwn, pkEnc }, sk) {
        this.pk = {
            ena: ena,
            pkOwn: pkOwn,
            pkEnc: pkEnc,
        };
        this.sk = sk;
    }

    toJson() {
        return JSON.stringify({
            ena: this.pk.ena,
            pkOwn: this.pk.pkOwn,
            pkEnc: this.pk.pkEnc,
            sk: this.sk,
        });
    }

    static fromJson(userKeyJson) {
        const userKey = JSON.parse(userKeyJson);
        return new UserKey({
            ena: _.get(userKey, 'ena'),
            pkOwn: _.get(userKey, 'pkOwn'),
            pkEnc: _.get(userKey, 'pkEnc'),
        }, _.get(userKey, 'sk'));
    }

    static keyGen() {
        const mimc7 = new mimc.MiMC7();

        const sk = math.randomFieldElement(constants.SUBGROUP_ORDER);
        const userPublicKey = {
            ena: null,
            pkOwn: mimc7.hash(sk.toString(16)),
            pkEnc: curve.basePointMul(sk).toString(16),
        };
        userPublicKey.ena = mimc7.hash(userPublicKey.pkOwn, userPublicKey.pkEnc.toString(16));

        return new UserKey(userPublicKey, sk.toString(16));
    }

    /**
     * recover UserKey from sk
     *
     * @param {string} sk hex string
     * @return {{ena, pkOwn, pkEnc}}
     */
    static recoverFromUserSk(sk) {
        const mimc7 = new mimc.MiMC7();

        const skBigIntType = types.hexToInt(sk);

        const userPublicKey = {
            ena: null,
            pkOwn: mimc7.hash(skBigIntType.toString(16)),
            pkEnc: curve.basePointMul(skBigIntType).toString(16),
        };
        userPublicKey.ena = mimc7.hash(userPublicKey.pkOwn, userPublicKey.pkEnc.toString(16));

        return userPublicKey;
    }
}

export default { AuditKey, UserKey };
