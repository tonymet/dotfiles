source="$HOME/VirtualBox VMs"
dest="/Volumes/Time Machine/backup/Anthonys-MBP.socal.rr.com/Users/tonym"

backup-vms() {
  rsync -aP "$source" "$dest"
}