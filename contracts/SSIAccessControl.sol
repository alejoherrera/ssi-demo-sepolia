// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title SSIAccessControl - Demo de Identidad Digital Autosoberana
 * @notice Demuestra principios SSI: control del titular, acceso selectivo,
 *         temporalidad y revocabilidad sobre datos en blockchain.
 *
 * Principios SSI demostrados:
 * 1. Control del titular (Owner) - Solo el dueño gestiona accesos
 * 2. Divulgacion selectiva - Solo direcciones autorizadas ven el dato
 * 3. Acceso temporal - Ventana de 20 segundos (configurable)
 * 4. Revocabilidad - El titular revoca en cualquier momento
 */
contract SSIAccessControl {

    address public owner;
    string  private personalData;
    uint256 public  defaultDuration;

    struct AccessGrant {
        bool    authorized;
        uint256 grantedAt;
        uint256 expiresAt;
        string  purpose;
    }

    mapping(address => AccessGrant) public accessGrants;
    address[] public authorizedList;

    event AccessGranted(address indexed viewer, uint256 expiresAt, string purpose);
    event AccessRevoked(address indexed viewer, string reason);
    event DataAccessed(address indexed viewer, uint256 timestamp);
    event DataUpdated(uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el titular puede realizar esta accion");
        _;
    }

    modifier hasValidAccess() {
        AccessGrant memory grant = accessGrants[msg.sender];
        require(grant.authorized, "No tienes autorizacion");
        require(block.timestamp <= grant.expiresAt, "Tu acceso ha expirado");
        _;
    }

    /// @param _personalData Dato a proteger
    /// @param _defaultDuration Segundos de acceso (ej: 20)
    constructor(string memory _personalData, uint256 _defaultDuration) {
        owner = msg.sender;
        personalData = _personalData;
        defaultDuration = _defaultDuration;
    }

    function grantAccess(address _viewer, string memory _purpose) external onlyOwner {
        require(_viewer != address(0), "Direccion invalida");
        if (!accessGrants[_viewer].authorized) {
            authorizedList.push(_viewer);
        }
        uint256 expiry = block.timestamp + defaultDuration;
        accessGrants[_viewer] = AccessGrant(true, block.timestamp, expiry, _purpose);
        emit AccessGranted(_viewer, expiry, _purpose);
    }

    function grantAccessCustom(
        address _viewer, uint256 _seconds, string memory _purpose
    ) external onlyOwner {
        require(_viewer != address(0) && _seconds > 0);
        if (!accessGrants[_viewer].authorized) {
            authorizedList.push(_viewer);
        }
        uint256 expiry = block.timestamp + _seconds;
        accessGrants[_viewer] = AccessGrant(true, block.timestamp, expiry, _purpose);
        emit AccessGranted(_viewer, expiry, _purpose);
    }

    function revokeAccess(address _viewer, string memory _reason) external onlyOwner {
        require(accessGrants[_viewer].authorized, "No tiene acceso");
        accessGrants[_viewer].authorized = false;
        accessGrants[_viewer].expiresAt = block.timestamp;
        emit AccessRevoked(_viewer, _reason);
    }

    function updatePersonalData(string memory _newData) external onlyOwner {
        personalData = _newData;
        emit DataUpdated(block.timestamp);
    }

    function setDefaultDuration(uint256 _newDuration) external onlyOwner {
        defaultDuration = _newDuration;
    }

    /// @notice Accede al dato (solo con acceso valido y vigente)
    function viewData() external hasValidAccess returns (string memory) {
        emit DataAccessed(msg.sender, block.timestamp);
        return personalData;
    }

    /// @notice El owner siempre puede ver su dato
    function viewDataAsOwner() external view onlyOwner returns (string memory) {
        return personalData;
    }

    function hasAccess(address _viewer) external view returns (bool) {
        AccessGrant memory g = accessGrants[_viewer];
        return g.authorized && block.timestamp <= g.expiresAt;
    }

    function remainingTime(address _viewer) external view returns (uint256) {
        AccessGrant memory g = accessGrants[_viewer];
        if (!g.authorized || block.timestamp > g.expiresAt) return 0;
        return g.expiresAt - block.timestamp;
    }

    function getAccessDetails(address _viewer) external view returns (
        bool authorized, uint256 grantedAt, uint256 expiresAt,
        string memory purpose, uint256 secondsRemaining
    ) {
        AccessGrant memory g = accessGrants[_viewer];
        uint256 rem = 0;
        if (g.authorized && block.timestamp <= g.expiresAt) {
            rem = g.expiresAt - block.timestamp;
        }
        return (g.authorized, g.grantedAt, g.expiresAt, g.purpose, rem);
    }

    function getAuthorizedCount() external view returns (uint256) {
        return authorizedList.length;
    }
}
