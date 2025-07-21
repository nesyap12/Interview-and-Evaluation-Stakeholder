// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStakeholderDataRecordingHybrid {
    function getTraceabilityReport(string memory) external view returns (
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory
    );
}

contract TraceabilityViewQR {
    IStakeholderDataRecordingHybrid public dataContract;

    constructor(address contractAddress) {
        dataContract = IStakeholderDataRecordingHybrid(contractAddress);
    }

    function viewTraceByBatch(string memory batchID) public view returns (
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory
    ) {
        return dataContract.getTraceabilityReport(batchID);
    }
}
