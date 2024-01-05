pragma solidity >=0.8.0 <0.9.0;

contract DoSDetector{

    mapping(address => uint256) public requestTimestamp;
    mapping(address => uint256) public requestCount;

    uint256 constant public maxRequests = 10; // Maximum allowed requests per time period
    uint256 constant public cooldownPeriod = 1 minutes; // Cooldown period in seconds

    // Function to perform an action with DoS protection
    function performAction(address _device) public {
        require(checkDoSProtection(_device), "DoS protection: Too many requests");

        // Your action code here
              
        // Update request count and timestamp
        requestCount[_device]++;
        requestTimestamp[_device] = block.timestamp;
    }

    // Function to check DoS protection criteria
    function checkDoSProtection(address user) internal returns (bool) {
        if (block.timestamp - requestTimestamp[user] >= cooldownPeriod) {
            // If the cooldown period has passed, reset the request count
            requestCount[user] = 0;
        }

        if (requestCount[user] < maxRequests) {
            return true; // Allow the request
        }

        return false; // Reject the request
    }
}
