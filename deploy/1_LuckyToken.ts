import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { DeployFunction } from 'hardhat-deploy/types';

const deployLuckyToken: DeployFunction = async (
  hre: HardhatRuntimeEnvironment,
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy('LuckyToken', {
    from: deployer,
    args: [],
    log: true,
  });
};

deployLuckyToken.tags = ['LuckyToken'];

export default deployLuckyToken;
