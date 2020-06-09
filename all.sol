// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;

contract SimpleAuction {
    bool private first = false;
    bool private second = false;

    address public one;
    address public two;

    function invest(address _one, address _two) external payable {
        if(msg.value < 1000){
            revert("to small");
        }
        if(first == true || second == true){
            revert("still not finish last payment");
        }
        one = _one;
        two = _two;
        first = false;
        second = false;
    }

    function turnOnOne() external{
        require(msg.sender == one, "no permission");
        first = true;
    }

    function turnOnTwo() external{
        require(msg.sender == two,  "no permission");
        second = true;
    }

    function sendEther(address payable recipient) external{
        require(msg.sender == two || msg.sender == one,  "no permission");
        if(first == true && second == true){
            recipient.transfer(address(this).balance);
            first = false;
            second = false;
        }else{
            revert("still not agree the payment");
        }

    }

    function balanceOf() external view returns(uint){
        return address(this).balance;
    }
}