// File: solidity-common\contracts\library\SafeMath.sol

pragma solidity >=0.5.0 <0.7.0;


library SafeMath {
    uint256 constant WAD = 10 ** 18;
    uint256 constant RAY = 10 ** 27;

    function wad() public pure returns (uint256) {
        return WAD;
    }

    function ray() public pure returns (uint256) {
        return RAY;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a <= b ? a : b;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function sqrt(uint256 a) internal pure returns (uint256 b) {
        if (a > 3) {
            b = a;
            uint256 x = a / 2 + 1;
            while (x < b) {
                b = x;
                x = (a / x + x) / 2;
            }
        } else if (a != 0) {
            b = 1;
        }
    }

    function wmul(uint256 a, uint256 b) internal pure returns (uint256) {
        return mul(a, b) / WAD;
    }

    function wmulRound(uint256 a, uint256 b) internal pure returns (uint256) {
        return add(mul(a, b), WAD / 2) / WAD;
    }

    function rmul(uint256 a, uint256 b) internal pure returns (uint256) {
        return mul(a, b) / RAY;
    }

    function rmulRound(uint256 a, uint256 b) internal pure returns (uint256) {
        return add(mul(a, b), RAY / 2) / RAY;
    }

    function wdiv(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(mul(a, WAD), b);
    }

    function wdivRound(uint256 a, uint256 b) internal pure returns (uint256) {
        return add(mul(a, WAD), b / 2) / b;
    }

    function rdiv(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(mul(a, RAY), b);
    }

    function rdivRound(uint256 a, uint256 b) internal pure returns (uint256) {
        return add(mul(a, RAY), b / 2) / b;
    }

    function wpow(uint256 x, uint256 n) internal pure returns (uint256) {
        uint256 result = WAD;
        while (n > 0) {
            if (n % 2 != 0) {
                result = wmul(result, x);
            }
            x = wmul(x, x);
            n /= 2;
        }
        return result;
    }

    function rpow(uint256 x, uint256 n) internal pure returns (uint256) {
        uint256 result = RAY;
        while (n > 0) {
            if (n % 2 != 0) {
                result = rmul(result, x);
            }
            x = rmul(x, x);
            n /= 2;
        }
        return result;
    }
}

// File: node_modules\solidity-common\contracts\library\Array.sol

pragma solidity >=0.5.0 <0.7.0;


library Array {

    function remove(bytes32[] storage array, bytes32 element) internal returns (bool) {
        for (uint256 index = 0; index < array.length; index++) {
            if (array[index] == element) {
                delete array[index];
                array[index] = array[array.length - 1];
                array.length--;
                return true;
            }
        }
        return false;
    }


    function remove(address[] storage array, address element) internal returns (bool) {
        for (uint256 index = 0; index < array.length; index++) {
            if (array[index] == element) {
                delete array[index];
                array[index] = array[array.length - 1];
                array.length--;
                return true;
            }
        }
        return false;
    }
}

// File: node_modules\solidity-common\contracts\library\Roles.sol

pragma solidity >=0.5.0 <0.7.0;


library Roles {

    struct Role {
        mapping(address => bool) bearer;
    }


    function add(Role storage role, address account) internal {
        require(account != address(0), "Roles: account is the zero address");
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }


    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }


    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

// File: node_modules\solidity-common\contracts\common\Ownable.sol

pragma solidity >=0.5.0 <0.7.0;


contract Ownable {
    address private _owner;

    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function isOwner(address account) public view returns (bool) {
        return account == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }


    modifier onlyOwner() {
        require(isOwner(msg.sender), "Ownable: caller is not the owner");
        _;
    }


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
}

// File: solidity-common\contracts\access\WhitelistedRole.sol

pragma solidity >=0.5.0 <0.7.0;


contract WhitelistedRole is Ownable {
    using Roles for Roles.Role;
    using Array for address[];

    Roles.Role private _whitelisteds;
    address[] public whitelisteds;

    constructor () internal {}

    function _addWhitelisted(address account) internal {
        _whitelisteds.add(account);
        whitelisteds.push(account);
        emit WhitelistedAdded(account);
    }

    function addWhitelisted(address account) public onlyOwner {
        _addWhitelisted(account);
    }

    function addWhitelisted(address[] memory accounts) public onlyOwner {
        for (uint256 index = 0; index < accounts.length; index++) {
            _addWhitelisted(accounts[index]);
        }
    }

    function _delWhitelisted(address account) internal {
        _whitelisteds.remove(account);

        if (whitelisteds.remove(account)) {
            emit WhitelistedRemoved(account);
        }
    }

    function renounceWhitelisted() public {
        _delWhitelisted(msg.sender);
    }

    function delWhitelisted(address account) public onlyOwner {
        _delWhitelisted(account);
    }

    function getWhitelistedsLength() public view returns (uint256) {
        return whitelisteds.length;
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _whitelisteds.has(account);
    }


    modifier onlyWhitelisted() {
        require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the whitelisted role");
        _;
    }

    modifier onlyWhitelisting(address account) {
        require(isWhitelisted(account), "WhitelistedRole: caller does not have the whitelisted role");
        _;
    }


    event WhitelistedAdded(address indexed account);
    event WhitelistedRemoved(address indexed account);
}

// File: contracts\interface\IBtswapMinter.sol

pragma solidity >=0.5.0 <0.7.0;


interface IBtswapMinter {

    function liquidity(address account, address pair) external returns (bool);

}

// File: contracts\interface\IBtswapToken.sol

pragma solidity >=0.5.0 <0.7.0;


interface IBtswapToken {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function mint(address account, uint256 amount) external returns (bool);

    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

}

// File: contracts\interface\IBtswapPairToken.sol

pragma solidity >=0.5.0 <0.7.0;


interface IBtswapPairToken {
    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function router() external view returns (address);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to) external returns (uint256 amount0, uint256 amount1);

    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address, address) external;

    function price(address token) external view returns (uint256);


    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
    event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
    event Sync(uint112 reserve0, uint112 reserve1);

}

// File: contracts\interface\IBtswapRouter02.sol

pragma solidity >=0.5.0 <0.7.0;


interface IBtswapRouter02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function minter() external pure returns (address);

    function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);

    function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external view returns (uint256 amountB);

    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountOut);

    function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external view returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);

    function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;

    function weth(address token) external view returns (uint256);

    function onTransfer(address sender, address recipient) external returns (bool);

}

// File: contracts\biz\BtswapMinter.sol

pragma solidity >=0.5.0 <0.7.0;


contract BtswapMinter is IBtswapMinter, WhitelistedRole {
    using SafeMath for uint256;

    uint256 public constant MINT_DECAY_DURATION = 1051200;
    uint256 public INITIAL_BLOCK_REWARD = SafeMath.wad().mul(56).mul(8).div(10);
    uint256 public PERCENTAGE_FOR_TAKER = SafeMath.wad().mul(375).div(1000);
    uint256 public PERCENTAGE_FOR_MAKER = SafeMath.wad().mul(625).div(1000);
    address public TAKER_ADDRESS;

    IBtswapRouter02 private _router;
    IBtswapToken private _token;

    uint256 private _initMintBlock;
    uint256 private _lastMintBlock;
    mapping(address => uint256) private _weights;

    Pool public maker;

    struct Pool {
        uint256 timestamp;
        uint256 quantity;
        uint256 deposit;
        mapping(address => User) users;
    }

    struct User {
        uint256 timestamp;
        uint256 quantity;
        uint256 deposit;
        mapping(address => uint256) deposits;
    }

    constructor (uint256 startBlock_) public {
        _setInitMintBlock(startBlock_);
        _setLastMintBlock(startBlock_);
    }


    /**
     * dao
     */
    function router() public view returns (IBtswapRouter02) {
        return _router;
    }

    function setRouter(IBtswapRouter02 newRouter) public onlyOwner {
        require(address(newRouter) != address(0), "BtswapMinter: new router is the zero address");
        _router = newRouter;
    }

    function token() public view returns (IBtswapToken) {
        return _token;
    }

    function setToken(IBtswapToken newToken) public onlyOwner {
        require(address(newToken) != address(0), "BtswapMinter: new btswap token is the zero address");
        _token = newToken;
    }

    function setTakerAddress(address newTakerAddress) public onlyOwner {
        require(newTakerAddress != address(0), "BtswapMinter: new taker address is the zero address");
        TAKER_ADDRESS = newTakerAddress;
    }

    function setTakerPercentage(uint256 newPercentage) public onlyOwner {
        require(newPercentage <= SafeMath.wad(), "BtswapMinter: new taker percentage overflow");
        PERCENTAGE_FOR_TAKER = newPercentage;
        PERCENTAGE_FOR_MAKER = SafeMath.wad().sub(PERCENTAGE_FOR_TAKER);
    }

    function initMintBlock() public view returns (uint256) {
        return _initMintBlock;
    }

    function _setInitMintBlock(uint256 blockNumber) internal {
        _initMintBlock = blockNumber;
    }

    function lastMintBlock() public view returns (uint256) {
        return _lastMintBlock;
    }

    function _setLastMintBlock(uint256 blockNumber) internal {
        _lastMintBlock = blockNumber;
    }

    function weightOf(address pairToken) public view returns (uint256) {
        uint256 _weight = _weights[pairToken];

        if (_weight > 0) {
            return _weight;
        }

        return 1;
    }

    function setWeight(address newPairToken, uint256 newPairWeight) public onlyOwner {
        require(address(newPairToken) != address(0), "BtswapMinter: new pair token is the zero address");
        _weights[newPairToken] = newPairWeight;
    }


    /**
     * miner
     */
    function phase(uint256 blockNumber) public view returns (uint256) {
        uint256 _phase = 0;

        if (blockNumber > initMintBlock()) {
            _phase = (blockNumber.sub(initMintBlock()).sub(1)).div(MINT_DECAY_DURATION);
        }

        return _phase;
    }

    function phase() public view returns (uint256) {
        return phase(block.number);
    }

    function reward(uint256 blockNumber) public view returns (uint256) {
        uint256 _phase = phase(blockNumber);
        if (_phase >= 10) {
            return 0;
        }

        return INITIAL_BLOCK_REWARD.div(2 ** _phase);
    }

    function reward() public view returns (uint256) {
        return reward(block.number);
    }

    function mintable(uint256 blockNumber) public view returns (uint256) {
        uint256 _mintable = 0;
        uint256 lastMintableBlock = lastMintBlock();
        uint256 n = phase(lastMintBlock());
        uint256 m = phase(blockNumber);

        while (n < m) {
            n++;
            uint256 r = n.mul(MINT_DECAY_DURATION).add(initMintBlock());
            _mintable = _mintable.add((r.sub(lastMintableBlock)).mul(reward(r)));
            lastMintableBlock = r;
        }
        _mintable = _mintable.add((blockNumber.sub(lastMintableBlock)).mul(reward(blockNumber)));

        return _mintable;
    }

    function mint() public returns (bool) {
        if (!isMintable()) {
            return false;
        }

        uint256 _mintable = mintable(block.number);
        if (_mintable <= 0) {
            return false;
        }

        _setLastMintBlock(block.number);

        uint256 takerMintable = _mintable.wmul(PERCENTAGE_FOR_TAKER);
        uint256 makerMintable = _mintable.sub(takerMintable);

        if (takerMintable > 0) {token().mint(TAKER_ADDRESS, takerMintable);}
        if (makerMintable > 0) {token().mint(address(this), makerMintable);}

        return true;
    }


    /**
     * oracle
     */
    function weth(address pairToken, uint256 amount) public view returns (uint256) {
        uint256 _weth = router().weth(pairToken);
        if (_weth <= 0) {
            return 0;
        }

        return _weth.wmul(amount);
    }

    function rebalance(address account, address pair) public view returns (uint256) {
        if (!isWhitelisted(IBtswapPairToken(pair).token0()) || !isWhitelisted(IBtswapPairToken(pair).token1())) {
            return 0;
        }

        uint256 m = IBtswapPairToken(pair).totalSupply();
        uint256 n = IBtswapPairToken(pair).balanceOf(account);
        if (n <= 0 || m <= 0) {
            return 0;
        }

        (uint112 reserve0, uint112 reserve1,) = IBtswapPairToken(pair).getReserves();
        uint256 _weth0 = weth(IBtswapPairToken(pair).token0(), uint256(reserve0));
        uint256 _weight0 = weightOf(IBtswapPairToken(pair).token0());
        uint256 _weth1 = weth(IBtswapPairToken(pair).token1(), uint256(reserve1));
        uint256 _weight1 = weightOf(IBtswapPairToken(pair).token1());

        uint256 _weth = _weth0.mul(_weight0).add(_weth1.mul(_weight1));

        return _weth.mul(n).div(m);
    }


    /**
     * maker
     */
    function liquidityOf(address account) public view returns (uint256, uint256) {
        uint256 m = makerQuantityOfPool().add(makerDepositOfPool().mul(block.number.sub(makerTimestampOfPool())));
        uint256 n = makerQuantityOf(account).add(makerDepositOf(account).mul(block.number.sub(makerTimestampOf(account))));

        return (m, n);
    }

    function makerQuantityOfPool() public view returns (uint256) {
        return maker.quantity;
    }

    function makerDepositOfPool() public view returns (uint256) {
        return maker.deposit;
    }

    function makerTimestampOfPool() public view returns (uint256) {
        return maker.timestamp;
    }

    function makerQuantityOf(address account) public view returns (uint256) {
        return maker.users[account].quantity;
    }

    function makerDepositOf(address account) public view returns (uint256) {
        return maker.users[account].deposit;
    }

    function makerLastDepositOf(address account, address pair) public view returns (uint256) {
        return maker.users[account].deposits[pair];
    }

    function makerTimestampOf(address account) public view returns (uint256) {
        return maker.users[account].timestamp;
    }

    function _makerBalanceAndLiquidityOf(address account) internal view returns (uint256, uint256, uint256) {
        (uint256 m, uint256 n) = liquidityOf(account);
        if (n <= 0 || m <= 0) {
            return (0, m, n);
        }

        if (n == m) {
            return (makerBalanceOf(), m, n);
        }

        return (makerBalanceOf().mul(n).div(m), m, n);
    }

    function makerBalanceOf() public view returns (uint256) {
        return token().balanceOf(address(this));
    }

    function makerBalanceOf(address account) public view returns (uint256) {
        (uint256 balance, ,) = _makerBalanceAndLiquidityOf(account);
        return balance;
    }

    function liquidity(address account, address pair) public onlyRouter returns (bool) {
        require(account != address(0), "BtswapMinter: maker liquidity account is the zero address");
        require(pair != address(0), "BtswapMinter: maker liquidity pair is the zero address");

        mint();

        User storage user = maker.users[account];
        uint256 deposit = rebalance(account, pair);
        uint256 previous = makerLastDepositOf(account, pair);

        (uint256 m, uint256 n) = liquidityOf(account);
        maker.quantity = m;
        maker.timestamp = block.number;
        maker.deposit = makerDepositOfPool().add(deposit).sub(previous);

        user.quantity = n;
        user.timestamp = block.number;
        user.deposit = makerDepositOf(account).add(deposit).sub(previous);
        user.deposits[pair] = deposit;

        return true;
    }

    function _makerWithdraw(address account) internal returns (bool) {
        require(account != address(0), "BtswapMinter: maker withdraw account is the zero address");

        (uint256 withdrawn, uint256 m, uint256 n) = _makerBalanceAndLiquidityOf(account);
        if (withdrawn <= 0) {
            return false;
        }

        User storage user = maker.users[account];
        maker.timestamp = block.number;
        maker.quantity = m.sub(n);
        user.timestamp = block.number;
        user.quantity = 0;

        uint256 balance = makerBalanceOf();
        if (withdrawn > balance) {
            token().transfer(account, balance);
        } else {
            token().transfer(account, withdrawn);
        }

        return true;
    }

    function makerWithdraw() public returns (bool) {
        mint();

        return _makerWithdraw(msg.sender);
    }


    /**
     * modifier
     */
    function isMintable() public view returns (bool) {
        if (block.number > lastMintBlock() && block.number.sub(lastMintBlock()) > 0 && reward(lastMintBlock()) > 0) {
            return true;
        }
        return false;
    }

    function isRouter(address account) public view returns (bool) {
        return account == address(router());
    }

    modifier onlyRouter() {
        require(isRouter(msg.sender), "BtswapMinter: caller is not the router");
        _;
    }

}
