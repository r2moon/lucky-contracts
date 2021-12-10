import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { DeployFunction } from 'hardhat-deploy/types';

const deployLuckyTreasury: DeployFunction = async (
  hre: HardhatRuntimeEnvironment,
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy('LuckyTreasury', {
    from: deployer,
    args: [],
    log: true,
  });
};

deployLuckyTreasury.tags = ['LuckyTreasury'];

export default deployLuckyTreasury;
