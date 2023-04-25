CryptoUSD (CUSD) Token
CryptoUSD (CUSD) is a cryptocurrency built on the Binance Smart Chain (BSC) that extends the BEP20 token standard with ERC1363 capabilities. The token allows users to mint and burn CUSD tokens in exchange for supported stablecoins while providing a mechanism for the contract owner to recover any BEP20 tokens sent to the contract by error.

Features
ERC1363 Token: An extension of BEP20 that can make a callback on the receiver contract to notify token transfers or token approvals.
Minting: Users can mint CryptoUSD tokens by sending USDT, USDC, BUSD, DAI, or TUSD to the smart contract at a ratio of 1.1:1.
Burning: Users can burn CryptoUSD tokens in exchange for the stablecoin with the maximum balance in the contract at a ratio of 0.9:1.
Manual Burning: The token can be manually burned to reduce the circulating supply.
Recover BEP20 Tokens: The contract owner can recover any BEP20 token sent to the contract by error.
Unlimited Supply: Only the smart contract can mint CryptoUSD tokens.
Supported Stablecoins Management: The contract owner can add or remove supported stablecoins.
Getting Started
To use the CryptoUSD smart contract, follow these steps:

Deploy the CryptoUSD.sol contract on the Binance Smart Chain.
Call the addSupportedStablecoin() function to add supported stablecoins, such as USDT, USDC, BUSD, DAI, and TUSD.
Users can mint CUSD tokens by calling the mintCUSD() function and sending the corresponding amount of stablecoins.
Users can burn CUSD tokens by calling the burnCUSD() function and receive the stablecoin with the maximum balance in the contract.
If required, the contract owner can recover any BEP20 tokens sent to the contract by error by calling the recoverBEP20Token() function.
Contract Functions
addSupportedStablecoin(IERC20 stablecoin)
Adds a supported stablecoin to the list. Only callable by the contract owner.

removeSupportedStablecoin(uint256 index)
Removes a supported stablecoin from the list using its index. Only callable by the contract owner.

mintCUSD(uint256 stablecoinIndex, uint256 amount)
Mints CryptoUSD tokens by sending a supported stablecoin to the smart contract. Users will receive CryptoUSD tokens at a 1.1:1 ratio.

burnCUSD(uint256 amount)
Burns CryptoUSD tokens and returns the stablecoin with the maximum balance in the contract at a 0.9:1 ratio.

recoverBEP20Token(IERC20 token)
Allows the contract owner to recover any BEP20 token sent to the contract by error.

onTransferReceived(address, address, uint256, bytes memory)
Implements the ERC1363Receiver interface for notifying token transfers.

onApprovalReceived(address, uint256, bytes memory)
Implements the ERC1363Receiver interface for notifying token approvals.

License
This project is licensed under the MIT License.
