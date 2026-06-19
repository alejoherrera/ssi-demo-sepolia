# Taller: Identidad Digital Autosoberana en Blockchain

Demostración práctica de los principios de **Identidad Digital Autosoberana (Self-Sovereign Identity, SSI)** usando el contrato `SSIAccessControl.sol` sobre la testnet **Ethereum Sepolia**, MetaMask y Remix IDE.

> Modalidad: **demo guiada por el docente + práctica de estudiantes**. Duración estimada: ~75 minutos.

---

## 1. Objetivos

Al terminar el taller, el estudiante podrá:

1. Desplegar un contrato inteligente de control de acceso en Sepolia.
2. Otorgar y **revocar** acceso temporal a un dato personal, demostrando los 4 principios SSI.
3. Verificar en un explorador de bloques (Sepolia Etherscan) las transacciones y eventos.
4. Analizar la tensión entre la **inmutabilidad** de blockchain y los **derechos del titular** (acceso, rectificación, supresión) en el marco legal costarricense.

### Principios SSI que se demuestran

| Principio | Cómo lo demuestra el contrato |
|-----------|-------------------------------|
| **Control del titular** | Solo el `owner` puede otorgar o revocar accesos (`onlyOwner`). |
| **Divulgación selectiva** | Solo direcciones autorizadas pueden leer el dato (`hasValidAccess`). |
| **Temporalidad** | El acceso expira automáticamente tras una ventana configurable (10 días por defecto). |
| **Revocabilidad** | El titular revoca el acceso en cualquier momento (`revokeAccess`). |

---

## 2. Prerrequisitos

Antes del taller cada estudiante debe tener listo (ver la **"Guía: instalar MetaMask, configurar Sepolia y usar Remix"** ya publicada en el aula):

- [ ] MetaMask instalado en el navegador.
- [ ] Red **Sepolia** activada y seleccionada.
- [ ] Saldo de **SepoliaETH** de prueba obtenido del faucet (para pagar el gas).
- [ ] Acceso a [Remix IDE](https://remix.ethereum.org/).
- [ ] La dirección `0x...` de un compañero a mano (será tu "verificador").

**Recursos del taller:**
- Repositorio: `github.com/alejoherrera/ssi-demo-sepolia`
- Contrato: `contracts/SSIAccessControl.sol`
- Frontend (opcional): `alejoherrera.github.io/ssi-demo-sepolia/`

---

## 3. Roles

El contrato modela dos roles. En esta práctica cada estudiante hace de **Titular** de su propio contrato y de **Verificador** del contrato de un compañero.

- **Titular (Owner):** despliega el contrato, guarda su dato personal de ejemplo, otorga y revoca accesos.
- **Verificador (Viewer):** recibe acceso temporal, intenta leer el dato y comprueba la expiración.

---

## 4. Bloque 1 — Contexto (docente, 5 min)

El docente repasa los 4 principios SSI y anticipa qué función del contrato demuestra cada uno. Remite a la teoría de la Semana 4 (identidad autosoberana, DIDs, credenciales verificables, divulgación selectiva).

---

## 5. Bloque 2 — Demo guiada (docente proyecta, 20 min)

El docente realiza el recorrido completo mientras los estudiantes observan:

1. Abrir Remix → crear `SSIAccessControl.sol` → pegar el código desde el repositorio.
2. Compilar con Solidity `^0.8.19`.
3. En **Deploy & Run** seleccionar **Injected Provider - MetaMask** (red Sepolia).
4. En el constructor ingresar:
   - `_personalData`: `"Cedula: 1-1234-5678"` (dato de ejemplo, NUNCA un dato real).
   - `_defaultDuration`: `864000` (10 días, en segundos = 10 x 24 x 3600).
5. **Deploy** → confirmar en MetaMask.
6. Mostrar en vivo:
   - `viewDataAsOwner()` — el titular siempre ve su dato.
   - `grantAccess(<dir_verificador>, "Verificacion de identidad")` — otorgar acceso.
   - `remainingTime(<dir_verificador>)` — el countdown.
   - `viewData()` desde la cuenta del verificador — lectura autorizada.
   - `revokeAccess(<dir_verificador>, "Fin de la verificacion")` — revocar.
   - `viewData()` nuevamente — ahora falla ("Tu acceso ha expirado" / "No tienes autorizacion").
7. Abrir la dirección del contrato en **Sepolia Etherscan** y leer los eventos `AccessGranted` / `AccessRevoked`.

> **Para la demo en vivo del bloqueo** (la ventana por defecto es de 10 días, así que no se puede esperar a que expire en clase): usar `grantAccessCustom(<dir>, 60, "demo")` para una ventana de 60 segundos, o demostrar el bloqueo con `revokeAccess` (corte inmediato).

---

## 6. Bloque 3 — Práctica de estudiantes (30 min)

Cada estudiante repite el recorrido con su propio contrato:

1. **Despliega** tu contrato en Sepolia (constructor con un dato de ejemplo y `864000` = 10 días).
   - Copia y guarda la **dirección del contrato**.
2. **Otorga acceso** a la dirección de un compañero: `grantAccess(<dir_companero>, "Taller SSI")`.
   - Anota el **hash de la transacción**.
3. Tu compañero (como verificador) ejecuta `viewData()` y confirma que **ve el dato**.
4. **Revoca** el acceso: `revokeAccess(<dir_companero>, "Cierre del taller")`.
5. El compañero ejecuta `viewData()` otra vez y confirma que **ya no puede leer** el dato.
6. Abre tu contrato en **Sepolia Etherscan** y localiza los eventos.

> **Tip:** para no esperar, en lugar de la expiración por tiempo demuestra el bloqueo con la revocación. Si querés mostrar la expiración automática, usá `grantAccessCustom(<dir>, 120, "prueba")` (2 minutos).

---

## 7. Bloque 4 — Cierre jurídico (docente + grupo, 10 min)

Discusión dirigida:

- ¿El dato almacenado on-chain respeta el **derecho de acceso** del titular? ¿Y el de **rectificación** (`updatePersonalData`)?
- Si la blockchain es **inmutable**, ¿cómo se ejerce el **derecho de supresión**? ¿Basta con revocar el acceso si el dato sigue en el historial de la cadena?
- Patrón recomendado: **hash on-chain + dato off-chain** (el dato sensible nunca va a la cadena; on-chain solo va una prueba criptográfica).
- ¿Un hash es un dato personal? ¿Cuándo blockchain agrega valor real frente al hype?

### Enfoque por curso

- **CIB-205 (Aspectos Culturales, Éticos y Regulatorios):** conectar con la **Ley 8968** (autodeterminación informativa, derechos ARCO, deber de seguridad y confidencialidad) y la **PRODHAB**. La tensión inmutabilidad vs. derecho de supresión es el eje del análisis.
- **COMP-04 (Derecho Informático):** conectar con la **protección de datos personales** y la **autodeterminación informativa** (art. 24 Constitución, Ley 8968), y la validez jurídica de un control de acceso técnico como medida de seguridad.

---

## 8. Entregable (calificable)

Cada estudiante entrega un documento (PDF) con:

1. **Dirección del contrato** desplegado en Sepolia (enlace a Sepolia Etherscan).
2. Captura de la transacción de **`grantAccess`** (hash + evento `AccessGranted`).
3. Captura de **`viewData` exitoso** (acceso vigente) **y** del intento **bloqueado** tras revocar/expirar.
4. Captura de la transacción de **`revokeAccess`**.
5. **Análisis breve (≤ 1 página)** con el enfoque de tu curso (ver Bloque 4).

---

## 9. Rúbrica (100 pts)

| Criterio | Pts |
|---|---|
| Contrato desplegado y verificable en Sepolia | 20 |
| Otorgamiento de acceso correcto (tx + evento) | 15 |
| Demostración de acceso vigente y bloqueo tras expiración/revocación | 20 |
| Revocación ejecutada correctamente | 15 |
| Análisis jurídico/regulatorio con el enfoque del curso | 25 |
| Claridad y completitud de la evidencia (capturas legibles) | 5 |
| **Total** | **100** |

---

## 10. Anexo A — Referencia rápida de funciones

| Función | Quién | Para qué |
|---|---|---|
| `viewDataAsOwner()` | Titular | Ver siempre su propio dato. |
| `grantAccess(viewer, purpose)` | Titular | Otorgar acceso por la duración por defecto. |
| `grantAccessCustom(viewer, seconds, purpose)` | Titular | Otorgar acceso por una ventana específica. |
| `revokeAccess(viewer, reason)` | Titular | Revocar acceso de inmediato. |
| `updatePersonalData(newData)` | Titular | Rectificar el dato (derecho de rectificación). |
| `viewData()` | Verificador | Leer el dato si tiene acceso vigente. |
| `hasAccess(viewer)` | Cualquiera | Consultar si una dirección tiene acceso vigente. |
| `remainingTime(viewer)` | Cualquiera | Segundos restantes de acceso. |
| `getAccessDetails(viewer)` | Cualquiera | Detalle completo del permiso. |

## 11. Anexo B — Solución de problemas

- **"Solo el titular puede realizar esta accion"**: estás usando una cuenta distinta a la que desplegó el contrato. Cambiá a la cuenta titular en MetaMask.
- **"No tienes autorizacion" / "Tu acceso ha expirado"**: el verificador no tiene acceso vigente; el titular debe ejecutar `grantAccess` (o ya expiró/se revocó).
- **La transacción no confirma**: revisá que estés en **Sepolia** y que tengas **SepoliaETH** para gas.
- **No aparece "Injected Provider - MetaMask"**: confirmá la conexión de la cuenta en la ventana emergente de MetaMask.
- **Nunca uses datos reales**: este es un entorno de prueba público; cualquier dato on-chain queda visible permanentemente.

---

## 12. Anexo C — Explicación del contrato

**Idea central:** el contrato guarda un dato personal y solo el **titular** decide quién lo ve, por cuánto tiempo, y puede cortar el acceso cuando quiera. Eso es identidad autosoberana: el control lo tiene el dueño, no un tercero.

**Variables de estado**
- `owner`: quien despliega el contrato (el titular del dato).
- `personalData`: el dato protegido. Es `private` en Solidity, pero *private* solo significa que otros contratos no lo leen por código; **en la cadena pública el valor igual es visible**. Por eso, en el cierre jurídico, discutimos qué NUNCA poner on-chain.
- `defaultDuration`: cuántos segundos dura un acceso por defecto. En este taller usamos **864000 = 10 días** (antes el demo usaba 1800 = 30 min).

**`AccessGrant` + `accessGrants`**: por cada dirección autorizada se guarda si tiene acceso, cuándo se otorgó, cuándo expira y el motivo. Modela la **divulgación selectiva** y la **temporalidad**.

**Modificadores (controles de seguridad)**
- `onlyOwner`: solo el titular ejecuta acciones sensibles → **control del titular**.
- `hasValidAccess`: deja leer el dato solo si la dirección está autorizada **y** no expiró → **temporalidad**.

**`constructor(_personalData, _defaultDuration)`**: al desplegar, define el dato y la duración por defecto (aquí, `864000`).

**Funciones clave**
- `grantAccess(viewer, purpose)`: otorga acceso por la duración por defecto (10 días) → **divulgación selectiva**.
- `grantAccessCustom(viewer, seconds, purpose)`: otorga por una ventana específica (útil para demostrar la expiración en clase sin esperar días, ej. 120 seg).
- `revokeAccess(viewer, reason)`: corta el acceso de inmediato → **revocabilidad**.
- `viewData()`: el verificador lee el dato **solo** si tiene acceso vigente; emite el evento `DataAccessed` (queda traza).
- `updatePersonalData(newData)`: el titular rectifica el dato → análogo al **derecho de rectificación** (ARCO).
- `remainingTime` / `hasAccess` / `getAccessDetails`: consultas de solo lectura (no gastan gas).

**Eventos** (`AccessGranted`, `AccessRevoked`, `DataAccessed`, `DataUpdated`): son el "registro de auditoría" público que se verifica en Sepolia Etherscan.

---

## 13. Anexo D — Cómo leer el recibo de la transacción (deploy)

Al desplegar, Remix muestra un recibo. Así se lee cada campo:

| Campo | Qué significa |
|---|---|
| `status` | **1 = éxito** ("Transaction mined and execution completed"); 0 = falló. |
| `transaction hash` | Identificador único de la transacción. Sirve para buscarla en Sepolia Etherscan. |
| `block number` / `block hash` | El bloque que incluyó la transacción (su lugar en la cadena). |
| `contract address` | **La dirección del contrato recién creado.** Solo aparece en transacciones de despliegue. Es la que se copia y se usa después. |
| `from` | La cuenta que firmó y pagó (el titular/desplegador). |
| `to` | En un deploy aparece como `NombreContrato.(constructor)`. |
| `transaction cost` | El **gas** consumido (en Sepolia se paga con SepoliaETH de prueba). |
| `decoded input` | Los argumentos del constructor que enviaste, ej. `_personalData` y `_defaultDuration = 864000`. |
| `logs` / `raw logs` | Los **eventos** emitidos. El constructor de este contrato no emite eventos, por eso van vacíos; `grantAccess`/`revokeAccess` sí generan logs. |

**Mensajes de verificación de código fuente** (al final del recibo):
- `Etherscan verification skipped: API key not provided` → solo significa que no se publicó el código en Etherscan por falta de API key; **no es un error** y no afecta al contrato.
- `[Sourcify] Verification Successful!` / `[Blockscout] Verification Successful!` → el **código fuente quedó verificado y público** en esos exploradores: cualquiera puede leer el código real detrás del contrato (transparencia, un punto a favor para la discusión de confianza/SSI).
