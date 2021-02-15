pragma solidity >=0.7.0 <0.8.0;

// Initializaation of contract

contract MyContract{
    mapping(address => string) public producers;
    
    int public totalProduct = 0;
    int public totalOrder = 0;
    
    // Product Structure

    struct product{
        int id;
        int price;
        int quantity;
        string product_name;
        address producer_address;
    }
    mapping(int=>product) public products;
    
    
    // Order Structure

    struct order{
        int id;
        int product_id;
        int quantity;
        string customer_name;
        string status;
        string delivery_address;
        address customer_address;
    }
    mapping(int => order) public orders;
    
    // Checks if Producer name is valid like if it is not of length 0

    modifier registerNewProducerAuth() {
        require(bytes(producers[msg.sender]).length == 0);
        _;
    }
    
    // Checks if Product name is valid like if it is not of length 0
    
    modifier addNewProductAuth() {
        require(bytes(producers[msg.sender]).length > 0);
        _;
    }
    
    //This function returns total product
    
    function getTotalProduct() view public returns (int) {
        return totalProduct;
    }
    
    //This function returns total order 
    
    function getTotalOrder() view public returns (int) {
        return totalOrder;
    }
    
        //Producer Side
    
    //This function checks if any producer is registered or not
    
    function isProducerRegistered(address _addr) view public returns (bool) {
        if(bytes(producers[_addr]).length == 0){
            return (false);
        }else{
            return (true);
        }
    }
    
    //This function gets name from Producer's page and adds a producer 
    
    function registerNewProducer(string memory _name) public registerNewProducerAuth {
        producers[msg.sender] = _name;
    }
    
    function addNewProduct(string memory _pname, int _price, int _quantity) public addNewProductAuth {
        totalProduct += 1;
        products[totalProduct] = product(totalProduct, _price, _quantity, _pname, msg.sender);
    }
    
    //This function counts the number of products and returns the counter
    
    function getTotalProduct(address _addr) view public returns (int) {
        int counter = 0;
        for(int i=1; i<=totalProduct;i++){
            if(products[i].producer_address == _addr){
                counter++;
            }
        }
        return (counter);
    }
    
    //This function gets product Id as parameter and returns order details
    
    function getProductbyId(address _addr, int _pid) view public returns (int, int, int, string memory, bool) {
        require(_pid <= totalProduct);
        
        if(products[_pid].producer_address == _addr){
            return (products[_pid].id, products[_pid].price, products[_pid].quantity, products[_pid].product_name, true);
        }
        return (0,0, 0, "", false);
    }
    
    //This function gets new price and order ID from Producer,s page and updates the price of that product
    
    function newPrice(int _pid, int _newPrice) public {
        require(products[_pid].producer_address == msg.sender);
        products[_pid].price = _newPrice;
    }
    
    //This Function counts number of total orders and returns the counter
    
    function getMyTotalOrder(address _addr) view public returns (int) {
        int counter = 0;
        for(int i=1; i<=totalOrder; i++){
            if(products[orders[i].product_id].producer_address == _addr){
                counter++;
            }
        }
        return (counter);
    }
    
    //This function returns order details for displaying the orders for Producer's page 
    //Details on producer's page are more than Consumer's Page 
    //it returns Order ID,Product ID,Quantity,Consumer's Name,Delivery Address,Status
    
    function getOrderByIdProducer(address _addr,int _oid) view public returns(int,int,int,string memory,string memory,string memory, bool) {
         require(_oid <= totalOrder);
         if(products[orders[_oid].product_id].producer_address==_addr){
             return (orders[_oid].id, orders[_oid].product_id, orders[_oid].quantity, orders[_oid].customer_name, orders[_oid].status, orders[_oid].delivery_address, true);
         }
         return (0,0,0,"","","",false);
    }
    
    //This function takes status given from producer's page and assign that status to that order as Accepted or Rejected
    
    function giveOrderItsStatus(int _oid, string memory _status) public {
        require(products[orders[_oid].product_id].producer_address == msg.sender);
        orders[_oid].status = _status;
    }
    
    // Consumer Side
    
    function getProductById(int _pid) view public returns (int, int, int, string memory) {
        require(_pid <= totalProduct);
        return (products[_pid].id, products[_pid].price, products[_pid].quantity, products[_pid].product_name);
    }
    
    //This function takes product Id, delivery address, quantity as parameter and adds new order and increments totalorder counter by 1
    
    function orderProduct(string memory _cname, string memory _daddress, int _pid, int _quantity) public {
        require(products[_pid].quantity >= _quantity);
        
        totalOrder += 1;
        orders[totalOrder] = order(totalOrder, _pid, _quantity, _cname, "Placed", _daddress, msg.sender);
        products[_pid].quantity -= _quantity;
    }
    
    //This function counts the number of total orders of a consumer and returns the counter
    
    function getTotalOrder(address _addr) view public returns (int) {
        int counter = 0;
        for(int i=1; i <= totalOrder; i++){
            if(_addr == orders[i].customer_address){
                counter++;
            }
        }
        return (counter);
    }
    
    //This function returns order details for displaying the orders for Consumer's page 
    //Details on consumer's page are less than producer's Page 
    //it returns Order ID,Delivery Address,Status
    
    function getOrderByIdConsumer(address _addr, int _oid) view public returns (int,string memory, string memory, bool){
        require(_oid <= totalOrder);
            if(_addr==orders[_oid].customer_address){
                return (orders[_oid].id, orders[_oid].status, orders[_oid].delivery_address, true);
            }
        return (0, "", "", false);
    }

}
