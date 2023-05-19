// SPDX-License-Identifier: MIT


pragma solidity 0.8.17;


import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract smartPulse is ERC20 {
    event earnStage(
        address indexed User, 
        uint256 indexed level, 
        uint256 indexed reward
    );

    event lvlUp(
        address indexed User,
        uint256 indexed level,
        uint256 indexed reward
    );

    event lvlEnded(
        address indexed User,
        uint256 indexed level,
        bool indexed ended
    );


    struct User{
        uint256 level;
        uint256 lastEarned;
        uint256 reward;
    }
 
    address owner;
    mapping(address => User) lvl;
    mapping(address => bool) lvlFinished;
    mapping(address => uint256) amountMinted;

    constructor() ERC20("smartCoin", "SMC"){
        
        owner = msg.sender;

    }

    function mint(uint amount) public { 

        _mint(owner, amount * 10**decimals());
        amountMinted[msg.sender] = amount;
    }

    function increaseLevel() public returns(bool success) {
        User storage user = lvl[msg.sender];
        user.level += 1;
        user.reward += user.level;
        lvlFinished[msg.sender] =  false;
        success = true;

        emit lvlUp(msg.sender, user.level, user.reward);
    }

    function finishLvl() public {
        User storage user = lvl[msg.sender];
        require(increaseLevel(), "no lvl started");
        lvlFinished[msg.sender] = true;
        bool ended = true;

        emit lvlEnded(msg.sender, user.level, ended);

    }
    function earn() public {
        require(lvlFinished[msg.sender] == true, "Current level still on ended");
        User storage user = lvl[msg.sender];
        
        require(user.reward > 0, "No reward available for user");
        uint256 stage = user.reward;
        _mint(msg.sender, stage * 10**decimals());
        user.reward -= stage;
        user.lastEarned = stage;
        amountMinted[msg.sender] = stage;

        emit earnStage(msg.sender, user.level, user.lastEarned);
    }

    
    
}