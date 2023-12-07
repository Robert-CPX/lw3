pragma solidity ^0.8.18;

contract HelloWorld {
    string hello = "hello";

    function helloWorld() public view returns (string memory) {
        return hello;
    }
}
