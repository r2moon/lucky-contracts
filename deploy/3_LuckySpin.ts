import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { DeployFunction } from 'hardhat-deploy/types';
import { getChainId } from 'hardhat';
import config from './config.json';

const deployLuckySpin: DeployFunction = async (
  hre: HardhatRuntimeEnvironment,
) => {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const chainId = await getChainId();
  const luckyTreasury = await deployments.get('LuckyTreasury');

  await deploy('LuckySpin', {
    from: deployer,
    args: [
      luckyTreasury.address,
      config[chainId].vrfCoordinator,
      config[chainId].linkToken,
      config[chainId].vrfFee,
      config[chainId].vrfKeyhash,
    ],
    log: true,
  });
};

deployLuckySpin.tags = ['LuckySpin'];

export default deployLuckySpin;
