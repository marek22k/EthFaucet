
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

class EthNetwork
  
  def initialize rpc
    @rpc_client = Ethereum::HttpClient.new(rpc)
    @rpc_client.gas_price = @rpc_client.eth_gas_price["result"].to_i(16)
  end
  
  def get_balance_of addr
    @rpc_client.get_balance(addr)/1.0/(10**18)
  end
  
end

net = EthNetwork.new "https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"

key = Eth::Key.decrypt File.read('./some/path.json'), 'p455w0rD'