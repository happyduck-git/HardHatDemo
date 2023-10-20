const { ethers } = require("hardhat");

async function main() {
    const token = await ethers.deployContract("Timer");

    console.log("Token address:", await token.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1)
    });

