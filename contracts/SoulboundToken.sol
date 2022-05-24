// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title EthernautToken contract
 * @dev This is the implementation of the Ethernaut Token contract
 * @notice There is an uncapped amount of supply
 *         After minting, the token is soulbound. Can not be transferred.
 */
contract SoulboundToken is ERC20 {

    // -- States --
    address owner;
    mapping(address => bool) private minters;
    mapping(address => bool) private soulboundedAccounts;

   // -- Event --
    event MinterStatusUpdated(address indexed account, bool approval);

     /**
     * @dev Ethernaut Token Contract Constructor.
     * @param _initialSupply Initial supply of EXP
     */
    constructor(uint256 _initialSupply) ERC20("Ethernaut token", "EXP") {
        owner = msg.sender;

        //The owner has the initial supply of tokens
        _mint(owner, _initialSupply);

        //Disables transfer after mint
        _disableTransfer(owner);

        // The Owner of the contract is the default minter
        setApprovedMinter(owner, true);
        
    }

    // -- Modifiers --
    /**
     * @notice A modifier that authenticates the owner of the contract
    */
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    /**
     * @notice A modifier that validates addresses allowed to mint
    */
    modifier onlyMinter() {
        require(minters[msg.sender] == true, "Not minter");
        _;
    }

    /**
     * @dev Mint new tokens
     * @param _to Address to send the newly minted tokens
     * @param _amount The amount of tokens to send to the address
    */
    function mint(address _to, uint256 _amount) external onlyMinter {
        _mint(_to, _amount);
        _disableTransfer(_to);
    }

    /**
     * @dev Approves or renounces an account for minting
     * @param _account Account to approve or renounce
     * @param _approval Status of approval
    */
    function setApprovedMinter(address _account, bool _approval) public onlyOwner {
        minters[_account] = _approval;
        emit MinterStatusUpdated(_account, _approval);
    }

    /**
     * @dev Return if the _account is a minter or not
     * @param _account Account to check
     * @return True if the account is a minter 
    */
    function isMinter(address _account) external view returns(bool) {
        return minters[_account];
    }

    /**
     * @dev Disables the transfer feature of a soulbounded account
     * @param _account Account to check
    */
    function _disableTransfer(address _account) private {
        soulboundedAccounts[_account] = true;
    }

    /**
     * @dev Overriden in order to disable transfer
     */
    function _transfer(address from, address to, uint256 amount) internal virtual override {
        require(_canTransfer(owner), "Transfer Disabled");
        super._transfer(from, to, amount);
    }

    /**
     * @dev Return if the _account can transfer out tokens(soulbounded) or not
     * @param _account Account to check
     * @return False if the account is soulbounded 
    */
    function _canTransfer(address _account) private view returns(bool) {
        return !soulboundedAccounts[_account];
    }

}


  
