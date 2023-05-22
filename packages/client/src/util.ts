import { ethers } from "ethers";
import { encrypt } from "./rc4";
// import Web3 from "web3";
// const web3 = new Web3();
export enum GameState {
    Join, // 加入游戏
    Shuffle, // 洗牌
    DealCards, // 发牌
    DecryptForOthers, // 解密
    UploadSecret, // 上传私钥验证
    Error,
    Finished// 游戏结束
}


/**
 * Check if string is HEX, requires a 0x in front
 *
 * @method isHexStrict
 * @param {String} hex to be checked
 * @returns {Boolean}
 */
const isHexStrict = function (hex: any) {
    return ((typeof hex === 'string' || typeof hex === 'number') && /^(-)?0x[0-9a-f]*$/i.test(hex));
};

/**
 * Should be called to get ascii from it's hex representation
 *
 * @method hexToAscii
 * @param {String} hex
 * @returns {String} ascii string representation of hex value
 */
const hexToAscii = function (hex: any) {
    if (!isHexStrict(hex))
        throw new Error('The parameter must be a valid HEX string.');
    var str = "";
    var i = 0, l = hex.length;
    if (hex.substring(0, 2) === '0x') {
        i = 2;
    }
    for (; i < l; i += 2) {
        var code = parseInt(hex.slice(i, i + 2), 16);
        str += String.fromCharCode(code);
    }
    return str;
};
/**
 * Should be called to get hex representation (prefixed by 0x) of ascii string
 *
 * @method asciiToHex
 * @param {String} str
 * @returns {String} hex representation of input string
 */
const asciiToHex = function (str: any) {
    if (!str)
        return "0x00";
    var hex = "";
    for (var i = 0; i < str.length; i++) {
        var code = str.charCodeAt(i);
        var n = code.toString(16);
        hex += n.length < 2 ? '0' + n : n;
    }
    return "0x" + hex;
};

export function URLSearchParams (): Map<string, string> {
    const search = window.location.search
    const map:Map<string, string> = new Map()
    if (search) {
        const searchArr = search.substring(1).split('&') as Array<string>
        searchArr.forEach((p) => {
            const keys = p.split('=')
            if (keys.length === 2) {
                map.set(keys[0], keys[1])
            }
        })
        return map
    }
    return map
}
export function getSecretKey() {
    const uuid = sessionStorage.getItem('SecretKey:UUID') || Math.floor(new Date().getTime() * Math.random()).toString()
    sessionStorage.setItem('SecretKey:UUID', uuid)
    return 'uuid'
}
export function randowArray(arr: Array<any>){
    let i = arr.length;
    while (i) {
        const j = Math.floor(Math.random() * i--);
        [arr[j], arr[i]] = [arr[i], arr[j]];
    }
    return arr
}
export function utf8Key(key: string): string {
    const keyBytes32 = ethers.utils.formatBytes32String(key);
    const keyStr = ethers.utils.toUtf8String(keyBytes32);
    return keyStr
}

export function encryptSingle(input: string, key: string): string {
    const keyHex = asciiToHex(key);
    const keyByte32 = ethers.utils.hexZeroPad(keyHex, 32)

    const keyString = hexToAscii(keyByte32);

    const inputHex = asciiToHex(input);
    const inputBytes32 = ethers.utils.hexZeroPad(inputHex, 32);
    const inputString = hexToAscii(inputBytes32);

    const outputString = encrypt(inputString, keyString);
    const outputBytes32 = asciiToHex(outputString);

    return outputBytes32

}

export function encryptArray(arr: Array<any>, key: string): Array<string> {
    return arr.map((str) => {                
        return encryptSingle(str, key)
    })
}



export function substrWalletText4(account: string){
    const address = account ? account.toLowerCase().replace(/([\w]{4})[\w\W]+([\w]{4})$/, '$1…$2') : ''
    return address
}

