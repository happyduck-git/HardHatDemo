require("@nomicfoundation/hardhat-toolbox");

const { API_URL, PRIVATE_KEY, POLYGONSCAN_APIKEY } = process.env;
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  
  // Solidity 버전
  solidity: "0.8.19", 

  // 사용할 네트워크 정보
  defaultNetwork: "mumbai", 
  networks: {
    hardhat: {},
    mumbai: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/6469h2dhjORtVvYnuaWEjAQib6nzBMAc",
      accounts: ["b72de0383cee43b854caa69ce50cb14e48e400818577235492ad2a2c2d0aac25"]
    },
  },

  etherscan: {
    apiKey: {
      polygonMumbai: "X4JK7A8QX7J86XIA855RXUXR6ZUWK8U16Z",
    },
  },
  

};
