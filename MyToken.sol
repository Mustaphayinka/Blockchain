// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    bool private _paused;

    constructor() ERC20("MyToken", "MTK") Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * 10**18); // Mint 1,000,000 tokens and send them to the contract deployer
        _paused = false; // Initialize the contract as unpaused
    }
    
    function transfer(address recipient, uint256 amount) public virtual override whenNotPaused returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return super.balanceOf(account);
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override whenNotPaused returns (bool) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), allowance(sender, _msgSender()) - amount);
        return true;
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function pause() public onlyOwner {
        _paused = true;
    }

    function unpause() public onlyOwner {
        _paused = false;
    }

    modifier whenNotPaused() {
        require(!_paused, "ERC20: token transfer while paused");
        _;
    }
}
