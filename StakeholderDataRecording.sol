// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStakeholderRegistry {
    function isRegisteredStakeholder(address stakeholder) external view returns (bool);
    function getRole(address stakeholder) external view returns (uint8);
}

contract StakeholderDataRecordingHybrid {

    IStakeholderRegistry public registry;

    constructor(address registryAddress) {
        registry = IStakeholderRegistry(registryAddress);
    }

    modifier onlyRegistered() {
        require(registry.isRegisteredStakeholder(msg.sender), "You are not a registered stakeholder");
        _;
    }

    enum RoleType { Farmer, Mill, Refinery, Government, Exporter, Importer, Manufacturer, Retailer }

    struct FarmData {
        string batchID;
        string farmName;
        string farmAddress;
        string plantationData;
        string harvestDateTime;
        string ffbQuality;
    }

    struct MillData {
        string batchID;
        string millName;
        string cpoVolume;
        string pkoVolume;
        string sourceRawMaterial;
    }

    struct CertificationData {
        string batchID;
        string productionCode;
        string certNumber;
        string certAgency;
        string issueDate;
        string palmOilGrades;
        string certificationHash;
    }

    struct RefineryData {
        string batchID;
        string refineryName;
        string refineryAddress;
        string refiningBatch;
        string sustainabilityCert;
    }

    struct ExporterData {
        string batchID;
        string shippingDoc;
        string storageStatus;
        string shippingInsurance;
        string productCert;
        string logisticsData;
    }

    struct ImporterData {
        string batchID;
        string receiptDate;
        string productVolume;
        string customsDoc;
        string internalLogistics;
        string inspectionResults;
    }

    struct ManufacturerData {
        string batchID;
        string manufacturerName;
        string manufacturerAddress;
        string processDetails;
        string processingBatch;
        string volumes;
        string productionCode;
        string distributionLocation;
    }

    struct RetailerData {
        string batchID;
        string productionCode;
        string certificationNumber;
        string retailerName;
        string retailerLocation;
        string processingData;
        string purchaseOrderNumber;
    }

    struct TraceabilityReport {
        string batchID;
        string farmName;
        string harvestDate;
        string certNumber;
        string certAgency;
        string palmOilGrades;
        string refineryName;
        string millName;
        string receiptDate;
        string productVolume;
    }

    mapping(address => FarmData[]) public farmRecords;
    mapping(address => MillData[]) public millRecords;
    mapping(address => CertificationData[]) public certificationRecords;
    mapping(address => RefineryData[]) public refineryRecords;
    mapping(address => ExporterData[]) public exporterRecords;
    mapping(address => ImporterData[]) public importerRecords;
    mapping(address => ManufacturerData[]) public manufacturerRecords;
    mapping(address => RetailerData[]) public retailerRecords;

    mapping(string => FarmData) public farmByBatch;
    mapping(string => MillData) public millByBatch;
    mapping(string => CertificationData) public certificationByBatch;
    mapping(string => RefineryData) public refineryByBatch;
    mapping(string => ImporterData) public importerByBatch;

    event CertificationUploaded(string batchID, string certNumber);

    function addFarmData(string memory batchID, string memory farmName, string memory farmAddress, string memory plantationData, string memory harvestDateTime, string memory ffbQuality) public onlyRegistered {
        require(registry.getRole(msg.sender) == uint8(RoleType.Farmer), "Only Farmers can add this data");
        FarmData memory data = FarmData(batchID, farmName, farmAddress, plantationData, harvestDateTime, ffbQuality);
        farmRecords[msg.sender].push(data);
        farmByBatch[batchID] = FarmData(batchID, farmName, "", "", harvestDateTime, ffbQuality);
    }

    function addMillData(string memory batchID, string memory millName, string memory cpoVolume, string memory pkoVolume, string memory sourceRawMaterial) public onlyRegistered {
        require(registry.getRole(msg.sender) == uint8(RoleType.Mill), "Only Mills can add this data");
        MillData memory data = MillData(batchID, millName, cpoVolume, pkoVolume, sourceRawMaterial);
        millRecords[msg.sender].push(data);
        millByBatch[batchID] = MillData(batchID, millName, "", "", "");
    }

    function addCertificationData(string memory batchID, string memory productionCode, string memory certNumber, string memory certAgency, string memory issueDate, string memory palmOilGrades, string memory certificationHash) public onlyRegistered {
        require(registry.getRole(msg.sender) == uint8(RoleType.Government), "Only Government can add this data");
        CertificationData memory data = CertificationData(batchID, productionCode, certNumber, certAgency, issueDate, palmOilGrades, certificationHash);
        certificationRecords[msg.sender].push(data);
        certificationByBatch[batchID] = CertificationData(batchID, "", certNumber, certAgency, issueDate, palmOilGrades, "");
        emit CertificationUploaded(batchID, certNumber);
    }

    function addRefineryData(string memory batchID, string memory refineryName, string memory refineryAddress, string memory refiningBatch, string memory sustainabilityCert) public onlyRegistered {
        require(registry.getRole(msg.sender) == uint8(RoleType.Refinery), "Only Refineries can add this data");
        RefineryData memory data = RefineryData(batchID, refineryName, refineryAddress, refiningBatch, sustainabilityCert);
        refineryRecords[msg.sender].push(data);
        refineryByBatch[batchID] = RefineryData(batchID, refineryName, "", "", "");
    }

    function addExporterData(string memory batchID, string memory shippingDoc, string memory storageStatus, string memory shippingInsurance, string memory productCert, string memory logisticsData) public onlyRegistered {
        require(registry.getRole(msg.sender) == uint8(RoleType.Exporter), "Only Exporters can add this data");
        ExporterData memory data = ExporterData(batchID, shippingDoc, storageStatus, shippingInsurance, productCert, logisticsData);
        exporterRecords[msg.sender].push(data);
    }

    function addImporterData(string memory batchID, string memory receiptDate, string memory productVolume, string memory customsDoc, string memory internalLogistics, string memory inspectionResults) public onlyRegistered {
        require(registry.getRole(msg.sender) == uint8(RoleType.Importer), "Only Importers can add this data");
        ImporterData memory data = ImporterData(batchID, receiptDate, productVolume, customsDoc, internalLogistics, inspectionResults);
        importerRecords[msg.sender].push(data);
        importerByBatch[batchID] = ImporterData(batchID, receiptDate, productVolume, "", "", "");
    }

    function addManufacturerData(string memory batchID, string memory manufacturerName, string memory manufacturerAddress, string memory processDetails, string memory processingBatch, string memory volumes, string memory productionCode, string memory distributionLocation) public onlyRegistered {
        require(registry.getRole(msg.sender) == uint8(RoleType.Manufacturer), "Only Manufacturers can add this data");
        ManufacturerData memory data = ManufacturerData(batchID, manufacturerName, manufacturerAddress, processDetails, processingBatch, volumes, productionCode, distributionLocation);
        manufacturerRecords[msg.sender].push(data);
    }

    function addRetailerData(string memory batchID, string memory productionCode, string memory certificationNumber, string memory retailerName, string memory retailerLocation, string memory processingData, string memory purchaseOrderNumber) public onlyRegistered {
        require(registry.getRole(msg.sender) == uint8(RoleType.Retailer), "Only Retailers can add this data");
        RetailerData memory data = RetailerData(batchID, productionCode, certificationNumber, retailerName, retailerLocation, processingData, purchaseOrderNumber);
        retailerRecords[msg.sender].push(data);
    }

    function getTraceabilityReport(string memory batchID) public view returns (TraceabilityReport memory) {
        require(bytes(farmByBatch[batchID].farmName).length != 0, "Farm data not found");
        require(bytes(certificationByBatch[batchID].certNumber).length != 0, "Certification data not found");
        require(bytes(millByBatch[batchID].millName).length != 0, "Mill data not found");
        require(bytes(refineryByBatch[batchID].refineryName).length != 0, "Refinery data not found");
        require(bytes(importerByBatch[batchID].receiptDate).length != 0, "Importer data not found");

        FarmData memory farm = farmByBatch[batchID];
        CertificationData memory cert = certificationByBatch[batchID];
        MillData memory mill = millByBatch[batchID];
        RefineryData memory ref = refineryByBatch[batchID];
        ImporterData memory imp = importerByBatch[batchID];

        return TraceabilityReport({
            batchID: batchID,
            farmName: farm.farmName,
            harvestDate: farm.harvestDateTime,
            certNumber: cert.certNumber,
            certAgency: cert.certAgency,
            palmOilGrades: cert.palmOilGrades,
            refineryName: ref.refineryName,
            millName: mill.millName,
            receiptDate: imp.receiptDate,
            productVolume: imp.productVolume
        });
    }

    function isBatchReady(string memory batchID) public view returns (bool ready, string memory errorMsg) {
        if (bytes(farmByBatch[batchID].farmName).length == 0) return (false, "Farm data not found");
        if (bytes(certificationByBatch[batchID].certNumber).length == 0) return (false, "Certification data not found");
        if (bytes(millByBatch[batchID].millName).length == 0) return (false, "Mill data not found");
        if (bytes(refineryByBatch[batchID].refineryName).length == 0) return (false, "Refinery data not found");
        if (bytes(importerByBatch[batchID].receiptDate).length == 0) return (false, "Importer data not found");
        return (true, "");
    }
}
