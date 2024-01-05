//SPDX-License-Identifier: UNLICENSED
// forge coverage покрытие тестами
// forge test -vv
pragma solidity 0.8.0;

import {Test, console2, console, StdStyle} from "forge-std/Test.sol";
import {MyBank} from "../src/Bank.sol";
//import {SwapRouter} from "../lib/v3-periphery/contracts/SwapRouter.sol";

interface IWETH {
    function balanceOf(address) external view returns (uint256);
    function deposit() external payable;
}

contract BankTest is Test {
    MyBank public mybank;
    address user =  vm.addr(5555);
    address owner = makeAddr("owner");
    address myAccount = 0x6EfEB092CDCEB6Ba6B36029cB22706AacFD13251;   
    address HACKER = vm.addr(223343212432);  
    
    event WithdrawMaticFromContract (uint256 indexed nonce, uint256 amount, uint256 time);
     IWETH public weth;
    //  vm.prank(address(0));

    function setUp() public {
        
        mybank = new MyBank();
        vm.label(owner, "ADMIN");
        mybank.transferOwnership(owner);
        //console2.logAddress(owner);
         weth = IWETH(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270);
        
    }

    // test change fee by admin
    function test_changePoolFeeByOwner() public {
        // vm.prank(owner); 
        vm.startPrank(owner);
        mybank.changePoolFee(2000);
        vm.stopPrank();
    }
    
    // hackker can not change fee
    function testFail_changePoolFeeByHacker() public {
        vm.startPrank(HACKER);
        mybank.changePoolFee(2000);
        vm.stopPrank();
     }
       

    // test event - forge test --match-test WithdrawEvent
    function test_WithdrawEvent() public {
        vm.expectEmit(true, true, true, true);// Первые три устанавливаются для отслеживания indexed параметров в событии, последний - нужна ли проверка входных значений. 
        emit WithdrawMaticFromContract(1, 1e17, 101);
        vm.startPrank(owner);
        console.log("OWNER ADDRESS -----------", StdStyle.blue(owner));
        //console.log(block.timestamp);
        skip(100);// block.timestamp + 100
        //console.log(block.timestamp);
        vm.deal(address(mybank), 1 ether); // add on contract balance 1 ether
        mybank.withdrawMaticFromContract(payable(user), 1e17);
        vm.stopPrank();
       
    }

    function test_Fork() public {
        vm.createSelectFork("https://polygon-mainnet.infura.io/v3/f4fd8a2a087d41b2932479b13ab59435");
        uint256 balBefore = weth.balanceOf(myAccount);
        console.log("My account balance", StdStyle.red(balBefore));
    }
}