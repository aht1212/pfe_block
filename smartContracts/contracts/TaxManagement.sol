// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// // Contrat pour la gestion des taxes

contract TaxManagement {



  // event AgentAjoute(uint id, address indexed agentAddress, string nom, string prenom, string adresse, string email, uint256 telephone, bool estEnregister);
  // event ContribuableAjoute(uint id, address indexed contribuableAddress, string nom, string prenom, string adresse, string email, uint256 telephone,bool estEnregister);
  // event CommerceAjoute(uint id, string nom, string adresse, address indexed contribuableAddress, uint valeurLocative, uint activitePrincipaleId, address indexed agentAddress, bool estEnregister);
  event patentePayer(uint id,uint contribuableId, uint droitFixe, uint droitProportionnelle, uint annePaiement, uint sommePayee, bool estPayee ); 
    address public admin;
    
    mapping(address => bool) public estAgent;
    mapping(address => bool) public estContribuable;
    mapping(address => Admin) public admins;
    mapping(uint => Agent) public agents;
    mapping(uint => Contribuable) public contribuables;
    // mapping(uint => Commerce) public commerces;
    mapping(uint => ActivitePrincipale) public activitePrincipale;
    mapping(uint => Patente) public patentes;
    string[] public classes = ["Exceptionnelle", '1' , '2', '3', '4', '5', '6','7','8','9']; 

    Agent[] public allAgents;
   
    uint public contribuableCount = 0;
    uint public commerceCount = 0;
    uint public activitePrincipaleCount = 0;
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
        string nif;
        string denomination;
        uint activitePrincipaleId;
        string nom;
        string prenom;
        string adresse;
        string email;
        uint contact;
        uint valeurLocative; 
        string typeContribuable;
        string dateCreation; 
        bool estEnregistre;
    }
    
    // struct Commerce {
    //     uint id;
    //     string nom;
    //     string adresse;
    //     address contribuableAddress; // Adresse Ethereum du contribuable qui ajoute le commerce
    //     uint valeurLocative;
    //     uint activitePrincipale;
    //     address agentAddress; // Adresse 
    // Ethereum de l'agent qui ajoute le commerce
    //     bool estEnregistre;
    // }
    
    struct ActivitePrincipale {
        uint id;
        string nom;
        uint droitFixeAnnuel;
        string description; 
        bool estEnregistre;
    }

    struct Patente {
    uint id;
    uint contribuableId;
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
        agents[agentCount] = nouvelAgent;
        allAgents.push(nouvelAgent); 
            // emit AgentAjoute(agentCount, _ethAddress, _nom, _prenom, _adresse, _email, _telephone, true);
        agentCount++;
    }

    
    function ajouterContribuable(address  _ethAddress, string memory _nif,string memory _denomination,uint  _activitePrincipaleId,   string memory _nom, string memory _prenom, string memory _adresse, string memory _email, uint _contact, string memory _typeContribuable, string memory _dateCreation, uint  _valeurLocative) public seulementAdmin {
        require(!estContribuable[_ethAddress], "Ce contribuable est deja enregistre.");
        
        Contribuable memory nouveauContribuable = Contribuable({
            id: contribuableCount,
            ethAddress: _ethAddress,
            nif : _nif,
            denomination: _denomination, 
            activitePrincipaleId: _activitePrincipaleId, 
            nom: _nom,
            prenom: _prenom,
            adresse: _adresse,
            email: _email,
            contact: _contact,
            valeurLocative : _valeurLocative,
            typeContribuable : _typeContribuable, 
            dateCreation : _dateCreation,  
            estEnregistre: true
        });
        estContribuable[_ethAddress] = true;
        contribuables[contribuableCount] = nouveauContribuable;
            // emit ContribuableAjoute(contribuableCount, _ethAddress, _nom, _prenom, _adresse, _email, _telephone, true);
        contribuableCount++;

    }
    

    
    function ajouterActivitePrincipale( string memory _nom, uint _droitFixeAnnuel, string memory _description) public seulementAdmin {
        ActivitePrincipale memory nouveauActivitePrincipale = ActivitePrincipale({
            id: activitePrincipaleCount,
            nom: _nom,
            droitFixeAnnuel: _droitFixeAnnuel,
            description: _description,
            estEnregistre: true
        });
        
        activitePrincipale[activitePrincipaleCount] = nouveauActivitePrincipale;
    //  emit ActivitePrincipaleAjoute(activitePrincipaleCount, _nom, _droitFixeAnnuel, _description, true);
    activitePrincipaleCount++;
    }

    function creerPatente(uint contribuableId, uint anneePaiement) public seulementAgent() {
    require(!patentes[contribuableId].estPayee, "Une patente a deja ete payee pour cette annee.");

    // Recuperer le contribuable correspondant
    Contribuable storage contribuable = contribuables[contribuableId];
    
    // Recuperer le type de contribuable correspondant
    uint activiteId = contribuable.activitePrincipaleId;
    ActivitePrincipale storage activite = activitePrincipale[activiteId];
    
    // Calculer le droit fixe et le droit proportionnel
    uint droitFixe = activite.droitFixeAnnuel;
    uint droitProportionnel = contribuable.valeurLocative / 10 ;
    
    // Verifier que le droit proportionnel est superieur ou egal a un quart du droit fixe
    if (droitProportionnel < (droitFixe / 4)) {
        droitProportionnel = (droitFixe / 4);
    }
    
    // Creer la patente
    Patente memory nouvellePatente = Patente({
        id: patentesCount,
        contribuableId: contribuableId,
        droitFixe: droitFixe,
        droitProportionnel: droitProportionnel,
        anneePaiement: anneePaiement,
        estPayee: false
    });
    patentes[patentesCount] = nouvellePatente;
    patentesCount++;
    
    // Stocker l'ID de la patente dans le contribuable correspondant
    // contribuable.patenteId = nouvellePatente.id;
}
function payerPatente(uint patenteId, uint sommePayee) public seulementContribuable {
    require(!patentes[patenteId].estPayee, "Cette patente a deja ete payee.");
    
    // Mettre à jour la propriété estPayee de la patente
    if (sommePayee >= (patentes[patenteId].droitProportionnel + patentes[patenteId].droitFixe)) {
      
      patentes[patenteId].estPayee = true;
      emit patentePayer(patenteId, patentes[patenteId].contribuableId, patentes[patenteId].droitFixe, patentes[patenteId].droitProportionnel, patentes[patenteId].anneePaiement, sommePayee, true);

    } else {
      
      emit patentePayer(patenteId, patentes[patenteId].contribuableId, patentes[patenteId].droitFixe, patentes[patenteId].droitProportionnel, patentes[patenteId].anneePaiement, sommePayee, false);

    }
    
    // Envoyer les fonds vers le service des impots
    // Mettre à jour l'année de paiement de la patente
    // patentes[patenteId].anneePaiement = 2024; // Mettre l'année de paiement suivante ici
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
    
    for (uint index = 0; index < agentCount; index++) {
        if(_ethAddress == agents[index].ethAddress){
            agents[index].estEnregistre = false; 
            break;
        }
    }
}
function supprimerContribuable(address _ethAddress) public seulementAdmin {
   for (uint index = 0; index < contribuableCount; index++) {
          if(_ethAddress == contribuables[index].ethAddress){
            contribuables[index].estEnregistre = false;
        }
    }
}
function modifierAgent(address _ethAddress, string memory _nom, string memory _prenom, string memory _adresse, string memory _email, uint _telephone) public seulementAdmin {
    require(estAgent[_ethAddress], "Cet agent n'est pas enregistre.");
        

    for (uint index = 0; index < agentCount; index++) {
        if(_ethAddress == agents[index].ethAddress){
            // agents[index].estEnregistre = false; 
            Agent storage agent = agents[index]; 
            agent.id = agents[index].id; 
            agent.ethAddress = _ethAddress; 
            agent.nom = _nom;
            agent.prenom = _prenom;
            agent.adresse = _adresse;
            agent.email = _email;
            agent.telephone = _telephone;
            agent.estEnregistre = true; 
            break;
        }
    }
   
}
function modifierContribuable(address _ethAddress,string memory _denomination,uint _activitePrincipaleId, string memory _nom, string memory _prenom, string memory _adresse, string memory _email, uint _contact,string memory _typeContribuable,  uint _valeurLocative) public seulementAdmin {
    require(estContribuable[_ethAddress], "Ce contribuable n'est pas enregistre.");
   for (uint index = 0; index < contribuableCount; index++) {
    if(_ethAddress == contribuables[index].ethAddress){
    Contribuable storage contribuable = contribuables[index];
    contribuable.nom = _nom;
    contribuable.prenom = _prenom;
    contribuable.adresse = _adresse;
    contribuable.email = _email;
    contribuable.contact = _contact;
    contribuable.valeurLocative = _valeurLocative; 
    contribuable.activitePrincipaleId= _activitePrincipaleId; 
    contribuable.denomination = _denomination;
    contribuable.typeContribuable = _typeContribuable;
    }
   }
}
function supprimerActivitePrincipale(uint _id) public seulementAdmin {
    require(activitePrincipale[_id].estEnregistre, "Ce type de commerce n'est pas enregistre.");
    activitePrincipale[_id].estEnregistre = false;
    delete activitePrincipale[_id];
}
function modifierActivitePrincipale(uint _id, string memory _nom, uint _droitFixeAnnuel, string memory _description) public seulementAdmin {
    require(activitePrincipale[_id].estEnregistre, "Ce type de commerce n'est pas enregistre.");
    ActivitePrincipale storage typeC = activitePrincipale[_id];
    typeC.nom = _nom;
    typeC.droitFixeAnnuel = _droitFixeAnnuel;
    typeC.description = _description;
}


function getAgents() public view returns (Agent[] memory) {
    Agent[] memory agentsList = new Agent[](agentCount);
    for (uint i = 0; i < agentCount; i++) {
        if(agents[i].estEnregistre){
        agentsList[i] = agents[i];}
    }
    return agentsList;
}

function getContribuables() public view returns (Contribuable[] memory) {
    Contribuable[] memory contribuablesList = new Contribuable[](contribuableCount);
    for (uint i = 0; i <= contribuableCount; i++) {
        if(contribuables[i].estEnregistre){
        contribuablesList[i] = contribuables[i];}
    }
    return contribuablesList;
}

function getPatentesPayer()public view returns (Patente[] memory){
  Patente[] memory patenteList = new Patente[](patentesCount); 
  for (uint index = 0; index < patentesCount; index++) {
    if (patentes[index].estPayee) {
      patenteList[index] = patentes[index]; 
    } 
  }
  return patenteList;
}

function getPatentesNonPayer()public view returns (Patente[] memory){
  Patente[] memory patenteList = new Patente[](patentesCount); 
  for (uint index = 0; index < patentesCount; index++) {
    if (!patentes[index].estPayee) {
      patenteList[index] = patentes[index]; 
    } 
  }
  return patenteList;
}
function getActivitesPrincipales() public view returns (ActivitePrincipale[] memory) {
  ActivitePrincipale[] memory activitesPrincipalesList = new ActivitePrincipale[](activitePrincipaleCount);
  uint counter = 0;
  for (uint id = 0; id < activitePrincipaleCount; id++){
    if(activitePrincipale[id].estEnregistre){
      activitesPrincipalesList[counter] = activitePrincipale[id];
      counter++;
      }
      }
      return activitesPrincipalesList;
}


function getPatenteByContribuable(address _contribuableAdress) public view returns (Patente[] memory) {
  require(estContribuable[_contribuableAdress], "Ce contribuable n'est pas enregistre.");

  Patente[] memory patenteList = new Patente[](patentesCount);
  // Contribuable memory contribuableSelect = new Contribuable(contribuableCount);
    for (uint i = 0; i <= contribuableCount; i++) {
    if(_contribuableAdress == contribuables[i].ethAddress){
        Contribuable memory contribuableSelected = contribuables[i];
        for (uint j=0 ;j<patentesCount;j++){
          if(contribuableSelected.id==patentes[j].contribuableId){
            patenteList[j]=patentes[j];
          }
        }
    }
  
}
return patenteList; 
}

}
