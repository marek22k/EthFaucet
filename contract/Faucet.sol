// SPDX-License-Identifier: WTFPL

pragma solidity ^0.8.9;

/*
    The faucet is designed to just give you some "change" to get started. However,
    since you don't have any money yourself at the start and therefore cannot do the
    faucet, there is a "friends" function. A friend can make a request to the faucet
    and you only get enough that you can make a request to the faucet yourself. From
    this you get your starting credit. You can request a maximum of once for a friend,
    but for any number of friends. You can only use the faucet once yourself. This is
    to reduce the risk of faucet abuse.
    
    When implementing a Faucet website, it is advisable to have a "secret" account that
    uses the Faucet's friend function. So you can use the Faucet even without an active
    friend with credit.
    
    To reduce the risk of misusing the faucet, it is advisable to add a captcha to
    the website.
*/

contract Faucet {
    /* Is triggered when receiving money, i.e. donations for the faucet. */
	event Received(uint amount);
	
	/* Triggered every time money is sent. */
	event Send(uint amount);
	
	/* This event is there to monitor which friend is requesting what money.
	It is triggered when the "Friends" function is used. */
	event RequestForFriend(address requestor, address friend);
	
	/* Amount to be sent when the faucet is requested. */
	uint public fundsToSend = 0.1 * 10 ** 18;
	/* Amount to be sent to a friend as starting credit. */
	uint public fundsToSendForFriends = 0.001 * 10 ** 18;
	
	/* Saves the requests so that everyone can only use the faucet once. */
	mapping(address => bool) internal requestors;
	
	/* Stores friends' addresses. So that you can only use
	the faucet once for your friends. */
	mapping(address => bool) internal requestorsFriends;
	
	/* Receives yellow and triggers the send event. */
	receive() external payable {
	    emit Received(msg.value);
	}
	
	/* Returns true if addr (the first argument) has already used the faucet
	and can no longer use it. Otherwise false. */
	function isRequestorBlacklisted(address addr) public view returns(bool) {
	    return requestors[addr];
	}
	
	/* Returns true if the faucet has already been used for a friend with the
	address addr (the first argument) and can therefore no longer be used.
	Otherwise false. */
	function isFriendBlacklisted(address addr) public view returns(bool) {
	    return requestorsFriends[addr];
	}
	
	/* The function is used to request a minimum amount for a friend
	to use the faucets. The friend's address is expected as an argument. */
	function requestFaucetFor(address payable friendsAddr) public {
	    require(! requestorsFriends[friendsAddr]);
	    require(address(this).balance > fundsToSendForFriends);
	    
	    requestorsFriends[friendsAddr] = true;
	    emit Send(fundsToSendForFriends);
	    emit RequestForFriend(msg.sender, friendsAddr);
	    
	    friendsAddr.transfer(fundsToSendForFriends);
	}
	
	/* Function that requests money from the faucet for the sender. */
	function requestFaucet() public {
	    require(! requestors[msg.sender]);
	    require(address(this).balance > fundsToSend);
	    
	    requestors[msg.sender] = true;
	    emit Send(fundsToSend);
	    
	    payable(msg.sender).transfer(fundsToSend);
	}
}

