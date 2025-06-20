// scripts/01_deploy.js
// ──────────────────────────────────────────────────────────────
// Деплой всех 10 контрактов в сеть, указанную флагом --network
// Совместим с ethers v6 (Hardhat 2.22+).
// ──────────────────────────────────────────────────────────────

const { ethers } = require("hardhat");

// маленький helper, чтобы не дублировать 3 строки при каждом деплое
async function deploy(name, args = []) {
  const Factory  = await ethers.getContractFactory(name);
  const instance = await Factory.deploy(...args);
  await instance.waitForDeployment();
  return instance;
}

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploy from:", deployer.address, "\n");

  // 1. StaticConfig
  const staticCfg = await deploy("StaticConfig", ["v1.0.0"]);

  // 2. Permissions & Events
  const perms  = await deploy("Permissions", [deployer.address]);
  const evHub  = await deploy("Events");

  // 3. ProxyAdmin
  const admin  = await deploy("ProxyAdmin", [deployer.address]);

  // 4. AppRegistry (структура через объект-литерал)
  const AppRegistry = await ethers.getContractFactory("AppRegistry");
  const registry = await AppRegistry.deploy({
    proxyAdmin:   await admin.getAddress(),
    permissions:  await perms.getAddress(),
    events:       await evHub.getAddress(),
    staticConfig: await staticCfg.getAddress()
  });
  await registry.waitForDeployment();

  // 5. Логики
  const implA = await deploy("LogicA", [await registry.getAddress()]);
  const implB = await deploy("LogicB", [await registry.getAddress()]);
  const implC = await deploy("LogicC", [await registry.getAddress()]);

  // 6. Прокси (EIP-1967) для каждой логики
  const Proxy  = await ethers.getContractFactory("Proxy");

  // LogicA — сразу вызываем setValue(42) через delegatecall
  const initA  = implA.interface.encodeFunctionData("setValue", [42]);
  const proxyA = await Proxy.deploy(
    await implA.getAddress(),
    await admin.getAddress(),
    initA
  );
  await proxyA.waitForDeployment();

  // LogicB
  const proxyB = await Proxy.deploy(
    await implB.getAddress(),
    await admin.getAddress(),
    "0x"
  );
  await proxyB.waitForDeployment();

  // LogicC
  const proxyC = await Proxy.deploy(
    await implC.getAddress(),
    await admin.getAddress(),
    "0x"
  );
  await proxyC.waitForDeployment();

  // 7. Итоговые адреса
  console.table({
    StaticConfig : await staticCfg.getAddress(),
    Permissions  : await perms.getAddress(),
    Events       : await evHub.getAddress(),
    ProxyAdmin   : await admin.getAddress(),
    AppRegistry  : await registry.getAddress(),
    LogicA_impl  : await implA.getAddress(),
    LogicA_proxy : await proxyA.getAddress(),
    LogicB_impl  : await implB.getAddress(),
    LogicB_proxy : await proxyB.getAddress(),
    LogicC_impl  : await implC.getAddress(),
    LogicC_proxy : await proxyC.getAddress()
  });
}

// точка входа
main()
  .then(() => process.exit(0))
  .catch((err) => { console.error(err); process.exit(1); });
