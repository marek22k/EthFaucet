
require "ethereum.rb"
require "eth"

CONTRACT_ABI = <<ABI
[
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "Received",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "requestor",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "friend",
				"type": "address"
			}
		],
		"name": "RequestForFriend",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "Send",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "fundsToSend",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "fundsToSendForFriends",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "addr",
				"type": "address"
			}
		],
		"name": "isFriendBlacklisted",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "addr",
				"type": "address"
			}
		],
		"name": "isRequestorBlacklisted",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "requestFaucet",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address payable",
				"name": "friendsAddr",
				"type": "address"
			}
		],
		"name": "requestFaucetFor",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"stateMutability": "payable",
		"type": "receive"
	}
]
ABI

CONTRACT_ADDRESS = "0xf1234DA990786218a9deDa7189Af65EED5585CBd"


rpc_client = Ethereum::HttpClient.new("https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161")
rpc_client.gas_price = rpc_client.eth_gas_price["result"].to_i(16)


def get_balance_of rpc_client, addr
  rpc_client.get_balance(addr)/1.0/(10**18)
end

key = Eth::Key.decrypt File.read('../priv/key.json'), "p455w0rD"
#puts "Server balance: #{get_balance_of rpc_client, key.address}"
#puts "Faucet balance: #{get_balance_of rpc_client, CONTRACT_ADDRESS}"

faucet = Ethereum::Contract.create(client: rpc_client, name: "Faucet", address: CONTRACT_ADDRESS, abi: CONTRACT_ABI)
faucet.key = key

if faucet.call.is_friend_blacklisted(ARGV[0])
  puts "blacklisted"
else
  puts faucet.transact.request_faucet_for(ARGV[0]).id
end

