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
export function uuidGen(length = 16) {
    // const chars = '0123456789abcdefghijklmnopqrstuvwxyz'.split('')
    // const uuid = []
    // let r
    // for (let i = 0; i < length; i++) {
    //     if (!uuid[i]) {
    //         r = 0 | Math.random() * 16
    //         uuid[i] = chars[(i === 19) ? (r & 0x3) | 0x8 : r]
    //     }
    // }
    // return uuid.join('')
    return new Date().getTime().toString()
}
export function getSecretKey(length = 32) {
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
export function utf8Key(key: string): string {
    const keyBytes32 = ethers.utils.formatBytes32String(key);
    const keyStr = ethers.utils.toUtf8String(keyBytes32);
    return keyStr
}
export function encryptArray(arr: Array<any>, key: string): Array<string> {
    return arr.map((str) => {
        const inputString = ethers.utils.toUtf8String(str);
        const output1 =  encrypt(inputString, utf8Key(key));
        const output2 = ethers.utils.hexlify(ethers.utils.toUtf8Bytes(output1))
        return output2
    })
}
export function substrWalletText4(account: string){
    const address = account ? account.toLowerCase().replace(/([\w]{6})[\w\W]+([\w]{4})$/, '$1…$2') : ''
    return address
}

