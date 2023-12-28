// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {
    address public depositor;
    address public arbiter;
    address public beneficiary;

    event Approved(uint256 indexed tranferredAmount);

    modifier onlyOwner() {
        require(msg.sender == depositor, "You're NOT the owner / Depositor!");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "You're NOT the Arbiter!");
        _;
    }

    constructor(address _arbiter, address _beneficiary) payable {
        depositor = msg.sender;
        arbiter = _arbiter;
        beneficiary = _beneficiary;
    }

    // error NotArbiter(string msg);

    /// @notice the Arbiter would approve whenever the service/good has been provided
    function approve() external onlyArbiter {
        // if (msg.sender != arbiter) {
        // revert NotArbiter("You're NOT the Arbiter!");
        // }
        uint256 contractBalance = address(this).balance;
        (bool success, ) = beneficiary.call{value: contractBalance}("");
        require(success);

        emit Approved(contractBalance);
    }

    /// @notice the Escrow contract can only be cancelled by the depositor
    function cancel() external onlyOwner {
        // It wouldn't be appropriate to use selfdestruct() now, since SELFDESTRUCT opcode has been deprecated (eip-6049)
        selfdestruct(payable(depositor));
    }
}
