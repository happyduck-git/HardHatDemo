require("@nomicfoundation/hardhat-toolbox");

const { API_URL, PRIVATE_KEY } = process.env;
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  
  // Solidity 버전
  solidity: "0.8.19", 

  // 사용할 네트워크 정보
  defaultNetwork: "mumbai", 
  networks: {
    hardhat: {},
    mumbai: {
      url: ,
      accounts: []
    },
  },

};
