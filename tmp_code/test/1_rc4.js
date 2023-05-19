const { assert } = require("chai");
const { BigNumber } = require("bignumber.js")
const Web3 = require("web3");
const web3 = new Web3();

const RC4 = artifacts.require("RC4");

contract("test RC4", async accounts => {

    it("test rc4_encrypt_decrypt_bytes32", async () => {

        const rc4 = await RC4.deployed();

        let input = web3.utils.asciiToHex("input");
        input = web3.eth.abi.encodeParameter("bytes32", input);

        let key = web3.utils.asciiToHex("key");
        key = web3.eth.abi.encodeParameter("bytes32", key);
        console.log({input}, {key});


        let  output = await rc4.rc4_encrypt_decrypt_bytes32(input,key);

        console.log("output: ", output);
    });
    

    it("test rc4_encrypt_decrypt_bytes", async () => {

        const rc4 = await RC4.deployed();

        let input = web3.utils.asciiToHex("input");

        let key = web3.utils.asciiToHex("key");

        console.log({input}, {key});
        
        let  output = await rc4.rc4_encrypt_decrypt_bytes(input,key);

        console.log("output: ", output);
    });

    

});
