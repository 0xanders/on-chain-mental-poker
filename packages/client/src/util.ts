import { ethers } from "ethers";
const rc4Cipher = require('rc4-cipher');
export enum GameState {
    Join, // 加入游戏
    Shuffle, // 洗牌
    DealCards, // 发牌
    DecryptForOthers, // 解密
    UploadSecret, // 上传私钥验证
    Error,
    Finished// 游戏结束
}
export const CARDS = [
    ethers.utils.formatBytes32String('1'), ethers.utils.formatBytes32String('2'), ethers.utils.formatBytes32String('3'), ethers.utils.formatBytes32String('4'), ethers.utils.formatBytes32String('5'), ethers.utils.formatBytes32String('6'), ethers.utils.formatBytes32String('7'), ethers.utils.formatBytes32String('8'), ethers.utils.formatBytes32String('9'), ethers.utils.formatBytes32String('10'), ethers.utils.formatBytes32String('11'), ethers.utils.formatBytes32String('12'), ethers.utils.formatBytes32String('13'),
    ethers.utils.formatBytes32String('14'), ethers.utils.formatBytes32String('15'), ethers.utils.formatBytes32String('16'), ethers.utils.formatBytes32String('17'), ethers.utils.formatBytes32String('18'), ethers.utils.formatBytes32String('19'), ethers.utils.formatBytes32String('20'), ethers.utils.formatBytes32String('21'), ethers.utils.formatBytes32String('22'), ethers.utils.formatBytes32String('23'), ethers.utils.formatBytes32String('24'), ethers.utils.formatBytes32String('25'), ethers.utils.formatBytes32String('26'),
    ethers.utils.formatBytes32String('27'), ethers.utils.formatBytes32String('28'), ethers.utils.formatBytes32String('29'), ethers.utils.formatBytes32String('30'), ethers.utils.formatBytes32String('31'), ethers.utils.formatBytes32String('32'), ethers.utils.formatBytes32String('33'), ethers.utils.formatBytes32String('34'), ethers.utils.formatBytes32String('35'), ethers.utils.formatBytes32String('36'), ethers.utils.formatBytes32String('37'), ethers.utils.formatBytes32String('38'), ethers.utils.formatBytes32String('39'),
    ethers.utils.formatBytes32String('40'), ethers.utils.formatBytes32String('41'), ethers.utils.formatBytes32String('42'), ethers.utils.formatBytes32String('43'), ethers.utils.formatBytes32String('44'), ethers.utils.formatBytes32String('45'), ethers.utils.formatBytes32String('46'), ethers.utils.formatBytes32String('47'), ethers.utils.formatBytes32String('48'), ethers.utils.formatBytes32String('49'), ethers.utils.formatBytes32String('50'), ethers.utils.formatBytes32String('51'), ethers.utils.formatBytes32String('52')
]
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
/**
 * gen uuid
 * @param length
 * @returns uuid string
 */
export function uuidGen(length = 32) {
    const chars = '0123456789abcdefghijklmnopqrstuvwxyz'.split('')
    const uuid = []
    let r
    uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-'
    for (let i = 0; i < length; i++) {
        if (!uuid[i]) {
            r = 0 | Math.random() * 16
            uuid[i] = chars[(i === 19) ? (r & 0x3) | 0x8 : r]
        }
    }
    return uuid.join('')
}
export function getKey(length = 32) {
    const uuid = sessionStorage.getItem('key:uuid') || uuidGen()
    sessionStorage.setItem('key:uuid', uuid)
    return uuid
}
export function randowArray(arr: Array<any>){
    let i = arr.length;
    while (i) {
        const j = Math.floor(Math.random() * i--);
        [arr[j], arr[i]] = [arr[i], arr[j]];
    }
    return arr
}
export function encryptArray(arr: Array<any>, key: string){
    return arr.map((str) => {
        return rc4Cipher.encrypt(str, key);
    })
}
export function substrWalletText4(account: string){
    const address = account ? account.toLowerCase().replace(/([\w]{6})[\w\W]+([\w]{4})$/, '$1…$2') : ''
    return address
}

