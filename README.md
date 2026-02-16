# SSI Demo - Identidad Digital Autosoberana en Blockchain

Demo educativo que ilustra principios de **Identidad Digital Autosoberana (Self-Sovereign Identity)** usando un smart contract en Ethereum Sepolia, MetaMask y Remix IDE.

## Principios SSI Demostrados

| Principio | Implementacion |
|-----------|---------------|
| **Control del Titular** | Solo el owner del contrato gestiona accesos |
| **Divulgacion Selectiva** | Solo direcciones especificas pueden ver el dato |
| **Acceso Temporal** | Ventana de 20 segundos (configurable) |
| **Revocabilidad** | El titular revoca acceso en cualquier momento |

## Requisitos

- [MetaMask](https://metamask.io/) con red Sepolia configurada
- SepoliaETH para gas (obtener en [Sepolia Faucet](https://sepoliafaucet.com/))
- [Remix IDE](https://remix.ethereum.org/)

## Guia Rapida

### 1. Desplegar el Contrato

1. Abre [Remix IDE](https://remix.ethereum.org/)
2. Crea un archivo `SSIAccessControl.sol` y pega el codigo de `contracts/`
3. Compila con Solidity ^0.8.19
4. En "Deploy & Run", selecciona **Injected Provider - MetaMask**
5. En el constructor ingresa:
   - `_personalData`: `"Cedula: 1-1234-5678"` (o cualquier dato de ejemplo)
   - `_defaultDuration`: `20` (segundos)
6. Deploy -> confirma en MetaMask
7. Copia la direccion del contrato desplegado

### 2. Usar la Interfaz Web

1. Abre `frontend/index.html` en tu navegador
2. Pega la direccion del contrato
3. Conecta MetaMask

**Como Titular (Owner):**
- Ve tu dato protegido
- Otorga acceso temporal a otra direccion
- Revoca acceso cuando quieras

**Como Verificador (otra cuenta):**
- Cambia de cuenta en MetaMask
- Conecta con la misma direccion de contrato
- Veras el countdown de 20 segundos
- Intenta ver el dato antes de que expire

### 3. Demo Paso a Paso

1. **Owner despliega** el contrato con un dato personal
2. **Owner otorga** acceso temporal a un verificador
3. **Verificador** tiene 20 segundos para ver el dato
4. **Despues de 20s** el acceso expira automaticamente
5. **Owner puede revocar** antes de que expire

## Estructura

```
ssi-demo-sepolia/
├── contracts/
│   └── SSIAccessControl.sol    # Smart contract
├── frontend/
│   └── index.html              # Interfaz web (MetaMask + ethers.js)
├── README.md
└── LICENSE
```

## Stack Tecnologico

- **Solidity ^0.8.19** — Smart contract
- **Ethereum Sepolia** — Testnet
- **MetaMask** — Wallet
- **ethers.js v6** — Biblioteca Web3
- **Remix IDE** — Compilacion y despliegue

## Licencia

MIT
