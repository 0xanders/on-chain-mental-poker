const { assert, expect } = require("chai");
const { BigNumber } = require("bignumber.js")
const Web3 = require("web3");
const web3 = new Web3();
const rc4js = require('rc4-cipher');
const RC4 = artifacts.require("RC4");

contract("test RC4", async accounts => {

    it("test rc4_encrypt_decrypt_bytes32", async () => {

        const rc4 = await RC4.deployed();

        let input = "input";
        let inputHex=  web3.utils.asciiToHex(input);
        let inputByte32 =   web3.eth.abi.encodeParameter("bytes32", inputHex);
        let inputString =  web3.utils.hexToAscii(inputByte32);

        let key = "key";
        let keyHex = web3.utils.asciiToHex(key);
        let keyByte32 =   web3.eth.abi.encodeParameter("bytes32", keyHex);
        let keyString = web3.utils.hexToAscii(keyByte32);


        let  output1 = await rc4.encryptBytes32(inputByte32,keyByte32);

        let output2 =  rc4js.encrypt(inputString,keyString);
        output2 = web3.utils.asciiToHex(output2);

        expect(output1).to.equal(output2);

        let  output3 = await rc4.encryptBytes32(output1,keyByte32);
        expect(output3).to.equal(inputByte32);


        console.log({input,inputByte32, inputString, key, keyByte32, keyString, output1, output2});
    });
    

    it("test rc4_encrypt_decrypt_bytes", async () => {

        const rc4 = await RC4.deployed();

        let input = "input";
        let inputHex=  web3.utils.asciiToHex(input);

        let key = "key";
        let keyHex = web3.utils.asciiToHex(key);

        
        let output1 = await rc4.encryptBytes(inputHex,keyHex);
        let output2 =  rc4js.encrypt(input,key);
        output2 = web3.utils.asciiToHex(output2);

        expect(output1).to.equal(output2);

        console.log({input,key,output1, output2});

        let  output3 = await rc4.encryptBytes(output1,keyHex);
        expect(output3).to.equal(inputHex);

    });

    it("test js encrypt", async () => {

       
        // data example from contract
        let inputByte32=  "0x0000000000000000000000000000000000000000000000000000000000000001";
       
        let inputString =  web3.utils.hexToAscii(inputByte32);
        

        let key = "key";
        let keyHex = web3.utils.asciiToHex(key);
        let keyByte32 =   web3.eth.abi.encodeParameter("bytes32", keyHex);
        let keyString = web3.utils.hexToAscii(keyByte32);
        
        let output1 =  rc4js.encrypt(inputString,keyString);
        let output1Hex = web3.utils.asciiToHex(output1);
        
        // send output1Byte32 to contract
        let output1Byte32 =   web3.eth.abi.encodeParameter("bytes32", output1Hex);

        let output2 = rc4js.encrypt(output1,keyString);

        expect(output2).to.equal(inputString);

        console.log({inputByte32,inputString, key,keyHex, keyByte32, keyString, output1,output1Byte32, output2});
    }); 
});
