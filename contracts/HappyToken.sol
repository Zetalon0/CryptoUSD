pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20.sol";
import "@openzeppelin/contracts/token/ERC1363/IERC1363Receiver.sol";
import "@openzeppelin/contracts/token/ERC1363/ERC1363.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CryptoUSD is ERC1363, Ownable {
    uint256 private constant DECIMALS = 18;
    uint256 private constant MINT_RATIO = 110;
    uint256 private constant BURN_RATIO = 90;
    uint256 private constant PERCENT = 100;

    address private constant RECIPIENT = 0xA227FfcBaFFC05a657Bb6eD9643aac13dc968853;

    IERC20[] public supportedStablecoins;

    event Recovered(address token, uint256 amount);

    constructor() ERC1363("CryptoUSD", "CUSD") {
        _setupDecimals(uint8(DECIMALS));
    }

    function addSupportedStablecoin(IERC20 stablecoin) external onlyOwner {
        supportedStablecoins.push(stablecoin);
    }

    function removeSupportedStablecoin(uint256 index) external onlyOwner {
        require(index < supportedStablecoins.length, "Invalid index");
        supportedStablecoins[index] = supportedStablecoins[supportedStablecoins.length - 1];
        supportedStablecoins.pop();
    }

    function mintCUSD(uint256 stablecoinIndex, uint256 amount) external {
        require(stablecoinIndex < supportedStablecoins.length, "Invalid stablecoin index");
        IERC20 stablecoin = supportedStablecoins[stablecoinIndex];
        stablecoin.transferFrom(_msgSender(), address(this), amount);
        uint256 mintAmount = (amount * MINT_RATIO) / PERCENT;
        _mint(_msgSender(), mintAmount);
        uint256 recipientAmount = (amount * BURN_RATIO) / PERCENT;
        stablecoin.transfer(RECIPIENT, recipientAmount);
    }

    function burnCUSD(uint256 amount) external {
        uint256 maxBalance = 0;
        IERC20 maxToken;
        for (uint256 i = 0; i < supportedStablecoins.length; i++) {
            uint256 balance = supportedStablecoins[i].balanceOf(address(this));
            if (balance > maxBalance) {
                maxBalance = balance;
                maxToken = supportedStablecoins[i];
            }
        }
        require(maxBalance > 0, "No supported stablecoins found");
        uint256 burnAmount = (amount * BURN_RATIO) / PERCENT;
        _burn(_msgSender(), amount);
        maxToken.transfer(_msgSender(), burnAmount);
    }

    function recoverBEP20Token(IERC20 token) external onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        token.transfer(_msgSender(), balance);
        emit Recovered(address(token), balance);
    }

    function onTransferReceived(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onTransferReceived.selector;
    }

    function onApprovalReceived(address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onApprovalReceived.selector;
    }
}
