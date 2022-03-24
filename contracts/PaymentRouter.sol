// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./token/ERC20/IERC20.sol";

contract PaymentRouter {
    
    address payable recipient;
    address public TOKEN;
    address public ADMIN;
    mapping(uint => uint256) priceETHMapping;
    mapping(address => mapping(uint => uint256)) priceProvider;

    constructor(address _token, address _recipient) {
        ADMIN = msg.sender;

        setToken(_token);
        setRecipient(_recipient);

        setPriceETH(1, 10 * (10 ** 18));
        setPriceETH(2, 5 * (10 ** 18));
        setPriceETH(3, 2 * (10 ** 18));

        uint256 _decimals = IERC20(_token).decimals();
        setPrice(1, 30000 * (10 ** _decimals));
        setPrice(2, 10000 * (10 ** _decimals));
        setPrice(3, 5000 * (10 ** _decimals));

    }

    event Payment(address indexed sender, bytes signature, uint func);

    modifier onlyAdmin() {
        require(msg.sender == ADMIN, "caller is not the admin");
        _;
    }
    
    function doPaymentETH(bytes memory signature, uint func)  public payable  {
        uint256 _price = priceETH(func);
        require(_price > 0, "No price defined");
        require(msg.value == _price, "Incorrect amount");
        recipient.transfer(msg.value);
        emit Payment(msg.sender, signature, func);
    }

    function doPayment(bytes memory signature, uint func) public virtual {
        uint256 _price = price(func);
        require(_price > 0, "No price defined");
        uint256 allowanceValue = IERC20(TOKEN).allowance(msg.sender, address(this));
        require(allowanceValue >= _price, "INSUFFICIENT_ALLOWANCE");
        bool success = IERC20(TOKEN).transferFrom(msg.sender, recipient, _price);
        require(success, "TRANSFER_FROM_FAILED");
        emit Payment(msg.sender, signature, func);
    }

    function price(uint func) public view returns(uint256) {
        return priceProvider[TOKEN][func];
    }

    function priceETH(uint func) public view returns(uint256) {
        return priceETHMapping[func];
    }
    
    function setPrice(uint func, uint256 _price) public onlyAdmin virtual {
        priceProvider[TOKEN][func] = _price;
    }

    function setPriceETH(uint func, uint256 _price) public onlyAdmin virtual {
        priceETHMapping[func] = _price;
    }

    function setToken(address _token) public onlyAdmin virtual {
        TOKEN = _token;
    }

    function setAdmin(address _admin) public onlyAdmin virtual {
        ADMIN = _admin;
    }

    function setRecipient(address _recipient) public onlyAdmin virtual {
        recipient = payable(_recipient);
    }

    
}