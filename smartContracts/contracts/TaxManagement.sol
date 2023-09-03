// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// // Contrat pour la gestion des taxes

contract TaxManagement {



    event AgentAjoute(uint id, address indexed agentAddress, string nom, string prenom, string adresse, string email, uint256 telephone);
  event ContribuableAjoute(uint id, address indexed contribuableAddress, string nom, string prenom, string adresse, string email, uint256 telephone);
  event CommerceAjoute(uint id, string nom, string adresse, address indexed contribuableAddress, uint chiffreAffairesAnnuel, uint typeCommerce, address indexed agentAddress);
  event TypeCommerceAjoute(uint id, string nom, uint tarifAnnuel, string description);
    address public admin;
    mapping(address => bool) public estAgent;
    mapping(address => bool) public estContribuable;
    mapping(address => Admin) public admins;
    mapping(address => Agent) public agents;
    mapping(address => Contribuable) public contribuables;
    mapping(uint => Commerce) public commerces;
    mapping(uint => TypeCommerce) public typesCommerce;
    
    uint public contribuableCount = 0;
    uint public commerceCount = 0;
    uint public typeCommerceCount = 0;
    uint public agentCount = 0; 
    struct Admin {
        uint id;
        string nom;
        string prenom;
        string adresse;
        string email;
        uint telephone;
        bool estEnregistre;
    }
    
    struct Agent {
        uint id;
        address ethAddress; // Adresse Ethereum de l'agent
        string nom;
        string prenom;
        string adresse;
        string email;
        uint telephone;
        bool estEnregistre;
    }
    
    struct Contribuable {
        uint id;
        address ethAddress; // Adresse Ethereum du contribuable
        string nom;
        string prenom;
        string adresse;
        string email;
        uint telephone;
        bool estEnregistre;
    }
    
    struct Commerce {
        uint id;
        string nom;
        string adresse;
        address contribuableAddress; // Adresse Ethereum du contribuable qui ajoute le commerce
        uint chiffreAffairesAnnuel;
        uint typeCommerce;
        address agentAddress; // Adresse Ethereum de l'agent qui ajoute le commerce
        bool estEnregistre;
    }
    
    struct TypeCommerce {
        uint id;
        string nom;
        uint tarifAnnuel;
        string description; 
        bool estEnregistre;
    }
    
    constructor() {
        admin = msg.sender;
    }
    
    modifier seulementAdmin() {
        require(msg.sender == admin, "Seul l'administrateur peut effectuer cette action.");
        _;
    }
    
    modifier seulementAgent() {
        require(estAgent[msg.sender], "Seuls les agents peuvent effectuer cette action.");
        _;
    }
    
    modifier seulementContribuable() {
        require(estContribuable[msg.sender], "Seuls les contribuables peuvent effectuer cette action.");
        _;
    }
    
    function ajouterAgent( address _ethAddress, string memory _nom, string memory _prenom, string memory _adresse, string memory _email, uint _telephone) public seulementAdmin {
        require(!estAgent[_ethAddress], "Cet agent est deja enregistre.");
        
        Agent memory nouvelAgent = Agent({
            id: agentCount,
            ethAddress: _ethAddress,
            nom: _nom,
            prenom: _prenom,
            adresse: _adresse,
            email: _email,
            telephone: _telephone,
            estEnregistre: true
        });
        
        estAgent[_ethAddress] = true;
        agents[_ethAddress] = nouvelAgent;

            emit AgentAjoute(agentCount, _ethAddress, _nom, _prenom, _adresse, _email, _telephone);
        agentCount++;
    }

    
    function ajouterContribuable( address _ethAddress, string memory _nom, string memory _prenom, string memory _adresse, string memory _email, uint _telephone) public seulementAdmin {
        require(!estContribuable[_ethAddress], "Ce contribuable est deja enregistre.");
        
        Contribuable memory nouveauContribuable = Contribuable({
            id: contribuableCount,
            ethAddress: _ethAddress,
            nom: _nom,
            prenom: _prenom,
            adresse: _adresse,
            email: _email,
            telephone: _telephone,
            estEnregistre: true
        });
        estContribuable[_ethAddress] = true;
        contribuables[_ethAddress] = nouveauContribuable;
            emit ContribuableAjoute(contribuableCount, _ethAddress, _nom, _prenom, _adresse, _email, _telephone);
        contribuableCount++;

    }
    
    function ajouterCommerce(string memory _nom, string memory _adresse, address _contribuableAddress, uint _chiffreAffairesAnnuel, uint _typeCommerce) public seulementAgent {
        require(estContribuable[_contribuableAddress], "Le contribuable doit etre enregistre pour ajouter un commerce.");
        
        Commerce memory nouveauCommerce = Commerce({
            id: commerceCount,
            nom: _nom,
            adresse: _adresse,
            contribuableAddress: _contribuableAddress,
            chiffreAffairesAnnuel: _chiffreAffairesAnnuel,
            typeCommerce: _typeCommerce,
            agentAddress: msg.sender, // Adresse Ethereum de l'agent qui ajoute le commerce
            estEnregistre: true
        });
        
        commerces[commerceCount] = nouveauCommerce;
        commerceCount++;

    emit CommerceAjoute(commerceCount, _nom, _adresse, _contribuableAddress, _chiffreAffairesAnnuel, _typeCommerce, msg.sender);
    commerceCount++;
    }
    
    function ajouterTypeCommerce( string memory _nom, uint _tarifAnnuel, string memory _description) public seulementAdmin {
        TypeCommerce memory nouveauTypeCommerce = TypeCommerce({
            id: typeCommerceCount,
            nom: _nom,
            tarifAnnuel: _tarifAnnuel,
            description: _description,
            estEnregistre: true
        });
        
        typesCommerce[typeCommerceCount] = nouveauTypeCommerce;
     emit TypeCommerceAjoute(typeCommerceCount, _nom, _tarifAnnuel, _description);
    typeCommerceCount++;
    }
}
