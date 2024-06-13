{ config, lib, ... }:
let
  cfg = config.syde.hardware.nvidia;
in
{
  config = lib.mkIf cfg.enable {
    boot.initrd.kernelModules = [ "nvidia" ];
    boot.blacklistedKernelModules = [ "nouveau" ];

    hardware.nvidia = {
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      modesetting.enable = true;
      open = false;
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.opengl.enable = true;

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_VRR_ALLOWED = "1";
      WLR_DRM_NO_ATOMIC = "1";
    };
  };

  options.syde.hardware.nvidia = {
    enable = lib.mkEnableOption "Enable Nvidia driver configuration";
  };
}
