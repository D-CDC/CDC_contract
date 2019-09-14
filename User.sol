pragma solidity ^0.5.7;import "./Car.sol";contract User{    address public manager ;    address  public carInfo; // car Info    struct UserDetail{        string ui_name; // user name        address ui_walletAddr;// user wallet address        uint256[] ui_carId; // car info    }    uint256 public UID;    mapping(address=>UserDetail) public userInfo;    mapping(address=>uint256) public userAddrToID;    constructor() public {        manager  = msg.sender ;    }    modifier onlyManager(){       require(msg.sender == manager,"onlyManager can do");       _;    }    /**     * @dev register a new user .     * @param _name name of user     * @param walletAddr wallet address for user     * @return userId olny ID for user     */    function registerUser(string memory _name, address walletAddr) public onlyManager returns(uint256 userId){        require(walletAddr != address(0),"walletAddr can not be zero");        userId = userAddrToID[walletAddr];        if(userId == 0){            //new one            uint256[] memory carID;            UserDetail memory  uDetail = UserDetail(_name,walletAddr,carID);            UID++;            userInfo[walletAddr] = uDetail;            userAddrToID[walletAddr] = UID;            userId = UID;        }    }    // set contract address    function setCarContractAddr(address carContractAddr) onlyManager public{        uint256 size;        // solium-disable-next-line security/no-inline-assembly        assembly { size := extcodesize(carContractAddr) }        require(size > 0 ,"carContractAddr not contract addr");        carInfo = carContractAddr;    }    /**     * @dev boundCar a user bound car to this  .     * @param walletAddr user wallet address     * @param _carProducter car info     * @param _carType car info     * @param _carNumber car info     * @param _listingTime car info     */    function boundCar(address walletAddr,        bytes32 _carProducter,        bytes32 _carType,        bytes32 _carNumber,        uint256 _listingTime)        public        onlyManager    {        uint256 userid = userAddrToID[walletAddr];        require(userid !=0,"user not register");        uint256 carid ;        carid = Car(carInfo).getCarID(_carProducter,_carType,_carNumber,_listingTime);        require(carid != 0,"car not register ");        UserDetail storage uDetail = userInfo[walletAddr];        uDetail.ui_carId.push(carid);    }}