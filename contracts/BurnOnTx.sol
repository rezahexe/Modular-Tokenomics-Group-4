//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./utils/TokenBurner.sol";
import "forge-std/console.sol";

abstract contract BurnOnTx is ERC20 {

    using TokenBurner for TokenBurner.BurnData;

    TokenBurner.BurnData public burnData;

    constructor(uint256 _burnRate, uint256 _burnGoal, uint256 _burnUntil){
        burnData.burnRate = _burnRate;
        burnData.burnGoal = _burnGoal;
        burnData.burnUntil = _burnUntil;
        burnData.totalBurnt = 0;
    }

    //function setBurnRate(uint256 _newRate) public {
    //    // Add access control logic here (e.g., onlyOwner)
    //    burnData.burnRate = _newRate;
    //}
    
    function transfer(address to, uint256 value) public override virtual returns (bool status) {  
        
        uint256 valueToBurn = burnData._calculateBurnAmount(value);
        if (valueToBurn > 0){
            _burn(msg.sender, valueToBurn);
            burnData.totalBurnt += valueToBurn;
            value -= valueToBurn;
        }
        return super.transfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value) public override virtual returns (bool status) {
        uint256 valueToBurn = burnData._calculateBurnAmount(value);
        if (valueToBurn > 0){
            _burn(msg.sender, valueToBurn);
            burnData.totalBurnt += valueToBurn;
            value -= valueToBurn;
        }
        return super.transferFrom(from, to, value);
    }

}



/*
   // alternative strategy
    function burnTx(uint256 value) internal returns (uint) {        
        value -= burnRate;
        _burn(msg.sender, burnRate);
        return value;
    }
*/

/*
explanation

History

Real world example

Economics

Contract design

Contract solution



*/