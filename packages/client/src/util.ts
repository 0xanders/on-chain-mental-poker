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
