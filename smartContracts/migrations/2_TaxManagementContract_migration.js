const TaxManagement = artifacts.require("TaxManagement");

module.exports = function(deployer) {
  deployer.deploy(TaxManagement);
};
