//It doesn't work at the moment

//SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

import "./Allowance.sol";

contract ChildrenWallet is Allowance {

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawMoney(address payable _to, uint _amount, uint _paymentTime) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Contract doesn't own enough money");
        require(_paymentTime > block.timestamp, "Payment time must be in the future");

        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }

        emit MoneySent(_to, _amount);

        if (block.timestamp >= _paymentTime) {
            _to.transfer(_amount);
        }
    }

    function renounceOwnership() public override onlyOwner {
        revert("can't renounceOwnership here"); //not possible with this smart contract
    }

    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}
