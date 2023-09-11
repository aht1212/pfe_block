// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// // Contrat pour la gestion des taxes

contract TaxManagement {



    event AgentAjoute(uint id, address indexed agentAddress, string nom, string prenom, string adresse, string email, uint256 telephone);
  event ContribuableAjoute(uint id, address indexed contribuableAddress, string nom, string prenom, string adresse, string email, uint256 telephone);
  event CommerceAjoute(uint id, string nom, string adresse, address indexed contribuableAddress, uint valeurLocative, uint typeCommerce, address indexed agentAddress);
  event TypeCommerceAjoute(uint id, string nom, uint droitFixeAnnuel, string description);
    address public admin;
    mapping(address => bool) public estAgent;
    mapping(address => bool) public estContribuable;
    mapping(address => Admin) public admins;
    mapping(address => Agent) public agents;
    mapping(address => Contribuable) public contribuables;
    mapping(uint => Commerce) public commerces;
    mapping(uint => TypeCommerce) public typesCommerce;
    mapping(uint => Patente) public patentes;

    uint public contribuableCount = 0;
    uint public commerceCount = 0;
    uint public typeCommerceCount = 0;
    uint public agentCount = 0; 
    uint public patentesCount= 0; 

    uint public currentYear = 2023; 

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
        uint valeurLocative;
        uint typeCommerce;
        address agentAddress; // Adresse Ethereum de l'agent qui ajoute le commerce
        bool estEnregistre;
    }
    
    struct TypeCommerce {
        uint id;
        string nom;
        uint droitFixeAnnuel;
        string description; 
        bool estEnregistre;
    }

    struct Patente {
    uint id;
    uint commerceId;
    uint typeCommerceId;
    uint droitFixe;
    uint droitProportionnel;
    uint anneePaiement;
    bool estPayee;
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
    
    function ajouterAgent(address _ethAddress, string memory _nom, string memory _prenom, string memory _adresse, string memory _email, uint _telephone) public seulementAdmin {
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
    
    function ajouterCommerce(string memory _nom, string memory _adresse, address _contribuableAddress, uint _valeurLocative, uint _typeCommerce) public seulementAgent {
        require(estContribuable[_contribuableAddress], "Le contribuable doit etre enregistre pour ajouter un commerce.");
        require(typeCommerceCount>0 , "Vous devez creer un type de commerce d'abord");
       
       
        Commerce memory nouveauCommerce = Commerce({
            id: commerceCount,
            nom: _nom,
            adresse: _adresse,
            contribuableAddress: _contribuableAddress,
            valeurLocative: _valeurLocative,
            typeCommerce: _typeCommerce,
            agentAddress: msg.sender, // Adresse Ethereum de l'agent qui ajoute le commerce
            estEnregistre: true
        });
        
        commerces[commerceCount] = nouveauCommerce;
        commerceCount++;    

    emit CommerceAjoute(commerceCount, _nom, _adresse, _contribuableAddress, _valeurLocative, _typeCommerce, msg.sender);
    commerceCount++;
    }
    
    function ajouterTypeCommerce( string memory _nom, uint _droitFixeAnnuel, string memory _description) public seulementAdmin {
        TypeCommerce memory nouveauTypeCommerce = TypeCommerce({
            id: typeCommerceCount,
            nom: _nom,
            droitFixeAnnuel: _droitFixeAnnuel,
            description: _description,
            estEnregistre: true
        });
        
        typesCommerce[typeCommerceCount] = nouveauTypeCommerce;
     emit TypeCommerceAjoute(typeCommerceCount, _nom, _droitFixeAnnuel, _description);
    typeCommerceCount++;
    }

    function creerPatente(uint commerceId, uint anneePaiement) public seulementContribuable {
    require(!patentes[commerceId].estPayee, "Une patente a deja ete payee pour cette annee.");
    
    // Recuperer le commerce correspondant
    Commerce storage commerce = commerces[commerceId];
    
    // Recuperer le type de commerce correspondant
    uint typeCommerceId = commerce.typeCommerce;
    TypeCommerce storage typeCommerce = typesCommerce[typeCommerceId];
    
    // Calculer le droit fixe et le droit proportionnel
    uint droitFixe = typeCommerce.droitFixeAnnuel;
    uint droitProportionnel = commerce.valeurLocative * typeCommerce.droitFixeAnnuel / 100;
    
    // Verifier que le droit proportionnel est superieur ou egal a un quart du droit fixe
    if (droitProportionnel < droitFixe / 4) {
        droitProportionnel = droitFixe / 4;
    }
    
    // Creer la patente
    Patente memory nouvellePatente = Patente({
        id: patentesCount,
        commerceId: commerceId,
        typeCommerceId: typeCommerceId,
        droitFixe: droitFixe,
        droitProportionnel: droitProportionnel,
        anneePaiement: anneePaiement,
        estPayee: false
    });
    patentes[patentesCount] = nouvellePatente;
    patentesCount++;
    
    // Stocker l'ID de la patente dans le commerce correspondant
    // commerce.patenteId = nouvellePatente.id;
}
function payerPatente(uint patenteId) public seulementContribuable {
    require(!patentes[patenteId].estPayee, "Cette patente a deja ete payee.");
    
    // Mettre à jour la propriété estPayee de la patente
    patentes[patenteId].estPayee = true;
    
    // Mettre à jour l'année de paiement de la patente
    patentes[patenteId].anneePaiement = 2024; // Mettre l'année de paiement suivante ici
}


    function getTypeUtilisateur(address _adresse) public view returns (string memory) {
        if (estAgent[_adresse]) {
            return "Agent";
        } else if (estContribuable[_adresse]) {
            return "Contribuable";
        } else if (_adresse == admin) {
            return "Admin";
        } else {
            return "Inconnu";
        }
    }

function supprimerAgent(address _ethAddress) public seulementAdmin {
    require(estAgent[_ethAddress], "Cet agent n'est pas enregistre.");
    estAgent[_ethAddress] = false;
    delete agents[_ethAddress];
}
function supprimerContribuable(address _ethAddress) public seulementAdmin {
    require(estContribuable[_ethAddress], "Ce contribuable n'est pas enregistre.");
    estContribuable[_ethAddress] = false;
    delete contribuables[_ethAddress];
}
function modifierAgent(address _ethAddress, string memory _nom, string memory _prenom, string memory _adresse, string memory _email, uint _telephone) public seulementAdmin {
    require(estAgent[_ethAddress], "Cet agent n'est pas enregistre.");
    Agent storage agent = agents[_ethAddress];
    agent.nom = _nom;
    agent.prenom = _prenom;
    agent.adresse = _adresse;
    agent.email = _email;
    agent.telephone = _telephone;
}
function modifierContribuable(address _ethAddress, string memory _nom, string memory _prenom, string memory _adresse, string memory _email, uint _telephone) public seulementAdmin {
    require(estContribuable[_ethAddress], "Ce contribuable n'est pas enregistre.");
    Contribuable storage contribuable = contribuables[_ethAddress];
    contribuable.nom = _nom;
    contribuable.prenom = _prenom;
    contribuable.adresse = _adresse;
    contribuable.email = _email;
    contribuable.telephone = _telephone;
}
function supprimerTypeCommerce(uint _id) public seulementAdmin {
    require(typesCommerce[_id].estEnregistre, "Ce type de commerce n'est pas enregistre.");
    typesCommerce[_id].estEnregistre = false;
    delete typesCommerce[_id];
}
function modifierTypeCommerce(uint _id, string memory _nom, uint _droitFixeAnnuel, string memory _description) public seulementAdmin {
    require(typesCommerce[_id].estEnregistre, "Ce type de commerce n'est pas enregistre.");
    TypeCommerce storage typeC = typesCommerce[_id];
    typeC.nom = _nom;
    typeC.droitFixeAnnuel = _droitFixeAnnuel;
    typeC.description = _description;
}
function supprimerCommerce(uint _id) public seulementAdmin {
    require(commerces[_id].estEnregistre, "Ce commerce n'est pas enregistre.");
    // require(commerces[_id].agentAddress == msg.sender, "Vous n'etes pas autorise a supprimer ce commerce.");
    commerces[_id].estEnregistre = false;
    delete commerces[_id];
}
function modifierCommerce(uint _id, string memory _nom, string memory _adresse, uint _valeurLocative, uint _typeCommerce) public seulementAdmin {
    require(commerces[_id].estEnregistre, "Ce commerce n'est pas enregistre.");
    // require(commerces[_id].agentAddress == msg.sender, "Vous n'etes pas autorise a modifier ce commerce.");
    Commerce storage commerce = commerces[_id];
    commerce.nom = _nom;
    commerce.adresse = _adresse;
    commerce.valeurLocative = _valeurLocative;
    commerce.typeCommerce = _typeCommerce;
}

// il manque la gestion de la taxe dans ce contrat ?
}
