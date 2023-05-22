const encrypt = (str: any, key="rc4@123"): string => {
    return str && key ? rc4(str, key) : '';
}

const decrypt = (str: any, key="rc4@123"): string => {
    return str && key ? rc4(str, key) : '';
}

const rc4 = (str: any, key: string): string => {
    let s = [], j = 0, x, result = '';
    for (let i = 0; i < 256; i++) {
        s[i] = i;
    }

    for (let i = 0; i < 256; i++) {
        j = (j + s[i] + key.charCodeAt(i % key.length)) % 256;
        x = s[i];
        s[i] = s[j];
        s[j] = x;
    }

    let i = 0;
    j = 0;

    for (let y = 0; y < str.length; y++) {
        i = (i + 1) % 256;
        j = (j + s[i]) % 256;
        x = s[i];
        s[i] = s[j];
        s[j] = x;
        result += String.fromCharCode(str.charCodeAt(y) ^ s[(s[i] + s[j]) % 256]);
    }
    return result;
}

export { encrypt, decrypt };