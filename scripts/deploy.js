const { ethers } = require("hardhat");

async function main() {
    const couponAddress = "0x75A642CB8859f01d981f5b49C52E423d7Ac7c0d6";

    const token = await ethers.deployContract("CoffeePOAP", [couponAddress]);

    console.log("Token address:", await token.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1)
    });

