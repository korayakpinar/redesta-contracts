//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract RedestaToken is ERC20 {
    IERC20 DAIContract = IERC20(0xFc7215C9498Fc12b22Bc0ed335871Db4315f03d3);

    uint decimalss = 10**18;
    uint cutPercentage = 5;

    constructor() ERC20("Redesta", "RDT") {
        _mint(msg.sender, 100000 * 10 ** 18);
    }

    function extractDAI(uint amount) public {
        require(balanceOf(msg.sender)>=amount*decimalss, "You can not do this.");
        //DAIContract.approve(address(this), amount);
        DAIContract.transfer(msg.sender, amount*decimalss* ((100-cutPercentage)/100) );
        _burn(msg.sender, amount*decimalss );
    }

    function mintRDS(uint amount) public {
        //DAIContract.transferFrom(msg.sender, address(this), amount * decimalss);
        _mint(msg.sender, amount*decimalss * ((100-cutPercentage)/100) );
    }
}