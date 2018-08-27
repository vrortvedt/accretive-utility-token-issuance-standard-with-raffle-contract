pragma solidity ^0.4.24;

// This contract flattens OpenZeppelin's SafeMath.sol, ERC20.sol, Ownable.Sol
// and Pausable.sol.  It aslo relies on a tweaked version of  
// "StandardToken.sol" that modifies the mapping "balances" and the 
// global variable "totalSupply" to public from private 
// so that they can be viewed and called outside the contract.
// The unique code begins at line 405.

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    uint256 c = _a * _b;
    require(c / _a == _b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    require(_b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    require(_b <= _a);
    uint256 c = _a - _b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
    uint256 c = _a + _b;
    require(c >= _a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public onlyOwner whenPaused {
    paused = false;
    emit Unpause();
  }
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
  function totalSupply() public view returns (uint256);

  function balanceOf(address _who) public view returns (uint256);

  function allowance(address _owner, address _spender)
    public view returns (uint256);

  function transfer(address _to, uint256 _value) public returns (bool);

  function approve(address _spender, uint256 _value)
    public returns (bool);

  function transferFrom(address _from, address _to, uint256 _value)
    public returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

contract StandardTokenTweaked is ERC20 {
  using SafeMath for uint256;

  mapping (address => uint256) public balances;

  mapping (address => mapping (address => uint256)) private allowed;

  uint256 public totalSupply_;

  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /**
  * @dev Transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_value <= balances[msg.sender]);
    require(_to != address(0));

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    require(_to != address(0));

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    returns (bool)
  {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue >= oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Internal function that mints an amount of the token and assigns it to
   * an account. This encapsulates the modification of balances such that the
   * proper events are emitted.
   * @param _account The account that will receive the created tokens.
   * @param _amount The amount that will be created.
   */
  function _mint(address _account, uint256 _amount) internal {
    require(_account != 0);
    totalSupply_ = totalSupply_.add(_amount);
    balances[_account] = balances[_account].add(_amount);
    emit Transfer(address(0), _account, _amount);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account.
   * @param _account The account whose tokens will be burnt.
   * @param _amount The amount that will be burnt.
   */
  function _burn(address _account, uint256 _amount) internal {
    require(_account != 0);
    require(_amount <= balances[_account]);

    totalSupply_ = totalSupply_.sub(_amount);
    balances[_account] = balances[_account].sub(_amount);
    emit Transfer(_account, address(0), _amount);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account, deducting from the sender's allowance for said account. Uses the
   * internal _burn function.
   * @param _account The account whose tokens will be burnt.
   * @param _amount The amount that will be burnt.
   */
  function _burnFrom(address _account, uint256 _amount) internal {
    require(_amount <= allowed[_account][msg.sender]);

    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
    // this function needs to emit an event with the updated approval.
    allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
    _burn(_account, _amount);
  }
}

/**
 * @title Accretive Utility Token Raffle Contract
 * @author Victor Rortvedt victorrortvedt@gmail.com 
 * @dev Implementation of the accretive utility token issuance model with a simple raffle
 */
 
contract AUTRaffle is StandardTokenTweaked, Ownable, Pausable {
    event Award(address indexed toWinner, address indexed toDevs, uint256 amount);
    event OpenEvent(address indexed ownerAddress);
    event Entered(address indexed entrantAddress);

 /** 
  * @dev struct for competitions - here implemented as raffles 
  */
  
    struct Event {
        uint eventCount;
        address[] participants;
        uint mintedTokens;
        uint eventWinnerIndex;
        bool open;
    }

    string public name = "RaffleToken";
    string public symbol = "RFT";
    uint8 public decimals = 6;
    uint public INITIAL_SUPPLY = 0;
    address public owner;
    address public winner;
    
    Event public events;

  /**
   * @dev deployed instance of contract sets the owner, instantiates the token with a 0 balance, and provides the initial
   * @dev raffle status is set to closed
   */
    
    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[owner] = INITIAL_SUPPLY;
        owner = msg.sender;
        events.open = false;
        events.eventCount = 0;
    }

    /**
     *@dev function that runs when a raffle winner is picked - it inclements the token supply, transfers 7/8th of
     * @dev the newly minted tokens to the raffle winner and 1/8th to the contract owner, and emits the relevant Events
     * @param _toWinner the address of the raffle winner
     * @param _amount the amount of minted tokens that will be divided by the winner and the contract owner
     * @return bool as to whether it has been executed
     */
    
    function award(address _toWinner, uint256 _amount) private onlyOwner whenNotPaused returns (bool) {
        totalSupply_ = totalSupply_.add(_amount);
        uint256 winnerShare = (_amount / 8) * 7;
        uint256 devsShare = (_amount / 8) * 1;
    
        balances[_toWinner] = balances[_toWinner].add(winnerShare);
        balances[owner] = balances[owner].add(devsShare);
    
        emit Award(_toWinner, owner, _amount);
        emit Transfer(address(0), _toWinner, winnerShare);
        emit Transfer(address(0), owner, devsShare);
        return true;
    }

    /**
     * @dev function that can be called by the owner, opening a new raffle and emitting the relevant Event
     */
    
    function openEvent() public onlyOwner whenNotPaused {
        require(!events.open);
        events.open = true;
        events.eventCount = events.eventCount + 1;
        emit OpenEvent(msg.sender);
    }
    
    /**
     * @dev function that allows participants to enter open raffles, adding them to the array of participants
     * @dev limiting them to a single entry per address with the canEnter function below
     */
    
    function enter() external payable whenNotPaused {
        require(events.open);
        require(msg.sender != owner);
        require(canEnter());
        events.participants.push(msg.sender);
        emit Entered(msg.sender);
    }

    /**
     * @dev function that allows the owner to end an open raffle with at least 2 entrants by psuedorandomly choosing a winner, 
     * @dev closing the raffle, minting one new token per raffle entrant, calling the awrd function and clearing the 
     * @dev array of raffle entrants
     */
    
    function pickWinner() public onlyOwner whenNotPaused {
        require(events.participants.length > 1);
        require(events.open);
        events.open = false; 
        events.eventWinnerIndex = pseudoRandom() % events.participants.length;
        events.mintedTokens = events.participants.length * 1000000;
        winner = events.participants[events.eventWinnerIndex];
        award(winner, events.mintedTokens);
        delete events.participants;
    }
    
    /**
     * @dev view function that uses a hash of three pseudo-random elements to pseudorandomly return a number used in pickWinner
     * @return a uint that is used by pickWinner
     */
    
    function pseudoRandom() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, events.participants[0]));
    }
    
    /**
     * @dev view function that returns the array of raffle entrants 
     * @return the array of raffle entrants
     */
    
    function getParticipants() public view returns (address[]) {
        return events.participants;
    }
    
    /**
     * @dev view function that returns whether the raffle is open or closed
     * @return the bool status of whether the raffle is open or not
     */
    
    function eventStatus() public view returns (bool) {
        return events.open;
    }
    
    /**
     * @dev view function that checks whether an address is already in the array of entrants 
     * @dev used in enter function to prevent double entries
     * @return a bool as to whether an address may enter a raffle 
     */
    
    function canEnter() public view returns (bool) {
        for(uint i = 0; i < events.participants.length; i++) {
            require(events.participants[i] != msg.sender);
        }
        return true;
    }
}
