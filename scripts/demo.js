function logger() {
    const hexString = "0x000000000000000000000000000000000000000000000000000000000000000f"
    
    const intValue = parseInt(hexString, 16);
    console.log("Token address: %d", intValue);
}


logger()

