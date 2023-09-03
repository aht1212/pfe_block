const TaxManagement = artifacts.require("TaxManagement");

contract("TaxManagement", accounts => {
  it("devrait afficher les événements", async () => {
    const taxManagement = await TaxManagement.deployed();

    // Ecouter l'événement AgentAjoute
    taxManagement.AgentAjoute({}, { fromBlock: 0, toBlock: 'latest' }).watch((error, result) => {
      console.log("Agent ajouté : ", result.args);
    });

    // Ecouter l'événement ContribuableAjoute
    taxManagement.ContribuableAjoute({}, { fromBlock: 0, toBlock: 'latest' }).watch((error, result) => {
      console.log("Contribuable ajouté : ", result.args);
    });

    // Ecouter l'événement CommerceAjoute
    taxManagement.CommerceAjoute({}, { fromBlock: 0, toBlock: 'latest' }).watch((error, result) => {
      console.log("Commerce ajouté : ", result.args);
    });

    // Ecouter l'événement TypeCommerceAjoute
    taxManagement.TypeCommerceAjoute({}, { fromBlock: 0, toBlock: 'latest' }).watch((error, result) => {
      console.log("Type de commerce ajouté : ", result.args);
    });
  });
});
