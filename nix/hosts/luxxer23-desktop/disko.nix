# Disk layout, applied by disko at install time:
# a 1G EFI partition and one LUKS container holding LVM with swap and root,
# so a single passphrase unlocks both and the hibernation image stays encrypted.
{
  disko.devices = {
    disk.main = {
      type = "disk";
      # By id, because nvme0n1/nvme1n1 can swap between boots and the other
      # disk (Samsung 970 EVO Plus 1TB) holds Windows, which stays untouched.
      device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S69ENF0WA07081V";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              # Lets the SSD trim freed blocks through the encryption layer.
              settings.allowDiscards = true;
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };

    lvm_vg.pool = {
      type = "lvm_vg";
      lvs = {
        # At least the size of the RAM, so hibernation fits.
        swap = {
          size = "16G";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };
        root = {
          size = "100%FREE";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
