const { ethers } = require("hardhat");

async function main() {
    const baseURI = "https://firebasestorage.googleapis.com/v0/b/dnft-demo.appspot.com/o/demo%2Fmetadata%2F4.json?alt=media";
    const couponAddress = "0x75A642CB8859f01d981f5b49C52E423d7Ac7c0d6";

    const token = await ethers.deployContract("Benefit", [baseURI, couponAddress]);

    console.log("Token address:", await token.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1)
    });

